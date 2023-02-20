Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584C669CC90
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbjBTNlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbjBTNlq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:41:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122A51DB91
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:41:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E17F60D41
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15A5C433EF;
        Mon, 20 Feb 2023 13:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900482;
        bh=wkoPyxKt6DXotv4X9bXJr15HY2B8eSdYA+vfj3db58g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XrJO2Cn064oog6pAfpCfIGO6m+IuoZXb+6UL+uNAqQ3MXU8AdJ87QZSHNOQ4wa2Nm
         HvoysSqzq7OfZOx0VbdUW7Rstzp7fOcs9R1g+ujWT7bL03PsD7kLWrqprillDEZf2D
         LOIxWWsJY6JM5aIPjG3B7xuTNjL64DBCa2qWFAPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.19 41/89] thermal: intel: int340x: Add locking to int340x_thermal_get_trip_type()
Date:   Mon, 20 Feb 2023 14:35:40 +0100
Message-Id: <20230220133554.583501168@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit acd7e9ee57c880b99671dd99680cb707b7b5b0ee upstream.

In order to prevent int340x_thermal_get_trip_type() from possibly
racing with int340x_thermal_read_trips() invoked by int3403_notify()
add locking to it in analogy with int340x_thermal_get_trip_temp().

Fixes: 6757a7abe47b ("thermal: intel: int340x: Protect trip temperature from concurrent updates")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/int340x_thermal/int340x_thermal_zone.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/thermal/int340x_thermal/int340x_thermal_zone.c
+++ b/drivers/thermal/int340x_thermal/int340x_thermal_zone.c
@@ -89,11 +89,13 @@ static int int340x_thermal_get_trip_type
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
@@ -111,10 +113,12 @@ static int int340x_thermal_get_trip_type
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


