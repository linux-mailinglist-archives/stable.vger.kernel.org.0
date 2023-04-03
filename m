Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564026D4AF3
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234237AbjDCOv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234198AbjDCOvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:51:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E238E29073
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:50:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14B7AB81D77
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:50:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860BCC433D2;
        Mon,  3 Apr 2023 14:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533435;
        bh=K93TzVUGAbICEv8kzntBpyla6FXHDXRk6cf3zxbtReY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mX6hkagah542xA+01uY4UTSWaxI+mHuvEbw5A+nFOiuTAwREXWx8T8kV93jWpTYfR
         3cYGpWk0pqR2sOky7PC5PnWn10ajt3CDukNobqTrt12byA7brGICOqRJQVHM2g12U5
         T2zOMMU7u7W8wv5uik1oL4Ej+rc0AyYdVvEFIveg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.2 153/187] thermal: intel: int340x: processor_thermal: Fix additional deadlock
Date:   Mon,  3 Apr 2023 16:09:58 +0200
Message-Id: <20230403140421.096958325@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
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

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit a57cc2dbb3738930d9cb361b9b473f90c8ede0b8 upstream.

Commit 52f04f10b900 ("thermal: intel: int340x: processor_thermal: Fix
deadlock") addressed deadlock issue during user space trip update. But it
missed a case when thermal zone device is disabled when user writes 0.

Call to thermal_zone_device_disable() also causes deadlock as it also
tries to lock tz->lock, which is already claimed by trip_point_temp_store()
in the thermal core code.

Remove call to thermal_zone_device_disable() in the function
sys_set_trip_temp(), which is called from trip_point_temp_store().

Fixes: 52f04f10b900 ("thermal: intel: int340x: processor_thermal: Fix deadlock")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: 6.2+ <stable@vger.kernel.org> # 6.2+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
@@ -181,7 +181,6 @@ static int sys_set_trip_temp(struct ther
 		cancel_delayed_work_sync(&pci_info->work);
 		proc_thermal_mmio_write(pci_info, PROC_THERMAL_MMIO_INT_ENABLE_0, 0);
 		proc_thermal_mmio_write(pci_info, PROC_THERMAL_MMIO_THRES_0, 0);
-		thermal_zone_device_disable(tzd);
 		pci_info->stored_thres = 0;
 		return 0;
 	}


