Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA793AEE79
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhFUQ3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:29:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231940AbhFUQ15 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:27:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDF93613B2;
        Mon, 21 Jun 2021 16:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292587;
        bh=hmGwcpj73i9WK4PJwPQacDbkdECktaVInEOULUZWVkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zc0sQX0k7D9SkSaD03Ty/vxZQyp2/gqiLJkHusk6ctZ032jwf/9SFK+nD17pVbTYx
         ZKKudP3o4K1MjlEBnpg5AS7DSDgkyMPyNuTuOT5Xy7LLWADDmzM4KeplXr0dxEMO6i
         c6+cbxCJIBPCH9+kA3eX6ETU1nJz1AOftGoHqiEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Colitti <lorenzo@google.com>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/146] net: cdc_ncm: switch to eth%d interface naming
Date:   Mon, 21 Jun 2021 18:14:46 +0200
Message-Id: <20210621154914.078696937@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

[ Upstream commit c1a3d4067309451e68c33dbd356032549cc0bd8e ]

This is meant to make the host side cdc_ncm interface consistently
named just like the older CDC protocols: cdc_ether & cdc_ecm
(and even rndis_host), which all use 'FLAG_ETHER | FLAG_POINTTOPOINT'.

include/linux/usb/usbnet.h:
  #define FLAG_ETHER	0x0020		/* maybe use "eth%d" names */
  #define FLAG_WLAN	0x0080		/* use "wlan%d" names */
  #define FLAG_WWAN	0x0400		/* use "wwan%d" names */
  #define FLAG_POINTTOPOINT 0x1000	/* possibly use "usb%d" names */

drivers/net/usb/usbnet.c @ line 1711:
  strcpy (net->name, "usb%d");
  ...
  // heuristic:  "usb%d" for links we know are two-host,
  // else "eth%d" when there's reasonable doubt.  userspace
  // can rename the link if it knows better.
  if ((dev->driver_info->flags & FLAG_ETHER) != 0 &&
      ((dev->driver_info->flags & FLAG_POINTTOPOINT) == 0 ||
       (net->dev_addr [0] & 0x02) == 0))
          strcpy (net->name, "eth%d");
  /* WLAN devices should always be named "wlan%d" */
  if ((dev->driver_info->flags & FLAG_WLAN) != 0)
          strcpy(net->name, "wlan%d");
  /* WWAN devices should always be named "wwan%d" */
  if ((dev->driver_info->flags & FLAG_WWAN) != 0)
          strcpy(net->name, "wwan%d");

So by using ETHER | POINTTOPOINT the interface naming is
either usb%d or eth%d based on the global uniqueness of the
mac address of the device.

Without this 2.5gbps ethernet dongles which all seem to use the cdc_ncm
driver end up being called usb%d instead of eth%d even though they're
definitely not two-host.  (All 1gbps & 5gbps ethernet usb dongles I've
tested don't hit this problem due to use of different drivers, primarily
r8152 and aqc111)

Fixes tag is based purely on git blame, and is really just here to make
sure this hits LTS branches newer than v4.5.

Cc: Lorenzo Colitti <lorenzo@google.com>
Fixes: 4d06dd537f95 ("cdc_ncm: do not call usbnet_link_change from cdc_ncm_bind")
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_ncm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 1d3bf810f2ca..04c4f1570bc8 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1900,7 +1900,7 @@ static void cdc_ncm_status(struct usbnet *dev, struct urb *urb)
 static const struct driver_info cdc_ncm_info = {
 	.description = "CDC NCM",
 	.flags = FLAG_POINTTOPOINT | FLAG_NO_SETINT | FLAG_MULTI_PACKET
-			| FLAG_LINK_INTR,
+			| FLAG_LINK_INTR | FLAG_ETHER,
 	.bind = cdc_ncm_bind,
 	.unbind = cdc_ncm_unbind,
 	.manage_power = usbnet_manage_power,
-- 
2.30.2



