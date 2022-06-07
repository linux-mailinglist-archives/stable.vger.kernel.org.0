Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661765405BD
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346156AbiFGR20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346505AbiFGR0X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:26:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A593710A615;
        Tue,  7 Jun 2022 10:24:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B718B822AF;
        Tue,  7 Jun 2022 17:24:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD28EC34115;
        Tue,  7 Jun 2022 17:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622650;
        bh=C1x3/Pm/7Q+lVwfJV7+jnbeTtLq3Jx8TI5iAVWW98wA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R15KNH6wj5QZ0hXaFNwjd+ZuSgZPHsc0arJr5XhzlDAAgBkhL6Va9XCAqo4GHq2jn
         +lpM25YgDqP08yT/3gVKCSNhoEzeRBcpKVjNTHxGwaL+TeuWFisttZzYW4SLC4R5OU
         VFtBib9KBwfGbJ95tlwYswVBYQlSNxD3GtjmBwTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 135/452] libbpf: Dont error out on CO-RE relos for overriden weak subprogs
Date:   Tue,  7 Jun 2022 18:59:52 +0200
Message-Id: <20220607164912.583382921@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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
index 61df26f048d9..dda8f9cdc652 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5945,10 +5945,17 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
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



