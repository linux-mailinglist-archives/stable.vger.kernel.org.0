Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE444F3C04
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382269AbiDEMD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358147AbiDEK2C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:28:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759DF9BBB8;
        Tue,  5 Apr 2022 03:15:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2ECB7B81C98;
        Tue,  5 Apr 2022 10:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DE9C385A0;
        Tue,  5 Apr 2022 10:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153754;
        bh=pllJwSg82srfAKyDgvJ4BWWLH9Horfff9Wx5+FML3QA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XtravBLMLz5dcQzsfBBzSsz6ZqUf7TThda3enjHf3DokVi2C5rJReiRwnJSOV2/li
         H/tSNOAjr5V6Mn8lAPZJXqLUiy/KCCjofpGSaNuKliovM6pYs4vJea+CAqwvCTM6D7
         3qyxNAJ6IYX/Z3KGR2+kX6ISoc/rEiJn2s0mAlxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 336/599] i2c: xiic: Make bus names unique
Date:   Tue,  5 Apr 2022 09:30:30 +0200
Message-Id: <20220405070308.830822507@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit 1d366c2f9df8279df2adbb60471f86fc40a1c39e ]

This driver is for an FPGA logic core, so there can be arbitrarily many
instances of the bus on a given system. Previously all of the I2C bus
names were "xiic-i2c" which caused issues with lm_sensors when trying to
map human-readable names to sensor inputs because it could not properly
distinguish the busses, for example. Append the platform device name to
the I2C bus name so it is unique between different instances.

Fixes: e1d5b6598cdc ("i2c: Add support for Xilinx XPS IIC Bus Interface")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Tested-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-xiic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 2a8568b97c14..8dabb6ffb1a4 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -756,7 +756,6 @@ static const struct i2c_adapter_quirks xiic_quirks = {
 
 static const struct i2c_adapter xiic_adapter = {
 	.owner = THIS_MODULE,
-	.name = DRIVER_NAME,
 	.class = I2C_CLASS_DEPRECATED,
 	.algo = &xiic_algorithm,
 	.quirks = &xiic_quirks,
@@ -793,6 +792,8 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 	i2c_set_adapdata(&i2c->adap, i2c);
 	i2c->adap.dev.parent = &pdev->dev;
 	i2c->adap.dev.of_node = pdev->dev.of_node;
+	snprintf(i2c->adap.name, sizeof(i2c->adap.name),
+		 DRIVER_NAME " %s", pdev->name);
 
 	mutex_init(&i2c->lock);
 	init_waitqueue_head(&i2c->wait);
-- 
2.34.1



