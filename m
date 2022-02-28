Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF1F4C7620
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235564AbiB1R75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:59:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239977AbiB1R7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:59:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5111F5B3CE;
        Mon, 28 Feb 2022 09:45:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3AF06066C;
        Mon, 28 Feb 2022 17:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CDCC340E7;
        Mon, 28 Feb 2022 17:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070314;
        bh=0jBTXm7jJGIgq2dhGi+7MvjNoeTBRhMcKZrOltVxSe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AD8Vc2aaidREoId2KNiYMDCB9YWpPC+ZEmPmnyOIS1/ur4DD6zmlAvDMMVLzaWN0M
         JaW0BSy7Hw00KJIvfLMUCzMHzfrbQ3me0r0V78hotWlmQNV9/ORHJRuoHUdP7YOsVA
         Z5rRTI3CCZ8WS1sGolR0NClhH+QajSTey+FZu25c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Grant Grundler <grundler@chromium.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 027/164] sr9700: sanity check for packet length
Date:   Mon, 28 Feb 2022 18:23:09 +0100
Message-Id: <20220228172402.604694515@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit e9da0b56fe27206b49f39805f7dcda8a89379062 upstream.

A malicious device can leak heap data to user space
providing bogus frame lengths. Introduce a sanity check.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reviewed-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/sr9700.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -413,7 +413,7 @@ static int sr9700_rx_fixup(struct usbnet
 		/* ignore the CRC length */
 		len = (skb->data[1] | (skb->data[2] << 8)) - 4;
 
-		if (len > ETH_FRAME_LEN)
+		if (len > ETH_FRAME_LEN || len > skb->len)
 			return 0;
 
 		/* the last packet of current skb */


