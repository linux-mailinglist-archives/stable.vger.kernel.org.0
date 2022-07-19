Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA661579E69
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239475AbiGSNBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243079AbiGSNAT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C6E4332D;
        Tue, 19 Jul 2022 05:25:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39146B81B21;
        Tue, 19 Jul 2022 12:25:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD63C341CA;
        Tue, 19 Jul 2022 12:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233533;
        bh=WXdrFZOXceROsZm8n4HSd8OiAlCYb1jd9+1Sqz04V6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yDXoTNxeW5gdWpE+O7scFkpS3Dv8Hm2VttHoRKnYVHjmNwMFIsGc6I6VdfLFXqIqO
         DdKf/wO4JXRgLasIN13CCTZ9YOFByqhtpG9OF9gFViGfIWzRvkaLmBVpmow5voLNVi
         3dowD1xSkGZmu1fNvnnJdrMe1UPpz9Pusi3TLNY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 146/231] x86/sev: Avoid using __x86_return_thunk
Date:   Tue, 19 Jul 2022 13:53:51 +0200
Message-Id: <20220719114726.628551296@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

[ Upstream commit 0ee9073000e8791f8b134a8ded31bcc767f7f232 ]

Specifically, it's because __enc_copy() encrypts the kernel after
being relocated outside the kernel in sme_encrypt_execute(), and the
RET macro's jmp offset isn't amended prior to execution.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/mem_encrypt_boot.S | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/mem_encrypt_boot.S b/arch/x86/mm/mem_encrypt_boot.S
index 3d1dba05fce4..d94dea450fa6 100644
--- a/arch/x86/mm/mem_encrypt_boot.S
+++ b/arch/x86/mm/mem_encrypt_boot.S
@@ -65,7 +65,9 @@ SYM_FUNC_START(sme_encrypt_execute)
 	movq	%rbp, %rsp		/* Restore original stack pointer */
 	pop	%rbp
 
-	RET
+	/* Offset to __x86_return_thunk would be wrong here */
+	ret
+	int3
 SYM_FUNC_END(sme_encrypt_execute)
 
 SYM_FUNC_START(__enc_copy)
@@ -151,6 +153,8 @@ SYM_FUNC_START(__enc_copy)
 	pop	%r12
 	pop	%r15
 
-	RET
+	/* Offset to __x86_return_thunk would be wrong here */
+	ret
+	int3
 .L__enc_copy_end:
 SYM_FUNC_END(__enc_copy)
-- 
2.35.1



