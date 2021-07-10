Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466B03C2F6F
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbhGJCb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:31:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234558AbhGJC3g (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:29:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70807613DF;
        Sat, 10 Jul 2021 02:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884004;
        bh=dHZi18C9lJeUvnD0sWQG3L29nXUo5nkGqGTKq+/lsCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AiPKl5kjWX7t04I0i5U2gm5N7vFUcfkdi566L+JmzkQjhykljeimezWfYrkGXrwKs
         r1egQxVaoV4Ee+LTrrYYJyMTu5bha4uK3Of/jmBXuCbYes20o0mcqO9/6Y7VdQ+qC/
         +7nHwTLhsMD+Cg5tNsvMp0nAZifEO2+RkWX07BTyKqBmjjnLB6nQc9zy14GGkjOUj7
         po8IftanrSxuyqD827EoTbqfKxqIqlMHq1JlzHuFFSPQEoE9zPVFepaZLdZhkNgGu1
         +LA2O3UpVvx/wV3b8S5EqzgnJwlbbO/qdyaWfzPrkPds56T4GNDxxjmF4feeZ3JFch
         UDBRtknub74yw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ruslan Bilovol <ruslan.bilovol@gmail.com>,
        Fabien Chouteau <fabien.chouteau@barco.com>,
        Segiy Stetsyuk <serg_stetsuk@ukr.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 78/93] usb: gadget: f_hid: fix endianness issue with descriptors
Date:   Fri,  9 Jul 2021 22:24:12 -0400
Message-Id: <20210710022428.3169839-78-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

