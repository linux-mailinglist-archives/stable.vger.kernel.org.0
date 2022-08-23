Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E84759DC65
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353565AbiHWKe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353973AbiHWKcy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:32:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B26A59B2;
        Tue, 23 Aug 2022 02:06:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D63066155D;
        Tue, 23 Aug 2022 09:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8B8C433D7;
        Tue, 23 Aug 2022 09:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245610;
        bh=go/Haau0lthCUe3VavTCa+hFobbLbcMtiNUfAjzIzeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aF+ImNbrw6DcEpkeDSSwKckfi/U1R6doISK72LlKEByJCabtcjoqkK8Ix9cAbEEbm
         O5wOS5uE3A4XaqRZEYWkrdFHNqGZ+Kp8vhKZLX2qplFRL+KkdqzkJv+bwUbKZsYBsg
         FWiUVr+EO0x7AtA4W9xkN3DJsAM6WwOvBPxmQK/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Shubhrajyoti Datta <Shubhrajyoti.datta@amd.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 105/287] i2c: cadence: Support PEC for SMBus block read
Date:   Tue, 23 Aug 2022 10:24:34 +0200
Message-Id: <20220823080103.911961465@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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

From: Lars-Peter Clausen <lars@metafoo.de>

[ Upstream commit 9fdf6d97f03035ad5298e2d1635036c74c2090ed ]

SMBus packet error checking (PEC) is implemented by appending one
additional byte of checksum data at the end of the message. This provides
additional protection and allows to detect data corruption on the I2C bus.

SMBus block reads support variable length reads. The first byte in the read
message is the number of available data bytes.

The combination of PEC and block read is currently not supported by the
Cadence I2C driver.
 * When PEC is enabled the maximum transfer length for block reads
   increases from 33 to 34 bytes.
 * The I2C core smbus emulation layer relies on the driver updating the
   `i2c_msg` `len` field with the number of received bytes. The updated
   length is used when checking the PEC.

Add support to the Cadence I2C driver for handling SMBus block reads with
PEC. To determine the maximum transfer length uses the initial `len` value
of the `i2c_msg`. When PEC is enabled this will be 2, when it is disabled
it will be 1.

Once a read transfer is done also increment the `len` field by the amount
of received data bytes.

This change has been tested with a UCM90320 PMBus power monitor, which
requires block reads to access certain data fields, but also has PEC
enabled by default.

Fixes: df8eb5691c48 ("i2c: Add driver for Cadence I2C controller")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Tested-by: Shubhrajyoti Datta <Shubhrajyoti.datta@amd.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-cadence.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
index 512c61d31fe5..bce7bf93d62a 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -353,8 +353,13 @@ static void cdns_i2c_mrecv(struct cdns_i2c *id)
 	ctrl_reg = cdns_i2c_readreg(CDNS_I2C_CR_OFFSET);
 	ctrl_reg |= CDNS_I2C_CR_RW | CDNS_I2C_CR_CLR_FIFO;
 
+	/*
+	 * Receive up to I2C_SMBUS_BLOCK_MAX data bytes, plus one message length
+	 * byte, plus one checksum byte if PEC is enabled. p_msg->len will be 2 if
+	 * PEC is enabled, otherwise 1.
+	 */
 	if (id->p_msg->flags & I2C_M_RECV_LEN)
-		id->recv_count = I2C_SMBUS_BLOCK_MAX + 1;
+		id->recv_count = I2C_SMBUS_BLOCK_MAX + id->p_msg->len;
 
 	id->curr_recv_count = id->recv_count;
 
@@ -540,6 +545,9 @@ static int cdns_i2c_process_msg(struct cdns_i2c *id, struct i2c_msg *msg,
 	if (id->err_status & CDNS_I2C_IXR_ARB_LOST)
 		return -EAGAIN;
 
+	if (msg->flags & I2C_M_RECV_LEN)
+		msg->len += min_t(unsigned int, msg->buf[0], I2C_SMBUS_BLOCK_MAX);
+
 	return 0;
 }
 
-- 
2.35.1



