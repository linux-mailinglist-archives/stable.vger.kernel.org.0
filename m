Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C80F593DCE
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239838AbiHOUT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242729AbiHOURf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:17:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A3B6420;
        Mon, 15 Aug 2022 12:00:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 061F361280;
        Mon, 15 Aug 2022 19:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AB9C433B5;
        Mon, 15 Aug 2022 19:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590022;
        bh=AQoc+YaavwcFgbgCemNJ/K77IuFwFrWjNBQeM9fthTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cE6/5FdKmE+QedIGd9kBVfGbvzzEcNgksqAgOGBFnCqE+uwIBm2fk7GRbx0rz9CHv
         TxBDmrhw/gLFk8/OezN1K7AVGmfCRYGlwR7sRb890o+W1icfecH+mP5J4mOqIHcTHt
         /iU26nw0Y+9EbJy6mwH35iCaD4Up2fwGzsAkEWNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronald Wahl <ronald.wahl@raritan.com>,
        Jose Alonso <joalonsof@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.18 0124/1095] Revert "net: usb: ax88179_178a needs FLAG_SEND_ZLP"
Date:   Mon, 15 Aug 2022 19:52:03 +0200
Message-Id: <20220815180434.716312912@linuxfoundation.org>
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

From: Jose Alonso <joalonsof@gmail.com>

commit 6fd2c17fb6e02a8c0ab51df1cfec82ce96b8e83d upstream.

This reverts commit 36a15e1cb134c0395261ba1940762703f778438c.

The usage of FLAG_SEND_ZLP causes problems to other firmware/hardware
versions that have no issues.

The FLAG_SEND_ZLP is not safe to use in this context.
See:
https://patchwork.ozlabs.org/project/netdev/patch/1270599787.8900.8.camel@Linuxdev4-laptop/#118378
The original problem needs another way to solve.

Fixes: 36a15e1cb134 ("net: usb: ax88179_178a needs FLAG_SEND_ZLP")
Cc: stable@vger.kernel.org
Reported-by: Ronald Wahl <ronald.wahl@raritan.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216327
Link: https://bugs.archlinux.org/task/75491
Signed-off-by: Jose Alonso <joalonsof@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ax88179_178a.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1801,7 +1801,7 @@ static const struct driver_info ax88179_
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1814,7 +1814,7 @@ static const struct driver_info ax88178a
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1827,7 +1827,7 @@ static const struct driver_info cypress_
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1840,7 +1840,7 @@ static const struct driver_info dlink_du
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1853,7 +1853,7 @@ static const struct driver_info sitecom_
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1866,7 +1866,7 @@ static const struct driver_info samsung_
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1879,7 +1879,7 @@ static const struct driver_info lenovo_i
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1892,7 +1892,7 @@ static const struct driver_info belkin_i
 	.link_reset = ax88179_link_reset,
 	.reset	= ax88179_reset,
 	.stop	= ax88179_stop,
-	.flags	= FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1905,7 +1905,7 @@ static const struct driver_info toshiba_
 	.link_reset = ax88179_link_reset,
 	.reset	= ax88179_reset,
 	.stop = ax88179_stop,
-	.flags	= FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1918,7 +1918,7 @@ static const struct driver_info mct_info
 	.link_reset = ax88179_link_reset,
 	.reset	= ax88179_reset,
 	.stop	= ax88179_stop,
-	.flags	= FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1931,7 +1931,7 @@ static const struct driver_info at_umc20
 	.link_reset = ax88179_link_reset,
 	.reset  = ax88179_reset,
 	.stop   = ax88179_stop,
-	.flags  = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags  = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1944,7 +1944,7 @@ static const struct driver_info at_umc20
 	.link_reset = ax88179_link_reset,
 	.reset  = ax88179_reset,
 	.stop   = ax88179_stop,
-	.flags  = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags  = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1957,7 +1957,7 @@ static const struct driver_info at_umc20
 	.link_reset = ax88179_link_reset,
 	.reset  = ax88179_reset,
 	.stop   = ax88179_stop,
-	.flags  = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags  = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };


