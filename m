Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A174C736F
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235186AbiB1RfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:35:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237524AbiB1Reo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:34:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C39939A8;
        Mon, 28 Feb 2022 09:31:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAB3CB815AE;
        Mon, 28 Feb 2022 17:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E319C340E7;
        Mon, 28 Feb 2022 17:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069467;
        bh=NVZ/13wV06YZ+xr1T2jgfLSQQ++PaVN1I5onuZqPhSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MMWs2yZg0W2t5l2TX+HZqmu6dIKAMXZvIAr1lu8NeQFxaD+EYU7xlErVQ3Yr8ceKk
         xMriP8FcXHeBcpvhwhR73jHcrinMWhflBkmpWbZGwRL9/pNEgFR62cg4bhziUaWCR2
         lZjSKXkdzS+3WjwdYwjT4ccT17ySbBfVc3mYjcQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Grant Grundler <grundler@chromium.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 07/53] sr9700: sanity check for packet length
Date:   Mon, 28 Feb 2022 18:24:05 +0100
Message-Id: <20220228172248.850170902@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172248.232273337@linuxfoundation.org>
References: <20220228172248.232273337@linuxfoundation.org>
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
@@ -410,7 +410,7 @@ static int sr9700_rx_fixup(struct usbnet
 		/* ignore the CRC length */
 		len = (skb->data[1] | (skb->data[2] << 8)) - 4;
 
-		if (len > ETH_FRAME_LEN)
+		if (len > ETH_FRAME_LEN || len > skb->len)
 			return 0;
 
 		/* the last packet of current skb */


