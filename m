Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38B268126E
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237648AbjA3OVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:21:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237663AbjA3OUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:20:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E568F38678
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:19:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3509D610A4
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3B6C433D2;
        Mon, 30 Jan 2023 14:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088343;
        bh=lN6k3dcEO1OI6t8RlQqlMqMPRbyUdFnqj+8KhAzMYSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GpC1kUq/4ql5yARxeZtDRkshlOLnDQN/C9zZX4//bmZOf0gQi9esfpRVjOWIkUcza
         QiIn36Jyzp7Z7kQ4VQX3yqwCjX2TFbwgSM1fYZS/hovIvsnkSdjWnM1WL1H27+n3kH
         5llXfvM73JYv+SDhZtLQUVyChTTI3A84akh63QkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 192/204] thermal: intel: int340x: Add locking to int340x_thermal_get_trip_type()
Date:   Mon, 30 Jan 2023 14:52:37 +0100
Message-Id: <20230130134325.004432855@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit acd7e9ee57c880b99671dd99680cb707b7b5b0ee ]

In order to prevent int340x_thermal_get_trip_type() from possibly
racing with int340x_thermal_read_trips() invoked by int3403_notify()
add locking to it in analogy with int340x_thermal_get_trip_temp().

Fixes: 6757a7abe47b ("thermal: intel: int340x: Protect trip temperature from concurrent updates")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/int340x_thermal/int340x_thermal_zone.c       | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
index 852f6c579af5..0a4eaa307156 100644
--- a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
+++ b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
@@ -81,11 +81,13 @@ static int int340x_thermal_get_trip_type(struct thermal_zone_device *zone,
 					 enum thermal_trip_type *type)
 {
 	struct int34x_thermal_zone *d = zone->devdata;
-	int i;
+	int i, ret = 0;
 
 	if (d->override_ops && d->override_ops->get_trip_type)
 		return d->override_ops->get_trip_type(zone, trip, type);
 
+	mutex_lock(&d->trip_mutex);
+
 	if (trip < d->aux_trip_nr)
 		*type = THERMAL_TRIP_PASSIVE;
 	else if (trip == d->crt_trip_id)
@@ -103,10 +105,12 @@ static int int340x_thermal_get_trip_type(struct thermal_zone_device *zone,
 			}
 		}
 		if (i == INT340X_THERMAL_MAX_ACT_TRIP_COUNT)
-			return -EINVAL;
+			ret = -EINVAL;
 	}
 
-	return 0;
+	mutex_unlock(&d->trip_mutex);
+
+	return ret;
 }
 
 static int int340x_thermal_set_trip_temp(struct thermal_zone_device *zone,
-- 
2.39.0



