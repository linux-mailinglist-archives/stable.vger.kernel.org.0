Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0596BB2D7
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbjCOMjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232741AbjCOMir (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:38:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99CE9E674
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:37:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BD12B81DFC
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66561C4339C;
        Wed, 15 Mar 2023 12:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883844;
        bh=c1T0vYEJvJPi5fSkXTG7J+G0LmvBX/Y6VAVG1qHDWXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tQ5PM56UZe1Yx+bCA9hb3ptWxHen1hgnnYor2o5OdKO7b+Cm2ncP6hJbznhGJ4hJm
         rnDSu4ItxluLvYrY5ceUZbKF3UmgTs4vnuW5OU6MrJWhH3FU7JQ2vtm4jmY7oP8lHm
         5ZwrTrCCzI4HKAeYu/LcY3m1NNf5ONU9I4NnSSMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Srinivas Pandruvada <srinivas.pandruvada@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.2 010/141] thermal: intel: int340x: processor_thermal: Fix deadlock
Date:   Wed, 15 Mar 2023 13:11:53 +0100
Message-Id: <20230315115740.281825112@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@intel.com>

commit 52f04f10b9005ac4ce640da14a52ed7a146432fa upstream.

When user space updates the trip point there is a deadlock, which results
in caller gets blocked forever.

Commit 05eeee2b51b4 ("thermal/core: Protect sysfs accesses to thermal
operations with thermal zone mutex"), added a mutex for tz->lock in the
function trip_point_temp_store(). Hence, trip set callback() can't
call any thermal zone API as they are protected with the same mutex lock.

The callback here calling thermal_zone_device_enable(), which will result
in deadlock.

Move the thermal_zone_device_enable() to proc_thermal_pci_probe() to
avoid this deadlock.

Fixes: 05eeee2b51b4 ("thermal/core: Protect sysfs accesses to thermal operations with thermal zone mutex")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@intel.com>
Cc: 6.2+ <stable@vger.kernel.org> # 6.2+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
@@ -194,7 +194,6 @@ static int sys_set_trip_temp(struct ther
 	proc_thermal_mmio_write(pci_info, PROC_THERMAL_MMIO_THRES_0, _temp);
 	proc_thermal_mmio_write(pci_info, PROC_THERMAL_MMIO_INT_ENABLE_0, 1);
 
-	thermal_zone_device_enable(tzd);
 	pci_info->stored_thres = temp;
 
 	return 0;
@@ -277,6 +276,10 @@ static int proc_thermal_pci_probe(struct
 		goto err_free_vectors;
 	}
 
+	ret = thermal_zone_device_enable(pci_info->tzone);
+	if (ret)
+		goto err_free_vectors;
+
 	return 0;
 
 err_free_vectors:


