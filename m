Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47EDA593BE8
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbiHOUCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346069AbiHOUBj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:01:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBC57C196;
        Mon, 15 Aug 2022 11:53:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D6B461019;
        Mon, 15 Aug 2022 18:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55651C433D7;
        Mon, 15 Aug 2022 18:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589613;
        bh=AMlWcZjBdByjeCvbHrodQDRtAK5e6/sYLxTWDNuMlm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xq0H3OCDJIESm35H26f8QWdo5eRX+aEF2zW+t7h70RysvRdG05ywCenZMhBtVxNCb
         DOSqU4zIb0qmFHldREuqsCOOJReeNzX0bgZbSdhitSn57knVQitNrzMQ354TOFl/Z7
         Ho6VCCBeAevlPKMIi2H7vUUWyEtxlILXQpwc1/94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronald Wahl <ronald.wahl@raritan.com>,
        Jose Alonso <joalonsof@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 774/779] Revert "net: usb: ax88179_178a needs FLAG_SEND_ZLP"
Date:   Mon, 15 Aug 2022 20:06:58 +0200
Message-Id: <20220815180410.484211155@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
 drivers/net/usb/ax88179_178a.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1796,7 +1796,7 @@ static const struct driver_info ax88179_
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1809,7 +1809,7 @@ static const struct driver_info ax88178a
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1822,7 +1822,7 @@ static const struct driver_info cypress_
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1835,7 +1835,7 @@ static const struct driver_info dlink_du
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1848,7 +1848,7 @@ static const struct driver_info sitecom_
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1861,7 +1861,7 @@ static const struct driver_info samsung_
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1874,7 +1874,7 @@ static const struct driver_info lenovo_i
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1887,7 +1887,7 @@ static const struct driver_info belkin_i
 	.link_reset = ax88179_link_reset,
 	.reset	= ax88179_reset,
 	.stop	= ax88179_stop,
-	.flags	= FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1900,7 +1900,7 @@ static const struct driver_info toshiba_
 	.link_reset = ax88179_link_reset,
 	.reset	= ax88179_reset,
 	.stop = ax88179_stop,
-	.flags	= FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1913,7 +1913,7 @@ static const struct driver_info mct_info
 	.link_reset = ax88179_link_reset,
 	.reset	= ax88179_reset,
 	.stop	= ax88179_stop,
-	.flags	= FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
+	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };


