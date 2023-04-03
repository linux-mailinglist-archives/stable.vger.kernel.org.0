Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 392036D4700
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbjDCOQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232936AbjDCOQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:16:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5894C37
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:16:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 764BEB81B7A
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FCEC433EF;
        Mon,  3 Apr 2023 14:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531366;
        bh=ymV3qQoNOdqd52qbcIpxlAVjrBhkTYZ47o+oq7kx8Kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OltADVTNk+S3qfAMICnKVWIDdueqCeZW5gywqYilbyNCaOiMEA2xOfe3t4Z9mzon8
         J4Vx5zeenZKoSIcr8UMfpYFs4vtvaYGQtovMflhamf4LMq6qOXFdyfRgerN/cZpYet
         k82aOdWsC5s18S5U3yKsflwakpEOrHQvLNPpsX8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/84] i2c: imx-lpi2c: check only for enabled interrupt flags
Date:   Mon,  3 Apr 2023 16:08:09 +0200
Message-Id: <20230403140353.688815575@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
index 06c4c767af322..90c510d166516 100644
--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -508,10 +508,14 @@ static int lpi2c_imx_xfer(struct i2c_adapter *adapter,
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



