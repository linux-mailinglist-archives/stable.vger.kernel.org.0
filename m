Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9511312B7A4
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbfL0RoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:44:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:42128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728357AbfL0RoK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:44:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6E84222C4;
        Fri, 27 Dec 2019 17:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468649;
        bh=dSpqFK6i710jE4XItym/hIRAQU51Rs8DQiINUBZ5nGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dj3oI/AWo5Bq52XDgXEz5l8YCX5PVFZji/zgyIUWE0VHK4c4Iu+vxsE6r/G7HK2YL
         emjPDetdt3/MvB+mTxIAGN5RcxyBt+r9qmMhnHy9j6GFN+t0u1CxvTNq0dCEF/3NG7
         Ce9BhgjaX37TqJVO4ja9GxU9RI0BZmuD/RvQP4z4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bhupesh Sharma <bhsharma@redhat.com>,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 13/84] efi/gop: Return EFI_NOT_FOUND if there are no usable GOPs
Date:   Fri, 27 Dec 2019 12:42:41 -0500
Message-Id: <20191227174352.6264-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174352.6264-1-sashal@kernel.org>
References: <20191227174352.6264-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>

[ Upstream commit 6fc3cec30dfeee7d3c5db8154016aff9d65503c5 ]

If we don't find a usable instance of the Graphics Output Protocol
(GOP) because none of them have a framebuffer (i.e. they were all
PIXEL_BLT_ONLY), but all the EFI calls succeeded, we will return
EFI_SUCCESS even though we didn't find a usable GOP.

Fix this by explicitly returning EFI_NOT_FOUND if no usable GOPs are
found, allowing the caller to probe for UGA instead.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Cc: linux-efi@vger.kernel.org
Link: https://lkml.kernel.org/r/20191206165542.31469-3-ardb@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/gop.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/libstub/gop.c b/drivers/firmware/efi/libstub/gop.c
index 24c461dea7af..16ed61c023e8 100644
--- a/drivers/firmware/efi/libstub/gop.c
+++ b/drivers/firmware/efi/libstub/gop.c
@@ -121,7 +121,7 @@ setup_gop32(efi_system_table_t *sys_table_arg, struct screen_info *si,
 	u64 fb_base;
 	struct efi_pixel_bitmask pixel_info;
 	int pixel_format;
-	efi_status_t status = EFI_NOT_FOUND;
+	efi_status_t status;
 	u32 *handles = (u32 *)(unsigned long)gop_handle;
 	int i;
 
@@ -177,7 +177,7 @@ setup_gop32(efi_system_table_t *sys_table_arg, struct screen_info *si,
 
 	/* Did we find any GOPs? */
 	if (!first_gop)
-		goto out;
+		return EFI_NOT_FOUND;
 
 	/* EFI framebuffer */
 	si->orig_video_isVGA = VIDEO_TYPE_EFI;
@@ -199,7 +199,7 @@ setup_gop32(efi_system_table_t *sys_table_arg, struct screen_info *si,
 	si->lfb_size = si->lfb_linelength * si->lfb_height;
 
 	si->capabilities |= VIDEO_CAPABILITY_SKIP_QUIRKS;
-out:
+
 	return status;
 }
 
@@ -239,7 +239,7 @@ setup_gop64(efi_system_table_t *sys_table_arg, struct screen_info *si,
 	u64 fb_base;
 	struct efi_pixel_bitmask pixel_info;
 	int pixel_format;
-	efi_status_t status = EFI_NOT_FOUND;
+	efi_status_t status;
 	u64 *handles = (u64 *)(unsigned long)gop_handle;
 	int i;
 
@@ -295,7 +295,7 @@ setup_gop64(efi_system_table_t *sys_table_arg, struct screen_info *si,
 
 	/* Did we find any GOPs? */
 	if (!first_gop)
-		goto out;
+		return EFI_NOT_FOUND;
 
 	/* EFI framebuffer */
 	si->orig_video_isVGA = VIDEO_TYPE_EFI;
@@ -317,7 +317,7 @@ setup_gop64(efi_system_table_t *sys_table_arg, struct screen_info *si,
 	si->lfb_size = si->lfb_linelength * si->lfb_height;
 
 	si->capabilities |= VIDEO_CAPABILITY_SKIP_QUIRKS;
-out:
+
 	return status;
 }
 
-- 
2.20.1

