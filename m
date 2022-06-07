Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69CDE541585
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376509AbiFGUg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378012AbiFGUep (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:34:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584951E8E99;
        Tue,  7 Jun 2022 11:37:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89416B82182;
        Tue,  7 Jun 2022 18:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC68DC341CC;
        Tue,  7 Jun 2022 18:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627030;
        bh=4JI497rn1w5jLXa3fsVUm1N8VcEniotvqADpCf5bPZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ja4WJ22YzyOvma5gJiv8teeHYwN4j6oZRtiNdtXLH/Jk5CK0Otoc5/Dr8TuyxJCuk
         cg5EkIbhHD2IrDW4jxy5HY70WoGvh0kvG4IsEogeVDRwrXsmvoz01SKLjVG9kOSHOB
         k/VDAs7UWB6Cpe3g9T7J2eQ7NvkhkGtNtAOndC/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tali Perry <tali.perry1@gmail.com>,
        Tyrone Ting <kfting@nuvoton.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 591/772] i2c: npcm: Fix timeout calculation
Date:   Tue,  7 Jun 2022 19:03:03 +0200
Message-Id: <20220607165006.361041110@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tali Perry <tali.perry1@gmail.com>

[ Upstream commit 288b204492fddf28889cea6dc95a23976632c7a0 ]

Use adap.timeout for timeout calculation instead of hard-coded
value of 35ms.

Fixes: 56a1485b102e ("i2c: npcm7xx: Add Nuvoton NPCM I2C controller driver")
Signed-off-by: Tali Perry <tali.perry1@gmail.com>
Signed-off-by: Tyrone Ting <kfting@nuvoton.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-npcm7xx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-npcm7xx.c b/drivers/i2c/busses/i2c-npcm7xx.c
index 2ad166355ec9..92fd88a3f415 100644
--- a/drivers/i2c/busses/i2c-npcm7xx.c
+++ b/drivers/i2c/busses/i2c-npcm7xx.c
@@ -2047,7 +2047,7 @@ static int npcm_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 	u16 nwrite, nread;
 	u8 *write_data, *read_data;
 	u8 slave_addr;
-	int timeout;
+	unsigned long timeout;
 	int ret = 0;
 	bool read_block = false;
 	bool read_PEC = false;
@@ -2099,13 +2099,13 @@ static int npcm_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
 	 * 9: bits per transaction (including the ack/nack)
 	 */
 	timeout_usec = (2 * 9 * USEC_PER_SEC / bus->bus_freq) * (2 + nread + nwrite);
-	timeout = max(msecs_to_jiffies(35), usecs_to_jiffies(timeout_usec));
+	timeout = max_t(unsigned long, bus->adap.timeout, usecs_to_jiffies(timeout_usec));
 	if (nwrite >= 32 * 1024 || nread >= 32 * 1024) {
 		dev_err(bus->dev, "i2c%d buffer too big\n", bus->num);
 		return -EINVAL;
 	}
 
-	time_left = jiffies + msecs_to_jiffies(DEFAULT_STALL_COUNT) + 1;
+	time_left = jiffies + timeout + 1;
 	do {
 		/*
 		 * we must clear slave address immediately when the bus is not
@@ -2269,7 +2269,7 @@ static int npcm_i2c_probe_bus(struct platform_device *pdev)
 	adap = &bus->adap;
 	adap->owner = THIS_MODULE;
 	adap->retries = 3;
-	adap->timeout = HZ;
+	adap->timeout = msecs_to_jiffies(35);
 	adap->algo = &npcm_i2c_algo;
 	adap->quirks = &npcm_i2c_quirks;
 	adap->algo_data = bus;
-- 
2.35.1



