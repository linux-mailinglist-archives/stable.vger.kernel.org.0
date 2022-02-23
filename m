Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B624C084C
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbiBWCbR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237074AbiBWCad (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:30:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD5D58382;
        Tue, 22 Feb 2022 18:29:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63222B81DD2;
        Wed, 23 Feb 2022 02:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44E5C340F0;
        Wed, 23 Feb 2022 02:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583378;
        bh=YfYYgfEG/tUw+RF/Z5+2ChlPUubhZWSVdHx6WExWyhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SMfDvxFnDVN0pLoSzGlWoKt8iEYfMLGZAGXh8YyxufEdhv7SNb9DL+anrMY3L8AQ8
         UGfVTncscmg6ucc11zRaRxiKytsj+m+OM5qoF+lJeRFjHLKfE1DQvHxWWeYqH20bn5
         kCF33TZsugtBM1YMV69ygtQp5gGCoKTRX4ygEpOgU5BaRRAjXdiMCBFZaLe7N7Vx/O
         KDFR1h2l56UrdhvU9bzrxvHbe9YLrUiYIKoW5melwWY2WIWHcmOAXWRXZVWn3x1tQ5
         qKfrH4tOgFT/5hWmGgJ0NxK6vAQX2cC6DH/EIqJWoVKcGiRNBCOEGYkMrpJYSbc0Jc
         ZlN0BgZrjJ4TA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        f.fainelli@gmail.com, rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, nsaenz@kernel.org,
        prabhakar.mahadev-lad.rj@bp.renesas.com, linux-i2c@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 03/28] i2c: bcm2835: Avoid clock stretching timeouts
Date:   Tue, 22 Feb 2022 21:29:04 -0500
Message-Id: <20220223022929.241127-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223022929.241127-1-sashal@kernel.org>
References: <20220223022929.241127-1-sashal@kernel.org>
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
index 37443edbf7546..ad3b124a2e376 100644
--- a/drivers/i2c/busses/i2c-bcm2835.c
+++ b/drivers/i2c/busses/i2c-bcm2835.c
@@ -23,6 +23,11 @@
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
@@ -477,6 +482,12 @@ static int bcm2835_i2c_probe(struct platform_device *pdev)
 	adap->dev.of_node = pdev->dev.of_node;
 	adap->quirks = of_device_get_match_data(&pdev->dev);
 
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

