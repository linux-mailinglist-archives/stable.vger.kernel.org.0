Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFEFC6DEEB8
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbjDLIoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbjDLIoQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:44:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D68E1A4
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:43:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F36E630BD
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71337C433EF;
        Wed, 12 Apr 2023 08:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289000;
        bh=sYd6ICRjhfCK/+Zoza1/9PMmL5WhMZ0xzQHAveKZHDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IBHofUikqR8kA4dIljh4moYIAo7kqH/WvcWEY7hhNmQ3clEC51PKB3vYohZ23klef
         e8YaTFcZggaiA9j2k0184xiAE89QX0RidUTVLH5M/EP2fvaL5zLIhr9JVCkcdh0oFT
         ew/veD7fafw3HYs9K5OLrdeGm7x9OuhrPdDmN/7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        William Breathitt Gray <william.gray@linaro.org>
Subject: [PATCH 6.1 098/164] counter: 104-quad-8: Fix race condition between FLAG and CNTR reads
Date:   Wed, 12 Apr 2023 10:33:40 +0200
Message-Id: <20230412082840.822017654@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Breathitt Gray <william.gray@linaro.org>

commit 4aa3b75c74603c3374877d5fd18ad9cc3a9a62ed upstream.

The Counter (CNTR) register is 24 bits wide, but we can have an
effective 25-bit count value by setting bit 24 to the XOR of the Borrow
flag and Carry flag. The flags can be read from the FLAG register, but a
race condition exists: the Borrow flag and Carry flag are instantaneous
and could change by the time the count value is read from the CNTR
register.

Since the race condition could result in an incorrect 25-bit count
value, remove support for 25-bit count values from this driver;
hard-coded maximum count values are replaced by a LS7267_CNTR_MAX define
for consistency and clarity.

Fixes: 28e5d3bb0325 ("iio: 104-quad-8: Add IIO support for the ACCES 104-QUAD-8")
Cc: <stable@vger.kernel.org> # 6.1.x
Cc: <stable@vger.kernel.org> # 6.2.x
Link: https://lore.kernel.org/r/20230312231554.134858-1-william.gray@linaro.org/
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/counter/104-quad-8.c |   29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -97,10 +97,6 @@ struct quad8 {
 	struct quad8_reg __iomem *reg;
 };
 
-/* Borrow Toggle flip-flop */
-#define QUAD8_FLAG_BT BIT(0)
-/* Carry Toggle flip-flop */
-#define QUAD8_FLAG_CT BIT(1)
 /* Error flag */
 #define QUAD8_FLAG_E BIT(4)
 /* Up/Down flag */
@@ -133,6 +129,9 @@ struct quad8 {
 #define QUAD8_CMR_QUADRATURE_X2 0x10
 #define QUAD8_CMR_QUADRATURE_X4 0x18
 
+/* Each Counter is 24 bits wide */
+#define LS7267_CNTR_MAX GENMASK(23, 0)
+
 static int quad8_signal_read(struct counter_device *counter,
 			     struct counter_signal *signal,
 			     enum counter_signal_level *level)
@@ -156,18 +155,10 @@ static int quad8_count_read(struct count
 {
 	struct quad8 *const priv = counter_priv(counter);
 	struct channel_reg __iomem *const chan = priv->reg->channel + count->id;
-	unsigned int flags;
-	unsigned int borrow;
-	unsigned int carry;
 	unsigned long irqflags;
 	int i;
 
-	flags = ioread8(&chan->control);
-	borrow = flags & QUAD8_FLAG_BT;
-	carry = !!(flags & QUAD8_FLAG_CT);
-
-	/* Borrow XOR Carry effectively doubles count range */
-	*val = (unsigned long)(borrow ^ carry) << 24;
+	*val = 0;
 
 	spin_lock_irqsave(&priv->lock, irqflags);
 
@@ -191,8 +182,7 @@ static int quad8_count_write(struct coun
 	unsigned long irqflags;
 	int i;
 
-	/* Only 24-bit values are supported */
-	if (val > 0xFFFFFF)
+	if (val > LS7267_CNTR_MAX)
 		return -ERANGE;
 
 	spin_lock_irqsave(&priv->lock, irqflags);
@@ -806,8 +796,7 @@ static int quad8_count_preset_write(stru
 	struct quad8 *const priv = counter_priv(counter);
 	unsigned long irqflags;
 
-	/* Only 24-bit values are supported */
-	if (preset > 0xFFFFFF)
+	if (preset > LS7267_CNTR_MAX)
 		return -ERANGE;
 
 	spin_lock_irqsave(&priv->lock, irqflags);
@@ -834,8 +823,7 @@ static int quad8_count_ceiling_read(stru
 		*ceiling = priv->preset[count->id];
 		break;
 	default:
-		/* By default 0x1FFFFFF (25 bits unsigned) is maximum count */
-		*ceiling = 0x1FFFFFF;
+		*ceiling = LS7267_CNTR_MAX;
 		break;
 	}
 
@@ -850,8 +838,7 @@ static int quad8_count_ceiling_write(str
 	struct quad8 *const priv = counter_priv(counter);
 	unsigned long irqflags;
 
-	/* Only 24-bit values are supported */
-	if (ceiling > 0xFFFFFF)
+	if (ceiling > LS7267_CNTR_MAX)
 		return -ERANGE;
 
 	spin_lock_irqsave(&priv->lock, irqflags);


