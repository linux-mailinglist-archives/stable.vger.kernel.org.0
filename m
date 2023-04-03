Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE186D4698
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbjDCOLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbjDCOLl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:11:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5820A2D7CB
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:11:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7708A61C0C
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0ADC433EF;
        Mon,  3 Apr 2023 14:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531081;
        bh=ygSp+g4Y+Ab1hDgl4rqv7mauQJdy7Fttff9lMibTLK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dKKIm9Jm1EUivHAJb4wDvgrNN2OwlwT9xu5TBJ5Cp8NkIFDW8JMq1iKPuzjG03bHA
         n2/DuANwx1R3AFa5ZqwQgOCGO47+4nfVhU+kOlWWqsKlI5bPfGtG70GEQ8Hyl9l/+g
         4+SJ8aiNTC+kxL/DcxPifu02sD+A1SfXlp1gYDKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 05/66] i2c: imx-lpi2c: check only for enabled interrupt flags
Date:   Mon,  3 Apr 2023 16:08:13 +0200
Message-Id: <20230403140351.940895159@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140351.636471867@linuxfoundation.org>
References: <20230403140351.636471867@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 1c7885004567e8951d65a983be095f254dd20bef ]

When reading from I2C, the Tx watermark is set to 0. Unfortunately the
TDF (transmit data flag) is enabled when Tx FIFO entries is equal or less
than watermark. So it is set in every case, hence the reset default of 1.
This results in the MSR_RDF _and_ MSR_TDF flags to be set thus trying
to send Tx data on a read message.
Mask the IRQ status to filter for wanted flags only.

Fixes: a55fa9d0e42e ("i2c: imx-lpi2c: add low power i2c bus driver")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Tested-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-imx-lpi2c.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/i2c/busses/i2c-imx-lpi2c.c b/drivers/i2c/busses/i2c-imx-lpi2c.c
index e86801a631206..ca4d554126579 100644
--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -515,10 +515,14 @@ static int lpi2c_imx_xfer(struct i2c_adapter *adapter,
 static irqreturn_t lpi2c_imx_isr(int irq, void *dev_id)
 {
 	struct lpi2c_imx_struct *lpi2c_imx = dev_id;
+	unsigned int enabled;
 	unsigned int temp;
 
+	enabled = readl(lpi2c_imx->base + LPI2C_MIER);
+
 	lpi2c_imx_intctrl(lpi2c_imx, 0);
 	temp = readl(lpi2c_imx->base + LPI2C_MSR);
+	temp &= enabled;
 
 	if (temp & MSR_RDF)
 		lpi2c_imx_read_rxfifo(lpi2c_imx);
-- 
2.39.2



