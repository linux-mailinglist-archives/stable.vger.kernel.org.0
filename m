Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473266CC2A5
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbjC1OrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbjC1OrC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:47:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B40E075
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:46:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27EF66181A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:46:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25317C433EF;
        Tue, 28 Mar 2023 14:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014788;
        bh=mD7KZHSfmn2TfzY1Qb/wzUpkBEpQ5uZNDJJgY+CzLFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wWRRj2qqKrYVcCj0QtR8LWIoZWQgZXzr5OuOuP6n5G2Pv6HnPkPY3RseNSK0/SMPq
         4HA4uLDPTLD9BcLh2D74P29fzTf6wrhCiXiO5SvwUBkOJJMVn3b5mL1yE9AwQBM5Ns
         1dOpAacsMtx8x6fP/pyXU6/zpQHQigUQA1Clbc8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ido Schimmel <idosch@nvidia.com>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 052/240] mlxsw: core_thermal: Fix fan speed in maximum cooling state
Date:   Tue, 28 Mar 2023 16:40:15 +0200
Message-Id: <20230328142621.874497031@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 6d206b1ea9f48433a96edec7028586db1d947911 ]

The cooling levels array is supposed to prevent the system fans from
being configured below a 20% duty cycle as otherwise some of them get
stuck at 0 RPM.

Due to an off-by-one error, the last element in the array was not
initialized, causing it to be set to zero, which in turn lead to fans
being configured with a 0% duty cycle in maximum cooling state.

Since commit 332fdf951df8 ("mlxsw: thermal: Fix out-of-bounds memory
accesses") the contents of the array are static. Therefore, instead of
fixing the initialization of the array, simply remove it and adjust
thermal_cooling_device_ops::set_cur_state() so that the configured duty
cycle is never set below 20%.

Before:

 # cat /sys/class/thermal/thermal_zone0/cdev0/type
 mlxsw_fan
 # echo 10 > /sys/class/thermal/thermal_zone0/cdev0/cur_state
 # cat /sys/class/hwmon/hwmon0/name
 mlxsw
 # cat /sys/class/hwmon/hwmon0/pwm1
 0

After:

 # cat /sys/class/thermal/thermal_zone0/cdev0/type
 mlxsw_fan
 # echo 10 > /sys/class/thermal/thermal_zone0/cdev0/cur_state
 # cat /sys/class/hwmon/hwmon0/name
 mlxsw
 # cat /sys/class/hwmon/hwmon0/pwm1
 255

This bug was uncovered when the thermal subsystem repeatedly tried to
configure the cooling devices to their maximum state due to another
issue [1]. This resulted in the fans being stuck at 0 RPM, which
eventually lead to the system undergoing thermal shutdown.

[1] https://lore.kernel.org/netdev/ZA3CFNhU4AbtsP4G@shredder/

Fixes: a421ce088ac8 ("mlxsw: core: Extend cooling device with cooling levels")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index c5240d38c9dbd..09ed6e5fa6c34 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -105,7 +105,6 @@ struct mlxsw_thermal {
 	struct thermal_zone_device *tzdev;
 	int polling_delay;
 	struct thermal_cooling_device *cdevs[MLXSW_MFCR_PWMS_MAX];
-	u8 cooling_levels[MLXSW_THERMAL_MAX_STATE + 1];
 	struct thermal_trip trips[MLXSW_THERMAL_NUM_TRIPS];
 	struct mlxsw_cooling_states cooling_states[MLXSW_THERMAL_NUM_TRIPS];
 	struct mlxsw_thermal_area line_cards[];
@@ -468,7 +467,7 @@ static int mlxsw_thermal_set_cur_state(struct thermal_cooling_device *cdev,
 		return idx;
 
 	/* Normalize the state to the valid speed range. */
-	state = thermal->cooling_levels[state];
+	state = max_t(unsigned long, MLXSW_THERMAL_MIN_STATE, state);
 	mlxsw_reg_mfsc_pack(mfsc_pl, idx, mlxsw_state_to_duty(state));
 	err = mlxsw_reg_write(thermal->core, MLXSW_REG(mfsc), mfsc_pl);
 	if (err) {
@@ -859,10 +858,6 @@ int mlxsw_thermal_init(struct mlxsw_core *core,
 		}
 	}
 
-	/* Initialize cooling levels per PWM state. */
-	for (i = 0; i < MLXSW_THERMAL_MAX_STATE; i++)
-		thermal->cooling_levels[i] = max(MLXSW_THERMAL_MIN_STATE, i);
-
 	thermal->polling_delay = bus_info->low_frequency ?
 				 MLXSW_THERMAL_SLOW_POLL_INT :
 				 MLXSW_THERMAL_POLL_INT;
-- 
2.39.2



