Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0306D47EA
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbjDCOYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233171AbjDCOY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:24:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874C931292
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:24:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1359A61D79
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A29DC433EF;
        Mon,  3 Apr 2023 14:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531852;
        bh=361+Zo1VMTPFCcddHQbgV1CY9fsE8r1YPwUxMx0io0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m0+ev+Hx48zEvML8eWuBslKdGLLb5tccrEC/DlE5zm9csEzerxrtVn5gnp6TsP1yG
         TPQTHBtQw4GjKG9W+N6MYI25xbrI+u17RGC+DolBuoOgsBQXJ/KA9n2kfvR7NMUPiU
         0dROOvgIwaAV0sgxUMpm5NqLK8WBO7OTAgv6J4U4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Szymon Heidrich <szymon.heidrich@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/173] net: usb: smsc95xx: Limit packet length to skb->len
Date:   Mon,  3 Apr 2023 16:07:27 +0200
Message-Id: <20230403140415.405949259@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Szymon Heidrich <szymon.heidrich@gmail.com>

[ Upstream commit ff821092cf02a70c2bccd2d19269f01e29aa52cf ]

Packet length retrieved from descriptor may be larger than
the actual socket buffer length. In such case the cloned
skb passed up the network stack will leak kernel memory contents.

Fixes: 2f7ca802bdae ("net: Add SMSC LAN9500 USB2.0 10/100 ethernet adapter driver")
Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20230316101954.75836-1-szymon.heidrich@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/smsc95xx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index e1cd4c2de2d30..975f52605867f 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1824,6 +1824,12 @@ static int smsc95xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		size = (u16)((header & RX_STS_FL_) >> 16);
 		align_count = (4 - ((size + NET_IP_ALIGN) % 4)) % 4;
 
+		if (unlikely(size > skb->len)) {
+			netif_dbg(dev, rx_err, dev->net,
+				  "size err header=0x%08x\n", header);
+			return 0;
+		}
+
 		if (unlikely(header & RX_STS_ES_)) {
 			netif_dbg(dev, rx_err, dev->net,
 				  "Error header=0x%08x\n", header);
-- 
2.39.2



