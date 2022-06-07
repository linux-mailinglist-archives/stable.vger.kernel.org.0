Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474E5540B18
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350152AbiFGSYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352164AbiFGSQ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:16:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3E9FD2E;
        Tue,  7 Jun 2022 10:50:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E784B82340;
        Tue,  7 Jun 2022 17:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEB5C36B00;
        Tue,  7 Jun 2022 17:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624250;
        bh=KzaJ1FRibFPYJhAFTsNK5icMJ2UO3L8H+8cyEbXx5Ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EigiQw1KZV0FQxAv0sYCCaWS3i1+D9WNipEwwM8sCSBFXjD3IhydmXuc0AVNvJVaZ
         GKg/Juo1vwnWtsUZkS0s4YenEtj4wIAcDN45QBnrfTnHjVtjSvyOc9G1eYe5uc0F98
         Mmhz/yNrMCl1WL9FYHf2FGl4xaZBY9XgZ/2vhPJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 257/667] libbpf: Fix logic for finding matching program for CO-RE relocation
Date:   Tue,  7 Jun 2022 18:58:42 +0200
Message-Id: <20220607164942.490533877@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

[ Upstream commit 966a7509325395c51c5f6d89e7352b0585e4804b ]

Fix the bug in bpf_object__relocate_core() which can lead to finding
invalid matching BPF program when processing CO-RE relocation. IF
matching program is not found, last encountered program will be assumed
to be correct program and thus error detection won't detect the problem.

Fixes: 9c82a63cf370 ("libbpf: Fix CO-RE relocs against .text section")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20220426004511.2691730-4-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 5612d0938fc9..1ba2dd3523f8 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5221,9 +5221,10 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 		 */
 		prog = NULL;
 		for (i = 0; i < obj->nr_programs; i++) {
-			prog = &obj->programs[i];
-			if (strcmp(prog->sec_name, sec_name) == 0)
+			if (strcmp(obj->programs[i].sec_name, sec_name) == 0) {
+				prog = &obj->programs[i];
 				break;
+			}
 		}
 		if (!prog) {
 			pr_warn("sec '%s': failed to find a BPF program\n", sec_name);
-- 
2.35.1



