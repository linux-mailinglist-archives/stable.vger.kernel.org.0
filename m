Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334EC59DF4D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242453AbiHWLLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357151AbiHWLIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:08:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504D387688;
        Tue, 23 Aug 2022 02:16:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 160D8B8105C;
        Tue, 23 Aug 2022 09:16:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779CEC433D6;
        Tue, 23 Aug 2022 09:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246175;
        bh=/LXsrzw1yxQGL9b1Zmq8Ccx2wUQqoyNaeI0G2abhPFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HG0NmLXPjVZdncWQkK7z6ux8njlUE33uYSn2bZ/L5GmjUnIH06lhYtyR6b5mDrsv8
         +YbiKiMH7m82BYZoJMYVn6XtHjfF8kAFsDU2AImSMuzD4klzM0Qq25O+MPDKtlnkOb
         hhzkLjrgteehUjYNRNQCfGtDPq5SkT6IINmutAug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Di Shen <di.shen@unisoc.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 025/389] thermal: sysfs: Fix cooling_device_stats_setup() error code path
Date:   Tue, 23 Aug 2022 10:21:43 +0200
Message-Id: <20220823080116.750336144@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
@@ -909,12 +909,13 @@ static const struct attribute_group cool
 
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
 
@@ -924,7 +925,7 @@ static void cooling_device_stats_setup(s
 
 	stats = kzalloc(var, GFP_KERNEL);
 	if (!stats)
-		return;
+		goto out;
 
 	stats->time_in_state = (ktime_t *)(stats + 1);
 	stats->trans_table = (unsigned int *)(stats->time_in_state + states);
@@ -934,9 +935,12 @@ static void cooling_device_stats_setup(s
 
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


