Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74E494F2F5C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350260AbiDEJ4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242665AbiDEJIQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:08:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B6A7463A;
        Tue,  5 Apr 2022 01:57:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B987661562;
        Tue,  5 Apr 2022 08:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD010C385A0;
        Tue,  5 Apr 2022 08:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149029;
        bh=x8e3y/VMMWTKGFja9YZi+iTh0PRvryetCxFkEUBsjgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DcFaZAPCKpVEHoHaMKm/HQ1k2mbcvKSQzC2CICnTjjLwqE0+UAbLqByNqMhil1D0h
         DkvntJ0VZzb2czOGE8BCWqk4V6cihf179n5FOFUjon9MNOepHjp3KmcMgj9CqqshRR
         cnAsm0ewoQCMBCq8rrBDJfguARYfn1hf9w15F8Tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0568/1017] i2c: xiic: Make bus names unique
Date:   Tue,  5 Apr 2022 09:24:41 +0200
Message-Id: <20220405070411.139968942@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index eb789cfb9973..ffefe3c482e9 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -734,7 +734,6 @@ static const struct i2c_adapter_quirks xiic_quirks = {
 
 static const struct i2c_adapter xiic_adapter = {
 	.owner = THIS_MODULE,
-	.name = DRIVER_NAME,
 	.class = I2C_CLASS_DEPRECATED,
 	.algo = &xiic_algorithm,
 	.quirks = &xiic_quirks,
@@ -771,6 +770,8 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 	i2c_set_adapdata(&i2c->adap, i2c);
 	i2c->adap.dev.parent = &pdev->dev;
 	i2c->adap.dev.of_node = pdev->dev.of_node;
+	snprintf(i2c->adap.name, sizeof(i2c->adap.name),
+		 DRIVER_NAME " %s", pdev->name);
 
 	mutex_init(&i2c->lock);
 
-- 
2.34.1



