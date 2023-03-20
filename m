Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD646C16C9
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbjCTPJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbjCTPIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:08:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3939C2596A
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:04:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6455BB80ED2
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32DEC433EF;
        Mon, 20 Mar 2023 15:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324610;
        bh=HDwxe8wJ9xTAiwu1kJCMrpSyJIcbUhvheKmkOmS50YU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h2HLMQ3CKEnNY3+7VRYpKc750u8HWjxbnNwowDKwquWLiNy2fwmL4WtCKrGyl1MRV
         5scjnyCEOZ/kOGW3A/UD6NJx26Lz3YkENNA+gancP4fzywXbKmwH2ygtG8mz9wyEzI
         zeQwmJxbsztLnWlBJU79qCUDD1xabv1QxQRuZVyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Szymon Heidrich <szymon.heidrich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 25/99] net: usb: smsc75xx: Limit packet length to skb->len
Date:   Mon, 20 Mar 2023 15:54:03 +0100
Message-Id: <20230320145444.439266497@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Szymon Heidrich <szymon.heidrich@gmail.com>

[ Upstream commit d8b228318935044dafe3a5bc07ee71a1f1424b8d ]

Packet length retrieved from skb data may be larger than
the actual socket buffer length (up to 9026 bytes). In such
case the cloned skb passed up the network stack will leak
kernel memory contents.

Fixes: d0cad871703b ("smsc75xx: SMSC LAN75xx USB gigabit ethernet adapter driver")
Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/smsc75xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 378a12ae2d957..0b3d11e28faa7 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -2211,7 +2211,8 @@ static int smsc75xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 				dev->net->stats.rx_frame_errors++;
 		} else {
 			/* MAX_SINGLE_PACKET_SIZE + 4(CRC) + 2(COE) + 4(Vlan) */
-			if (unlikely(size > (MAX_SINGLE_PACKET_SIZE + ETH_HLEN + 12))) {
+			if (unlikely(size > (MAX_SINGLE_PACKET_SIZE + ETH_HLEN + 12) ||
+				     size > skb->len)) {
 				netif_dbg(dev, rx_err, dev->net,
 					  "size err rx_cmd_a=0x%08x\n",
 					  rx_cmd_a);
-- 
2.39.2



