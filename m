Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49BD64C757C
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235485AbiB1RzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240053AbiB1Rxw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:53:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86485B0C6F;
        Mon, 28 Feb 2022 09:41:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF36BB815D2;
        Mon, 28 Feb 2022 17:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324D0C340E7;
        Mon, 28 Feb 2022 17:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070069;
        bh=kHjlrUGxe5V6yIekYKm6DoIIlAVCwygVHRQyvgZOCHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ukZlbXzr6g1kCVVj2zS4wNKnHC0w9Nh8dkbkRDo1sTEeDXkvBYetnia8w4jCj/E0t
         DDcu0XPl+cKdC0JhfS7U6b7HqKMiiMxYftrlegDXNM6H0pH0RE8SfF8IVgAL8xVrM5
         n+WmIkOjVPl7qQIhKFIxe0iUyMCEGCwxu3ZHVpOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Prasad Kumpatla <quic_pkumpatl@quicinc.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/139] regmap-irq: Update interrupt clear register for proper reset
Date:   Mon, 28 Feb 2022 18:24:21 +0100
Message-Id: <20220228172356.797876633@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
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

From: Prasad Kumpatla <quic_pkumpatl@quicinc.com>

[ Upstream commit d04ad245d67a3991dfea5e108e4c452c2ab39bac ]

With the existing logic where clear_ack is true (HW doesn’t support
auto clear for ICR), interrupt clear register reset is not handled
properly. Due to this only the first interrupts get processed properly
and further interrupts are blocked due to not resetting interrupt
clear register.

Example for issue case where Invert_ack is false and clear_ack is true:

    Say Default ISR=0x00 & ICR=0x00 and ISR is triggered with 2
    interrupts making ISR = 0x11.

    Step 1: Say ISR is set 0x11 (store status_buff = ISR). ISR needs to
            be cleared with the help of ICR once the Interrupt is processed.

    Step 2: Write ICR = 0x11 (status_buff), this will clear the ISR to 0x00.

    Step 3: Issue - In the existing code, ICR is written with ICR =
            ~(status_buff) i.e ICR = 0xEE -> This will block all the interrupts
            from raising except for interrupts 0 and 4. So expectation here is to
            reset ICR, which will unblock all the interrupts.

            if (chip->clear_ack) {
                 if (chip->ack_invert && !ret)
                  ........
                 else if (!ret)
                     ret = regmap_write(map, reg,
                            ~data->status_buf[i]);

So writing 0 and 0xff (when ack_invert is true) should have no effect, other
than clearing the ACKs just set.

Fixes: 3a6f0fb7b8eb ("regmap: irq: Add support to clear ack registers")
Signed-off-by: Prasad Kumpatla <quic_pkumpatl@quicinc.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20220217085007.30218-1-quic_pkumpatl@quicinc.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-irq.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index d2656581a6085..4a446259a184e 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -189,11 +189,9 @@ static void regmap_irq_sync_unlock(struct irq_data *data)
 				ret = regmap_write(map, reg, d->mask_buf[i]);
 			if (d->chip->clear_ack) {
 				if (d->chip->ack_invert && !ret)
-					ret = regmap_write(map, reg,
-							   d->mask_buf[i]);
+					ret = regmap_write(map, reg, UINT_MAX);
 				else if (!ret)
-					ret = regmap_write(map, reg,
-							   ~d->mask_buf[i]);
+					ret = regmap_write(map, reg, 0);
 			}
 			if (ret != 0)
 				dev_err(d->map->dev, "Failed to ack 0x%x: %d\n",
@@ -556,11 +554,9 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
 						data->status_buf[i]);
 			if (chip->clear_ack) {
 				if (chip->ack_invert && !ret)
-					ret = regmap_write(map, reg,
-							data->status_buf[i]);
+					ret = regmap_write(map, reg, UINT_MAX);
 				else if (!ret)
-					ret = regmap_write(map, reg,
-							~data->status_buf[i]);
+					ret = regmap_write(map, reg, 0);
 			}
 			if (ret != 0)
 				dev_err(map->dev, "Failed to ack 0x%x: %d\n",
@@ -817,13 +813,9 @@ int regmap_add_irq_chip_fwnode(struct fwnode_handle *fwnode,
 					d->status_buf[i] & d->mask_buf[i]);
 			if (chip->clear_ack) {
 				if (chip->ack_invert && !ret)
-					ret = regmap_write(map, reg,
-						(d->status_buf[i] &
-						 d->mask_buf[i]));
+					ret = regmap_write(map, reg, UINT_MAX);
 				else if (!ret)
-					ret = regmap_write(map, reg,
-						~(d->status_buf[i] &
-						  d->mask_buf[i]));
+					ret = regmap_write(map, reg, 0);
 			}
 			if (ret != 0) {
 				dev_err(map->dev, "Failed to ack 0x%x: %d\n",
-- 
2.34.1



