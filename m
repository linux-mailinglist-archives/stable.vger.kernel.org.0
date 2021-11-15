Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAB344522A2
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237134AbhKPBPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:15:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:42964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244239AbhKOTMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:12:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43FEC634AA;
        Mon, 15 Nov 2021 18:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000374;
        bh=a2gwHSopEmrMWCKLi/RmnFjPijvwE1uhhxTBII19q5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2GusmZCAVLxJ0ltt6uTdMT1xAfOggbfaaK4/VdeYRvQzDc2e65YSH5h4woiH0sFlT
         OVIHY66g1iZH70qg1MQVlaYiKWkOmA4Om9i2YGzxECxJi/fR5R9psD6JDOH8/gUqil
         jATysaKuBBzHdh9fLIjsnpmaUHL5EtbSCAMKYj0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bin Liu <b-liu@ti.com>,
        Min Guo <min.guo@mediatek.com>,
        Yonglong Wu <yonglong.wu@mediatek.com>,
        linux-mediatek@lists.infradead.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 605/849] usb: musb: select GENERIC_PHY instead of depending on it
Date:   Mon, 15 Nov 2021 18:01:28 +0100
Message-Id: <20211115165440.716211672@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit fde1fbedbaed4e76cef4600d775b185f59b9b568 ]

The kconfig symbol GENERIC_PHY says:
  All the users of this framework should select this config.
and around 136 out of 138 drivers do so, so change USB_MUSB_MEDIATEK
to do so also.

This (also) fixes a long circular dependency problem for an upcoming
patch.

Fixes: 0990366bab3c ("usb: musb: Add support for MediaTek musb controller")
Cc: Bin Liu <b-liu@ti.com>
Cc: Min Guo <min.guo@mediatek.com>
Cc: Yonglong Wu <yonglong.wu@mediatek.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mediatek@lists.infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20211005235747.5588-1-rdunlap@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/musb/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index 8de143807c1ae..4d61df6a9b5c8 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -120,7 +120,7 @@ config USB_MUSB_MEDIATEK
 	tristate "MediaTek platforms"
 	depends on ARCH_MEDIATEK || COMPILE_TEST
 	depends on NOP_USB_XCEIV
-	depends on GENERIC_PHY
+	select GENERIC_PHY
 	select USB_ROLE_SWITCH
 
 comment "MUSB DMA mode"
-- 
2.33.0



