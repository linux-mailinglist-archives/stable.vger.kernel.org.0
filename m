Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC113CDFC4
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345445AbhGSPLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:11:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345809AbhGSPJj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:09:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D21B613CC;
        Mon, 19 Jul 2021 15:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709756;
        bh=TGUlphfg0gPw5fgVemP1gCgF3rAL9XkfQysAcYM8f3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MSfD+8p+8FPSXndT9VugvNctXs76Or0Zh3hpr40XCfmUJyNGCF+SzposMsKrKCJ1V
         /OYFtXr7ogeGYnvjBxvNiIY/9BwcIiHne2TDfvtRhDoeigQOb9mUGoZUGfAb5USAgP
         mwmBx/NYjLG7zTYUbMEnNA8CQmt928vZkbIN46/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fabien Chouteau <fabien.chouteau@barco.com>,
        Segiy Stetsyuk <serg_stetsuk@ukr.net>,
        Ruslan Bilovol <ruslan.bilovol@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/149] usb: gadget: f_hid: fix endianness issue with descriptors
Date:   Mon, 19 Jul 2021 16:52:46 +0200
Message-Id: <20210719144915.120272272@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ruslan Bilovol <ruslan.bilovol@gmail.com>

[ Upstream commit 33cb46c4676d01956811b68a29157ea969a5df70 ]

Running sparse checker it shows warning message about
incorrect endianness used for descriptor initialization:

| f_hid.c:91:43: warning: incorrect type in initializer (different base types)
| f_hid.c:91:43:    expected restricted __le16 [usertype] bcdHID
| f_hid.c:91:43:    got int

Fixing issue with cpu_to_le16() macro, however this is not a real issue
as the value is the same both endians.

Cc: Fabien Chouteau <fabien.chouteau@barco.com>
Cc: Segiy Stetsyuk <serg_stetsuk@ukr.net>
Signed-off-by: Ruslan Bilovol <ruslan.bilovol@gmail.com>
Link: https://lore.kernel.org/r/20210617162755.29676-1-ruslan.bilovol@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_hid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_hid.c b/drivers/usb/gadget/function/f_hid.c
index 0586229ac83d..3d540b0d9368 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -88,7 +88,7 @@ static struct usb_interface_descriptor hidg_interface_desc = {
 static struct hid_descriptor hidg_desc = {
 	.bLength			= sizeof hidg_desc,
 	.bDescriptorType		= HID_DT_HID,
-	.bcdHID				= 0x0101,
+	.bcdHID				= cpu_to_le16(0x0101),
 	.bCountryCode			= 0x00,
 	.bNumDescriptors		= 0x1,
 	/*.desc[0].bDescriptorType	= DYNAMIC */
-- 
2.30.2



