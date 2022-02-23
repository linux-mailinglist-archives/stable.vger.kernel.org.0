Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E064E4C0967
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 03:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237434AbiBWCjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 21:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237842AbiBWCiX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 21:38:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71DAF5EDF3;
        Tue, 22 Feb 2022 18:33:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 529DB614D3;
        Wed, 23 Feb 2022 02:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447D4C340E8;
        Wed, 23 Feb 2022 02:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583588;
        bh=0J4jcFKw6gaKR0MPzB8D3qoZdK16pSHJvlNpqL7WFAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hKjhbzAMYJ2u58WEyfxI5D4sFnFSHHXxFVnuTmcp4+9c2U8v8odEUB1k6NiShHqv/
         1bSRtcI6I46kM293F0zE4erMdKQZA3NUwBUKzQ8xu9cD/PzxbHbY+jqJZHVTgqVxRZ
         qjFomkUz1es8uc0EV5v5m41EWsaI2TsFE8EDWxRiytSi479m7M6d/LFSk5GBx4PA2c
         3A9QWSNwKB07+VNBFZzNNyrNDvbxR5Q5J73kztcQifRlEwHZLH2Zx5Yw1ckyKHSk1u
         NpKbfyFQ0B0Sga23byVNol0mirb6C84aanNqT4G86mM1L23diitaxR/pJY2EC9wULG
         oMR0B7rd+4KyQ==
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
Subject: [PATCH AUTOSEL 4.9 3/9] i2c: bcm2835: Avoid clock stretching timeouts
Date:   Tue, 22 Feb 2022 21:32:54 -0500
Message-Id: <20220223023300.242616-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220223023300.242616-1-sashal@kernel.org>
References: <20220223023300.242616-1-sashal@kernel.org>
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
index 7ed09865cb4b9..4729c14b75017 100644
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
@@ -313,6 +318,12 @@ static int bcm2835_i2c_probe(struct platform_device *pdev)
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

