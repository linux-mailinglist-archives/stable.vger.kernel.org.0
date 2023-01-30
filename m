Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1C4681155
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237269AbjA3OMY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237272AbjA3OMU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:12:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF063BDA1
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:12:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E381B811C9
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD951C433EF;
        Mon, 30 Jan 2023 14:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087927;
        bh=eECfUK0b3QPaQcBR9ecj7x2Z/+d43SQtpBvY4WO/R8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0TBWxJYys1QEPGi5W4G3bKTTn49LRyzA/M197b7yju8uvBYp56uhu4nmwUMbhxMuk
         77HhROTqohr3R796UlzsTOzD912+sL5FRF8eHJB6NaRLrad/WcvK0MiXWhky6q0kHF
         6/GaaO34VUY2TwtGRl7GHJBBHPHIY02hgwbKgn68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Szymon Heidrich <szymon.heidrich@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/204] net: usb: sr9700: Handle negative len
Date:   Mon, 30 Jan 2023 14:50:21 +0100
Message-Id: <20230130134318.774146658@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Szymon Heidrich <szymon.heidrich@gmail.com>

[ Upstream commit ecf7cf8efb59789e2b21d2f9ab926142579092b2 ]

Packet len computed as difference of length word extracted from
skb data and four may result in a negative value. In such case
processing of the buffer should be interrupted rather than
setting sr_skb->len to an unexpectedly large value (due to cast
from signed to unsigned integer) and passing sr_skb to
usbnet_skb_return.

Fixes: e9da0b56fe27 ("sr9700: sanity check for packet length")
Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
Link: https://lore.kernel.org/r/20230114182326.30479-1-szymon.heidrich@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/sr9700.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
index 0c50f24671da..1fac6ee273c4 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -410,7 +410,7 @@ static int sr9700_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		/* ignore the CRC length */
 		len = (skb->data[1] | (skb->data[2] << 8)) - 4;
 
-		if (len > ETH_FRAME_LEN || len > skb->len)
+		if (len > ETH_FRAME_LEN || len > skb->len || len < 0)
 			return 0;
 
 		/* the last packet of current skb */
-- 
2.39.0



