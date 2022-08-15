Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDA15943DD
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347744AbiHOWHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349782AbiHOWG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:06:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBE54BA52;
        Mon, 15 Aug 2022 12:37:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08EA761089;
        Mon, 15 Aug 2022 19:37:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B65C433D6;
        Mon, 15 Aug 2022 19:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592271;
        bh=aEfeu9f1lMXq8ZH7oRYczw5jkBVwbMgOJJdgiuGDQx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0IOdcFrQR3iofIMmZ+dUgbs7eLmQo0ziSxDDw8vheKFDihURXG6adHdNuOzoEX3W
         TVmqEZwqj42lonVDl/F612kXK/KMEoyjNMsml6ZnUBx48fAwqcaDwiR8oiSu+i9EgN
         OIuiIVr0kgvzaEJPM+0w1ZO5coeSHQIKi/rV8TJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Di Shen <di.shen@unisoc.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.19 0055/1157] thermal: sysfs: Fix cooling_device_stats_setup() error code path
Date:   Mon, 15 Aug 2022 19:50:11 +0200
Message-Id: <20220815180441.655370035@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit d5a8aa5d7d80d21ab6b266f1bed4194b61746199 upstream.

If cooling_device_stats_setup() fails to create the stats object, it
must clear the last slot in cooling_device_attr_groups that was
initially empty (so as to make it possible to add stats attributes to
the cooling device attribute groups).

Failing to do so may cause the stats attributes to be created by
mistake for a device that doesn't have a stats object, because the
slot in question might be populated previously during the registration
of another cooling device.

Fixes: 8ea229511e06 ("thermal: Add cooling device's statistics in sysfs")
Reported-by: Di Shen <di.shen@unisoc.com>
Tested-by: Di Shen <di.shen@unisoc.com>
Cc: 4.17+ <stable@vger.kernel.org> # 4.17+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/thermal_sysfs.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/thermal/thermal_sysfs.c
+++ b/drivers/thermal/thermal_sysfs.c
@@ -813,12 +813,13 @@ static const struct attribute_group cool
 
 static void cooling_device_stats_setup(struct thermal_cooling_device *cdev)
 {
+	const struct attribute_group *stats_attr_group = NULL;
 	struct cooling_dev_stats *stats;
 	unsigned long states;
 	int var;
 
 	if (cdev->ops->get_max_state(cdev, &states))
-		return;
+		goto out;
 
 	states++; /* Total number of states is highest state + 1 */
 
@@ -828,7 +829,7 @@ static void cooling_device_stats_setup(s
 
 	stats = kzalloc(var, GFP_KERNEL);
 	if (!stats)
-		return;
+		goto out;
 
 	stats->time_in_state = (ktime_t *)(stats + 1);
 	stats->trans_table = (unsigned int *)(stats->time_in_state + states);
@@ -838,9 +839,12 @@ static void cooling_device_stats_setup(s
 
 	spin_lock_init(&stats->lock);
 
+	stats_attr_group = &cooling_device_stats_attr_group;
+
+out:
 	/* Fill the empty slot left in cooling_device_attr_groups */
 	var = ARRAY_SIZE(cooling_device_attr_groups) - 2;
-	cooling_device_attr_groups[var] = &cooling_device_stats_attr_group;
+	cooling_device_attr_groups[var] = stats_attr_group;
 }
 
 static void cooling_device_stats_destroy(struct thermal_cooling_device *cdev)


