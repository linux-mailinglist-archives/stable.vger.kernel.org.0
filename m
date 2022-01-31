Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A2A4A43F3
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350666AbiAaLZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:25:09 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39204 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377575AbiAaLXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:23:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AA2CB82A65;
        Mon, 31 Jan 2022 11:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4929EC340E8;
        Mon, 31 Jan 2022 11:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628186;
        bh=tx0AFZR/+x5PM+4Z/GTo32lYuvY+PqI/XgpAT+t3vSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G35uvL6t9lApuOMLm6pXdDGk/MbZSI55KGfEZUjR8f1s0KN1O0GcDnAuBWGmhmOMn
         ow2X4JQGM7AXTQll+L898FpTYekRLKexDSo7fNFFSzLp6fEIF8/neHYwzmsFFnT/+s
         5TsCfAKtK6awej5csBbnAbgPWDm828RZor4B4NBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mihai Carabas <mihai.carabas@oracle.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 152/200] efi/libstub: arm64: Fix image check alignment at entry
Date:   Mon, 31 Jan 2022 11:56:55 +0100
Message-Id: <20220131105238.668679418@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mihai Carabas <mihai.carabas@oracle.com>

[ Upstream commit e9b7c3a4263bdcfd31bc3d03d48ce0ded7a94635 ]

The kernel is aligned at SEGMENT_SIZE and this is the size populated in the PE
headers:

arch/arm64/kernel/efi-header.S: .long   SEGMENT_ALIGN // SectionAlignment

EFI_KIMG_ALIGN is defined as: (SEGMENT_ALIGN > THREAD_ALIGN ? SEGMENT_ALIGN :
THREAD_ALIGN)

So it depends on THREAD_ALIGN. On newer builds this message started to appear
even though the loader is taking into account the PE header (which is stating
SEGMENT_ALIGN).

Fixes: c32ac11da3f8 ("efi/libstub: arm64: Double check image alignment at entry")
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/arm64-stub.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index 2363fee9211c9..9cc556013d085 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -119,9 +119,9 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 	if (image->image_base != _text)
 		efi_err("FIRMWARE BUG: efi_loaded_image_t::image_base has bogus value\n");
 
-	if (!IS_ALIGNED((u64)_text, EFI_KIMG_ALIGN))
-		efi_err("FIRMWARE BUG: kernel image not aligned on %ldk boundary\n",
-			EFI_KIMG_ALIGN >> 10);
+	if (!IS_ALIGNED((u64)_text, SEGMENT_ALIGN))
+		efi_err("FIRMWARE BUG: kernel image not aligned on %dk boundary\n",
+			SEGMENT_ALIGN >> 10);
 
 	kernel_size = _edata - _text;
 	kernel_memsize = kernel_size + (_end - _edata);
-- 
2.34.1



