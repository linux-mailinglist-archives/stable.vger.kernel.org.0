Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE364689642
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjBCK2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233470AbjBCK2C (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:28:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22454A428C
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:27:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA670B82A65
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3835C4339B;
        Fri,  3 Feb 2023 10:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420040;
        bh=TEBPdHf5iqfyUasc8iSZHTJoSRvhWtPhfFnE2kBk2+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mazwu2+2dSC01KN6CgEh/VMICyDBkdC9HsTCY2Sf5+H0aeKvJmM8jDSTaHxBf2wNN
         OIkLG69lSvz2eFYRGqkCoIAHqHqiXDDQw2uWqYPU5tKRdnJAEC9pmjK33UkTIahxHB
         8r3Vd7POgCIgxS7cA+xiOknaYmB9xddiCVEz8UrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Szymon Heidrich <szymon.heidrich@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/134] net: usb: sr9700: Handle negative len
Date:   Fri,  3 Feb 2023 11:12:15 +0100
Message-Id: <20230203101025.223660802@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
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
index fce6713e970b..811c8751308c 100644
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



