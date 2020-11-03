Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168D22A59B2
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729327AbgKCWJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 17:09:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:48212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729906AbgKCUiQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:38:16 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2DB922277;
        Tue,  3 Nov 2020 20:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435895;
        bh=lzAhLFnDy6jrXtfvTMpBJaUQDQN3L4ZCW3GOaT8jXMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VfQz/WyaCOgeS/ZbJxnisuvMKmuLl5mZ3qwEg5ZdT8H9Y8id0lAQDYq9vzSueVObt
         mdF2IqQ3HwSq0ee3nmsLBAKRkDaNx+hYqooUC2Nbsw8pwdI+KEb8v0yzvJvZtHAQg5
         fhA43HsrHyP2CFsjuufuCuIk5o3/7ksM16WZdERM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 030/391] arm64: efi: increase EFI PE/COFF header padding to 64 KB
Date:   Tue,  3 Nov 2020 21:31:21 +0100
Message-Id: <20201103203349.810965014@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit a2d50c1c77aa879af24f9f67b33186737b3d4885 ]

Commit 76085aff29f5 ("efi/libstub/arm64: align PE/COFF sections to segment
alignment") increased the PE/COFF section alignment to match the minimum
segment alignment of the kernel image, which ensures that the kernel does
not need to be moved around in memory by the EFI stub if it was built as
relocatable.

However, the first PE/COFF section starts at _stext, which is only 4 KB
aligned, and so the section layout is inconsistent. Existing EFI loaders
seem to care little about this, but it is better to clean this up.

So let's pad the header to 64 KB to match the PE/COFF section alignment.

Fixes: 76085aff29f5 ("efi/libstub/arm64: align PE/COFF sections to segment alignment")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20201027073209.2897-2-ardb@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/efi-header.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/efi-header.S b/arch/arm64/kernel/efi-header.S
index df67c0f2a077e..a71844fb923ee 100644
--- a/arch/arm64/kernel/efi-header.S
+++ b/arch/arm64/kernel/efi-header.S
@@ -147,6 +147,6 @@ efi_debug_entry:
 	 * correctly at this alignment, we must ensure that .text is
 	 * placed at a 4k boundary in the Image to begin with.
 	 */
-	.align 12
+	.balign	SEGMENT_ALIGN
 efi_header_end:
 	.endm
-- 
2.27.0



