Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 692454C0922
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237759AbiBWCi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:38:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236954AbiBWChP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:37:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784EB5F4FA;
        Tue, 22 Feb 2022 18:32:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2828A61519;
        Wed, 23 Feb 2022 02:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E0DC340F0;
        Wed, 23 Feb 2022 02:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583521;
        bh=p3NpOOloCl+up0CATJ/0J6lmGf3pYfYwJI3ux1MhqfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XduFcMFnw7mqDat/7/8p6vvOQc5WvLGuI/D9SLzJHIwBVl8a7ZlB3nICgnMgsKer0
         IZQoNqc1N+FxSlzBG4tqyMZgfQP89k4YeaoRXQityRkBgUEVncU/v+DGV0D1OD3gv4
         eCGHFm7DavJ7dkQjwNMCCJCVK5qjmTOv0kPRQJJEOCK4LmLTzkT1rVDlBKFOCpYwt7
         XKhgOoFoOMzxRrOH5bInAYMQAnMzgVf5t+jUaqs905Zv9OVkBS7OLdxxBiZert52yJ
         XZg/rnQzm7ykhl+l10TZAhSlbwyvgGUatemLsO7ORrn+WdFVu4XaZzJxjirwgpzU7j
         zeSfKbWRcCvkQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        nsaenz@kernel.org, f.fainelli@gmail.com, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        prabhakar.mahadev-lad.rj@bp.renesas.com, linux-i2c@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 03/13] i2c: bcm2835: Avoid clock stretching timeouts
Date:   Tue, 22 Feb 2022 21:31:42 -0500
Message-Id: <20220223023152.242065-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223023152.242065-1-sashal@kernel.org>
References: <20220223023152.242065-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Anholt <eric@anholt.net>

[ Upstream commit 9495b9b31abe525ebd93da58de2c88b9f66d3a0e ]

The CLKT register contains at poweron 0x40, which at our typical 100kHz
bus rate means .64ms. But there is no specified limit to how long devices
should be able to stretch the clocks, so just disable the timeout. We
still have a timeout wrapping the entire transfer.

Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
BugLink: https://github.com/raspberrypi/linux/issues/3064
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-bcm2835.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/i2c/busses/i2c-bcm2835.c b/drivers/i2c/busses/i2c-bcm2835.c
index 4d19254f78c8a..db1ab9ccc30e7 100644
--- a/drivers/i2c/busses/i2c-bcm2835.c
+++ b/drivers/i2c/busses/i2c-bcm2835.c
@@ -28,6 +28,11 @@
 #define BCM2835_I2C_FIFO	0x10
 #define BCM2835_I2C_DIV		0x14
 #define BCM2835_I2C_DEL		0x18
+/*
+ * 16-bit field for the number of SCL cycles to wait after rising SCL
+ * before deciding the slave is not responding. 0 disables the
+ * timeout detection.
+ */
 #define BCM2835_I2C_CLKT	0x1c
 
 #define BCM2835_I2C_C_READ	BIT(0)
@@ -398,6 +403,12 @@ static int bcm2835_i2c_probe(struct platform_device *pdev)
 	adap->dev.of_node = pdev->dev.of_node;
 	adap->quirks = &bcm2835_i2c_quirks;
 
+	/*
+	 * Disable the hardware clock stretching timeout. SMBUS
+	 * specifies a limit for how long the device can stretch the
+	 * clock, but core I2C doesn't.
+	 */
+	bcm2835_i2c_writel(i2c_dev, BCM2835_I2C_CLKT, 0);
 	bcm2835_i2c_writel(i2c_dev, BCM2835_I2C_C, 0);
 
 	ret = i2c_add_adapter(adap);
-- 
2.34.1

