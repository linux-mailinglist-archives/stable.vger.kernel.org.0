Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9192ACE35
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731949AbgKJDxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:53:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:54084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731896AbgKJDxi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:53:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED6DC2080A;
        Tue, 10 Nov 2020 03:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980417;
        bh=GF8uZORD5QDWHUzWT9fZqoX0F3CBezSaqqLgSAq7ugI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x1++N3RFNj8sj4ZPj2ysCZOsu4vp6X8Dx01OHPMic4zqOwTDiO6NjZp40WzIgG/ow
         wHNyP7rMsirUwMX1RlrffhZkGjc2dWskuNGlZAfKO2jrFyDw9nfNnwHYLz2gChCNbc
         B1fxWZu54Q4KnnMd8FpNUm6heJ7Qq2q/WG92tf/0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.9 13/55] x86/boot/compressed/64: Introduce sev_status
Date:   Mon,  9 Nov 2020 22:52:36 -0500
Message-Id: <20201110035318.423757-13-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035318.423757-1-sashal@kernel.org>
References: <20201110035318.423757-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

[ Upstream commit 3ad84246a4097010f3ae3d6944120c0be00e9e7a ]

Introduce sev_status and initialize it together with sme_me_mask to have
an indicator which SEV features are enabled.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lkml.kernel.org/r/20201028164659.27002-2-joro@8bytes.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/compressed/mem_encrypt.S | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/mem_encrypt.S b/arch/x86/boot/compressed/mem_encrypt.S
index dd07e7b41b115..3092ae173f94e 100644
--- a/arch/x86/boot/compressed/mem_encrypt.S
+++ b/arch/x86/boot/compressed/mem_encrypt.S
@@ -81,6 +81,19 @@ SYM_FUNC_START(set_sev_encryption_mask)
 
 	bts	%rax, sme_me_mask(%rip)	/* Create the encryption mask */
 
+	/*
+	 * Read MSR_AMD64_SEV again and store it to sev_status. Can't do this in
+	 * get_sev_encryption_bit() because this function is 32-bit code and
+	 * shared between 64-bit and 32-bit boot path.
+	 */
+	movl	$MSR_AMD64_SEV, %ecx	/* Read the SEV MSR */
+	rdmsr
+
+	/* Store MSR value in sev_status */
+	shlq	$32, %rdx
+	orq	%rdx, %rax
+	movq	%rax, sev_status(%rip)
+
 .Lno_sev_mask:
 	movq	%rbp, %rsp		/* Restore original stack pointer */
 
@@ -96,5 +109,6 @@ SYM_FUNC_END(set_sev_encryption_mask)
 
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 	.balign	8
-SYM_DATA(sme_me_mask, .quad 0)
+SYM_DATA(sme_me_mask,		.quad 0)
+SYM_DATA(sev_status,		.quad 0)
 #endif
-- 
2.27.0

