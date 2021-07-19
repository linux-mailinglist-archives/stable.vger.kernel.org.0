Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030EE3CE0ED
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345587AbhGSPS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:18:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:48644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346847AbhGSPPJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:15:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26EE6600EF;
        Mon, 19 Jul 2021 15:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710148;
        bh=dHZi18C9lJeUvnD0sWQG3L29nXUo5nkGqGTKq+/lsCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k/KUhJbmJPupuLsdPWCtpjn/Bjmh1V68DEGKUEWk9rLQTPWiHpEFGmAWklNQBEKeN
         kVISTjMj7BqSohGeqjjhSpULtXJI3hrVkus85KfvWp6X8RUpbQLN+AfJ+0+DabbsIx
         iqNzntpCSdm75O8Ym0QS/UcMwjHQ/Y3CHNqWU4GM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Fabien Chouteau <fabien.chouteau@barco.com>,
        Segiy Stetsyuk <serg_stetsuk@ukr.net>,
        Ruslan Bilovol <ruslan.bilovol@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/243] usb: gadget: f_hid: fix endianness issue with descriptors
Date:   Mon, 19 Jul 2021 16:52:05 +0200
Message-Id: <20210719144943.982129235@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
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
index e55699308117..a82b3de1a54b 100644
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



