Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E0A5940E4
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244002AbiHOV2L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243668AbiHOVYf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:24:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9363E8313;
        Mon, 15 Aug 2022 12:22:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBC0C60EF0;
        Mon, 15 Aug 2022 19:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE72C433C1;
        Mon, 15 Aug 2022 19:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591356;
        bh=6WkHnJVm5rzOj2ShWWfniZvz3jfM09Vn7mLBc0nYWV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ds4NgbvUdNSy0K+wecRqtRxYjonQDFoh9yP+r6k/8yv5MoaRXxl98GvA9neKkXBxz
         j5mzGB7ZNPmHW9c0lylsA+6Sq0/TkbcDk9Idv2UjYxgc2gfi/3C6JlyoXVjxW/ZT5x
         zjBIO3osDm7RkVM66L0/UORS38efCckYsgcwpW1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Hayes Wang <hayeswang@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0536/1095] net: usb: make USB_RTL8153_ECM non user configurable
Date:   Mon, 15 Aug 2022 19:58:55 +0200
Message-Id: <20220815180451.723458190@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

[ Upstream commit f56530dcdb0684406661ac9f1accf48319d07600 ]

This refixes:

    commit 7da17624e7948d5d9660b910f8079d26d26ce453
    nt: usb: USB_RTL8153_ECM should not default to y

    In general, device drivers should not be enabled by default.

which basically broke the commit it claimed to fix, ie:

    commit 657bc1d10bfc23ac06d5d687ce45826c760744f9
    r8153_ecm: avoid to be prior to r8152 driver

    Avoid r8153_ecm is compiled as built-in, if r8152 driver is compiled
    as modules. Otherwise, the r8153_ecm would be used, even though the
    device is supported by r8152 driver.

this commit amounted to:

drivers/net/usb/Kconfig:

+config USB_RTL8153_ECM
+       tristate "RTL8153 ECM support"
+       depends on USB_NET_CDCETHER && (USB_RTL8152 || USB_RTL8152=n)
+       default y
+       help
+         This option supports ECM mode for RTL8153 ethernet adapter, when
+         CONFIG_USB_RTL8152 is not set, or the RTL8153 device is not
+         supported by r8152 driver.

drivers/net/usb/Makefile:

-obj-$(CONFIG_USB_NET_CDCETHER) += cdc_ether.o r8153_ecm.o
+obj-$(CONFIG_USB_NET_CDCETHER) += cdc_ether.o
+obj-$(CONFIG_USB_RTL8153_ECM)  += r8153_ecm.o

And as can be seen it pulls a piece of the cdc_ether driver out into
a separate config option to be able to make this piece modular in case
cdc_ether is builtin, while r8152 is modular.

While in general, device drivers should indeed not be enabled by default:
this isn't a device driver per say, but rather this is support code for
the CDCETHER (ECM) driver, and should thus be enabled if it is enabled.

See also email thread at:
  https://www.spinics.net/lists/netdev/msg767649.html

In:
  https://www.spinics.net/lists/netdev/msg768284.html

Jakub wrote:
  And when we say "removed" we can just hide it from what's prompted
  to the user (whatever such internal options are called)? I believe
  this way we don't bring back Marek's complaint.

Side note: these incorrect defaults will result in Android 13
on 5.15 GKI kernels lacking USB_RTL8153_ECM support while having
USB_NET_CDCETHER (luckily we also have USB_RTL8150 and USB_RTL8152,
so it's probably only an issue for very new RTL815x hardware with
no native 5.15 driver).

Fixes: 7da17624e7948d5d ("nt: usb: USB_RTL8153_ECM should not default to y")
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hayes Wang <hayeswang@realtek.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Link: https://lore.kernel.org/r/20220730230113.4138858-1-zenczykowski@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index e62fc4f2aee0..76659c1c525a 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -637,8 +637,9 @@ config USB_NET_AQC111
 	  * Aquantia AQtion USB to 5GbE
 
 config USB_RTL8153_ECM
-	tristate "RTL8153 ECM support"
+	tristate
 	depends on USB_NET_CDCETHER && (USB_RTL8152 || USB_RTL8152=n)
+	default y
 	help
 	  This option supports ECM mode for RTL8153 ethernet adapter, when
 	  CONFIG_USB_RTL8152 is not set, or the RTL8153 device is not
-- 
2.35.1



