Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD3C658223
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234716AbiL1QdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234737AbiL1Qc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:32:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6D71AA1F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:30:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A90E2B8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFF6C433D2;
        Wed, 28 Dec 2022 16:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245012;
        bh=01TqsPXih8vjFID4riRu44CPevu2oWreO66JEkHC4SQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1DbTIasX0f/QO1wgXGQVPtwX+G2cO7EN68cmO1QxXLhV6Kx2PqPBu41jAmvlIB0ea
         vcONmGd3g4rMI07519Uo3TQLFKpCL0k6ElWftuieWDh7lFrJyMOFHcrmJv9RDlntoC
         dgYHw1oOz/h6gliEUwArSfhLOmOGOQ3ewP8cWJbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ido Schimmel <idosch@nvidia.com>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0751/1146] thermal/of: Fix memory leak on thermal_of_zone_register() failure
Date:   Wed, 28 Dec 2022 15:38:10 +0100
Message-Id: <20221228144350.542980666@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 7ef2f023c2c77a452ba5d0c9b1ad04a5a895d553 ]

The function does not free 'of_ops' upon failure, leading to a memory
leak [1].

Fix by freeing 'of_ops' in the error path.

[1]
unreferenced object 0xffff8ee846198c80 (size 128):
  comm "swapper/0", pid 1, jiffies 4294699704 (age 70.076s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    d0 3f 6e 8c ff ff ff ff 00 00 00 00 00 00 00 00  .?n.............
  backtrace:
    [<00000000d136f562>] __kmalloc_node_track_caller+0x42/0x120
    [<0000000063f31678>] kmemdup+0x1d/0x40
    [<00000000e6d24096>] thermal_of_zone_register+0x49/0x520
    [<000000005e78c755>] devm_thermal_of_zone_register+0x54/0x90
    [<00000000ee6b209e>] pmbus_add_sensor+0x1b4/0x1d0
    [<00000000896105e3>] pmbus_add_sensor_attrs_one+0x123/0x440
    [<0000000049e990a6>] pmbus_add_sensor_attrs+0xfe/0x1d0
    [<00000000466b5440>] pmbus_do_probe+0x66b/0x14e0
    [<0000000084d42285>] i2c_device_probe+0x13b/0x2f0
    [<0000000029e2ae74>] really_probe+0xce/0x2c0
    [<00000000692df15c>] driver_probe_device+0x19/0xd0
    [<00000000547d9cce>] __device_attach_driver+0x6f/0x100
    [<0000000020abd24b>] bus_for_each_drv+0x76/0xc0
    [<00000000665d9563>] __device_attach+0xfc/0x180
    [<000000008ddd4d6a>] bus_probe_device+0x82/0xa0
    [<000000009e61132b>] device_add+0x3fe/0x920

Fixes: 3fd6d6e2b4e8 ("thermal/of: Rework the thermal device tree initialization")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Vadim Pasternak <vadimp@nvidia.com>
Link: https://lore.kernel.org/r/20221020103658.802457-1-idosch@nvidia.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_of.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_of.c b/drivers/thermal/thermal_of.c
index d4b6335ace15..aacba30bc10c 100644
--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -604,13 +604,15 @@ struct thermal_zone_device *thermal_of_zone_register(struct device_node *sensor,
 	if (IS_ERR(np)) {
 		if (PTR_ERR(np) != -ENODEV)
 			pr_err("Failed to find thermal zone for %pOFn id=%d\n", sensor, id);
-		return ERR_CAST(np);
+		ret = PTR_ERR(np);
+		goto out_kfree_of_ops;
 	}
 
 	trips = thermal_of_trips_init(np, &ntrips);
 	if (IS_ERR(trips)) {
 		pr_err("Failed to find trip points for %pOFn id=%d\n", sensor, id);
-		return ERR_CAST(trips);
+		ret = PTR_ERR(trips);
+		goto out_kfree_of_ops;
 	}
 
 	ret = thermal_of_monitor_init(np, &delay, &pdelay);
@@ -659,6 +661,8 @@ struct thermal_zone_device *thermal_of_zone_register(struct device_node *sensor,
 	kfree(tzp);
 out_kfree_trips:
 	kfree(trips);
+out_kfree_of_ops:
+	kfree(of_ops);
 
 	return ERR_PTR(ret);
 }
-- 
2.35.1



