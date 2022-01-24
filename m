Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCC0498991
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343660AbiAXS5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:57:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344726AbiAXSzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:55:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 381E6C06136D;
        Mon, 24 Jan 2022 10:53:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCA3261527;
        Mon, 24 Jan 2022 18:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904D2C340E5;
        Mon, 24 Jan 2022 18:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050431;
        bh=/WuAenPvtHoOYxe2cLjzMTFFnpRHp7Hh7oLwX6A9/98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KC4CRU6wn+N4qqHAqGWYnjWMWWOhuWAySACWXbqjzXkrmnv4uA9plpsVgJSj1gy0S
         BBbAh0cd2PWglu/qL9Qsf0GQpDQl2KNF5ZRd3QQnbrnDf9UuKcvQNr1Uj37iSipBfz
         q5hxvoZBATTv/QY+8EOt8venHZUh21y95WCddMeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 114/114] lib82596: Fix IRQ check in sni_82596_probe
Date:   Mon, 24 Jan 2022 19:43:29 +0100
Message-Id: <20220124183930.620954574@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

commit 99218cbf81bf21355a3de61cd46a706d36e900e6 upstream.

platform_get_irq() returns negative error number instead 0 on failure.
And the doc of platform_get_irq() provides a usage example:

    int irq = platform_get_irq(pdev, 0);
    if (irq < 0)
        return irq;

Fix the check of return value to catch errors correctly.

Fixes: 115978859272 ("i825xx: Move the Intel 82586/82593/82596 based drivers")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/i825xx/sni_82596.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/i825xx/sni_82596.c
+++ b/drivers/net/ethernet/i825xx/sni_82596.c
@@ -122,9 +122,10 @@ static int sni_82596_probe(struct platfo
 	netdevice->dev_addr[5] = readb(eth_addr + 0x06);
 	iounmap(eth_addr);
 
-	if (!netdevice->irq) {
+	if (netdevice->irq < 0) {
 		printk(KERN_ERR "%s: IRQ not found for i82596 at 0x%lx\n",
 			__FILE__, netdevice->base_addr);
+		retval = netdevice->irq;
 		goto probe_failed;
 	}
 


