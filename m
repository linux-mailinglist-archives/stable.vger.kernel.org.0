Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E881E540618
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347168AbiFGRdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347102AbiFGRaE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:30:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCA0102777;
        Tue,  7 Jun 2022 10:25:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B566B8220C;
        Tue,  7 Jun 2022 17:25:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D8EC385A5;
        Tue,  7 Jun 2022 17:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622738;
        bh=15Ja3p7ENJbqCyzcI1haqRx8AP01n1gOc5Cb1Y+6SN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TdSPDr00AiV0OGrfeSnm4ULI4qkHN6Shv45hTya/5H009SIZcY94uCnUMigt5cXhB
         PpdKt3h1FjSF4/b7KYcxD0tMhhLlfZijwhn/N8OEi2PEp/z6ClC8qtesz4JpEh7C5K
         mNYRI/xdJ781Ukjviqm0gFh14p3/LuN1/1mNSo14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 166/452] libbpf: Fix logic for finding matching program for CO-RE relocation
Date:   Tue,  7 Jun 2022 19:00:23 +0200
Message-Id: <20220607164913.511023845@linuxfoundation.org>
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
index dda8f9cdc652..8fada26529b7 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5928,9 +5928,10 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
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



