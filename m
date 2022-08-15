Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A8B59368E
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243309AbiHOSnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244144AbiHOSmP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:42:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2793C2B61D;
        Mon, 15 Aug 2022 11:26:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCA92B80F99;
        Mon, 15 Aug 2022 18:26:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4B5C433C1;
        Mon, 15 Aug 2022 18:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587965;
        bh=adh1CfaAQMrvtv+mKh3OYoijuXPEkwULKQoz71MtB0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sMSmSp6q/G5Y3pTGSvZnY82p1k1/GKyeBYIVXdPEm1itkj2Gk9H5cKJk9FJyNB1JJ
         JFShhdxZBVKoFmTeHXEk0AyM8+/1ZZeW1hToUR60n8D1g6fBQde7pAnHLW56+j9nQM
         LEKSd1aaClfZTjU+sREEwHmikDM7KJuhEj4DD0DI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tali Perry <tali.perry1@gmail.com>,
        Tyrone Ting <kfting@nuvoton.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 251/779] i2c: npcm: Correct slave role behavior
Date:   Mon, 15 Aug 2022 19:58:15 +0200
Message-Id: <20220815180348.061466377@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Tali Perry <tali.perry1@gmail.com>

[ Upstream commit d7aa1b149b8fc04d802879cf4662010aa4a42deb ]

Correct the slave transaction logic to be compatible with the generic
slave backend driver.

Fixes: 56a1485b102e ("i2c: npcm7xx: Add Nuvoton NPCM I2C controller driver")
Signed-off-by: Tali Perry <tali.perry1@gmail.com>
Signed-off-by: Tyrone Ting <kfting@nuvoton.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-npcm7xx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-npcm7xx.c b/drivers/i2c/busses/i2c-npcm7xx.c
index ab31e7fb4cc9..31e3d2c9d6bc 100644
--- a/drivers/i2c/busses/i2c-npcm7xx.c
+++ b/drivers/i2c/busses/i2c-npcm7xx.c
@@ -912,11 +912,15 @@ static int npcm_i2c_slave_get_wr_buf(struct npcm_i2c *bus)
 	for (i = 0; i < I2C_HW_FIFO_SIZE; i++) {
 		if (bus->slv_wr_size >= I2C_HW_FIFO_SIZE)
 			break;
-		i2c_slave_event(bus->slave, I2C_SLAVE_READ_REQUESTED, &value);
+		if (bus->state == I2C_SLAVE_MATCH) {
+			i2c_slave_event(bus->slave, I2C_SLAVE_READ_REQUESTED, &value);
+			bus->state = I2C_OPER_STARTED;
+		} else {
+			i2c_slave_event(bus->slave, I2C_SLAVE_READ_PROCESSED, &value);
+		}
 		ind = (bus->slv_wr_ind + bus->slv_wr_size) % I2C_HW_FIFO_SIZE;
 		bus->slv_wr_buf[ind] = value;
 		bus->slv_wr_size++;
-		i2c_slave_event(bus->slave, I2C_SLAVE_READ_PROCESSED, &value);
 	}
 	return I2C_HW_FIFO_SIZE - ret;
 }
@@ -964,7 +968,6 @@ static void npcm_i2c_slave_xmit(struct npcm_i2c *bus, u16 nwrite,
 	if (nwrite == 0)
 		return;
 
-	bus->state = I2C_OPER_STARTED;
 	bus->operation = I2C_WRITE_OPER;
 
 	/* get the next buffer */
-- 
2.35.1



