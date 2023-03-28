Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 007906CC3BA
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbjC1O4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233578AbjC1O4v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:56:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E587ADBDB
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:56:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8057261844
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C837C433EF;
        Tue, 28 Mar 2023 14:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015409;
        bh=wlhbqFtoERqWL/M7yPD7+9cywiy3LE2UZ6bt7j9ScuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SYsPP6W54y0naww8pqzZwD7fLFATWEV2pELOdaJ1AKE7hZqub4NByrQ4/2b+SfHYw
         E22otA8UdBKkhhWCc4q5kwkBvd2+UfZ4AItNJKV/KBvRQhbup8U0txSGcFq0KuLuZ9
         SWlcO6NsQ+Bxh25MJIRE/wK/5i+z+CSSz/0WNyS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Szymon Heidrich <szymon.heidrich@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/224] net: usb: smsc95xx: Limit packet length to skb->len
Date:   Tue, 28 Mar 2023 16:40:34 +0200
Message-Id: <20230328142618.936133838@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
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
index 32d2c60d334dc..563ecd27b93ea 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1833,6 +1833,12 @@ static int smsc95xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
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



