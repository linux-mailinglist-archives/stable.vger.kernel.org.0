Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7DB137E5B
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729687AbgAKKI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:08:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:44370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729148AbgAKKI4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:08:56 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 133A720880;
        Sat, 11 Jan 2020 10:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737335;
        bh=dSpqFK6i710jE4XItym/hIRAQU51Rs8DQiINUBZ5nGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5lKDXqb1594+Eo9PLCfku7X3efS26q0dDnIer0AYYjEr87uz/WRjc54PjCXM1Qnb
         0lDcnf+/jql6Cd6B3UUs9xq9SC2D9sSpLp73CRJ7+2q/l6IKGHiWG6oAid6MmVvGWP
         BgaThR15rWO85YOcX+gZudAmjl9bayktdNd9nVEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arvind Sankar <nivedita@alum.mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bhupesh Sharma <bhsharma@redhat.com>,
        Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 08/62] efi/gop: Return EFI_NOT_FOUND if there are no usable GOPs
Date:   Sat, 11 Jan 2020 10:49:50 +0100
Message-Id: <20200111094840.974597343@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094837.425430968@linuxfoundation.org>
References: <20200111094837.425430968@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



