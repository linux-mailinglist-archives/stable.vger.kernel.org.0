Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD1D2541950
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378667AbiFGVT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381510AbiFGVRt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:17:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFC82236A0;
        Tue,  7 Jun 2022 11:59:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5ED7B8220B;
        Tue,  7 Jun 2022 18:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5751CC385A5;
        Tue,  7 Jun 2022 18:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628341;
        bh=ogeVAfImOn1qB2VO8Ou/l8PWkEnS53s0tsZgViK52kQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sUprCX9jG5soXtKTESTkbgjdDaTft17pvxRXhi8CUnUEJ16WoDRkS5egIaunSKfUK
         Yo3bANFfJm4LkdiKxOM4RThEIjpKuHY/MWvTcMjQGNh7adYKazw4JyZHfzzcGjddCO
         pSYtpyq0oXhpNzdJD3LP41gGx0uf+WDukJYVqiTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 295/879] libbpf: Dont error out on CO-RE relos for overriden weak subprogs
Date:   Tue,  7 Jun 2022 18:56:53 +0200
Message-Id: <20220607165011.410424283@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit e89d57d938c8fa80c457982154ed6110804814fe ]

During BPF static linking, all the ELF relocations and .BTF.ext
information (including CO-RE relocations) are preserved for __weak
subprograms that were logically overriden by either previous weak
subprogram instance or by corresponding "strong" (non-weak) subprogram.
This is just how native user-space linkers work, nothing new.

But libbpf is over-zealous when processing CO-RE relocation to error out
when CO-RE relocation belonging to such eliminated weak subprogram is
encountered. Instead of erroring out on this expected situation, log
debug-level message and skip the relocation.

Fixes: db2b8b06423c ("libbpf: Support CO-RE relocations for multi-prog sections")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220408181425.2287230-2-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index dabf9a1451c3..7af6805a863d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5665,10 +5665,17 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 			insn_idx = rec->insn_off / BPF_INSN_SZ;
 			prog = find_prog_by_sec_insn(obj, sec_idx, insn_idx);
 			if (!prog) {
-				pr_warn("sec '%s': failed to find program at insn #%d for CO-RE offset relocation #%d\n",
-					sec_name, insn_idx, i);
-				err = -EINVAL;
-				goto out;
+				/* When __weak subprog is "overridden" by another instance
+				 * of the subprog from a different object file, linker still
+				 * appends all the .BTF.ext info that used to belong to that
+				 * eliminated subprogram.
+				 * This is similar to what x86-64 linker does for relocations.
+				 * So just ignore such relocations just like we ignore
+				 * subprog instructions when discovering subprograms.
+				 */
+				pr_debug("sec '%s': skipping CO-RE relocation #%d for insn #%d belonging to eliminated weak subprogram\n",
+					 sec_name, i, insn_idx);
+				continue;
 			}
 			/* no need to apply CO-RE relocation if the program is
 			 * not going to be loaded
-- 
2.35.1



