Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 489CE4CF5D9
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237146AbiCGJbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237913AbiCGJ2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:28:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B8F6C1E4;
        Mon,  7 Mar 2022 01:26:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EF9661150;
        Mon,  7 Mar 2022 09:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47353C340F4;
        Mon,  7 Mar 2022 09:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645175;
        bh=z6WtXkdplajcHr5U4+TEBsmCq0vuiEtw9uFAEm14z5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qJ6J5pR4ARnE3OMF6nzFMKueeiJMhAZ1YGfssk0Pdf6c+lSBBDLLMwQkXSPFYiemc
         n43wYELX51y5t25QqhPXMhDdecsFt+9jomII3B3WRQXDKSjMRPwTYeLYxJF47rqDm6
         KfMc6vuOzrLbcxnIGaY55nSs2/vffKv8xuKg9cys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/64] i2c: bcm2835: Avoid clock stretching timeouts
Date:   Mon,  7 Mar 2022 10:18:36 +0100
Message-Id: <20220307091639.236601603@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091639.136830784@linuxfoundation.org>
References: <20220307091639.136830784@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 5ab901ad615dd..c265fe4621621 100644
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
@@ -479,6 +484,12 @@ static int bcm2835_i2c_probe(struct platform_device *pdev)
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



