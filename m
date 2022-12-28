Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6095E658190
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234725AbiL1Q3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234727AbiL1Q3P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:29:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BC21ADAD
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:25:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4ACA6157E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C734BC433F0;
        Wed, 28 Dec 2022 16:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244727;
        bh=2XWfSZYbI6YoClcn96G8jqeqoBYnucAK5ZLC7NSZHsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FcbaGDvgiPAWd0fCw8IFQKtep/MGlEaG0icGpFlB/le/A/VFz8OrM4j/mIMdzN/ow
         xfvxoOQcC0sKLCHww7vtVTh5quZHxa0MS9o6ueTw/rIYHtCeQj9jpq+SqbVwQ+cuD/
         P3gL0D0PizDqkGYfpJUROlozmC4/pZtzq+uk0xCA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mike Leach <mike.leach@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0726/1146] coresight: cti: Fix null pointer error on CTI init before ETM
Date:   Wed, 28 Dec 2022 15:37:45 +0100
Message-Id: <20221228144349.864572847@linuxfoundation.org>
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

From: Mike Leach <mike.leach@linaro.org>

[ Upstream commit 3dc228b35387803d9c43ed1b098aabb1d3ae9c7d ]

When CTI is discovered first then the function
coresight_set_assoc_ectdev_mutex() is called to set the association
between CTI and ETM device. Recent lockdep fix passes a null pointer.

This patch passes the correct pointer.

Before patch: log of boot oops sequence with CTI discovered first:

[   12.424091]  cs_system_cfg: CoreSight Configuration manager initialised
[   12.483474] coresight cti_sys0: CTI initialized
[   12.488109] coresight cti_sys1: CTI initialized
[   12.503594] coresight cti_cpu0: CTI initialized
[   12.517877] coresight-cpu-debug 850000.debug: Coresight debug-CPU0 initialized
[   12.523479] coresight-cpu-debug 852000.debug: Coresight debug-CPU1 initialized
[   12.529926] coresight-cpu-debug 854000.debug: Coresight debug-CPU2 initialized
[   12.541808] coresight stm0: STM32 initialized
[   12.544421] coresight-cpu-debug 856000.debug: Coresight debug-CPU3 initialized
[   12.585639] coresight cti_cpu1: CTI initialized
[   12.614028] coresight cti_cpu2: CTI initialized
[   12.631679] CSCFG registered etm0
[   12.633920] coresight etm0: CPU0: etm v4.0 initialized
[   12.656392] coresight cti_cpu3: CTI initialized

...

[   12.708383] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000348

...

[   12.755094] Internal error: Oops: 0000000096000044 [#1] SMP
[   12.761817] Modules linked in: coresight_etm4x(+) coresight_tmc coresight_cpu_debug coresight_replicator coresight_funnel coresight_cti coresight_tpiu coresight_stm coresight
[   12.767210] CPU: 3 PID: 1346 Comm: systemd-udevd Not tainted 6.1.0-rc3tid-v6tid-v6-235166-gf7f7d7a2204a-dirty #498
[   12.782827] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[   12.793154] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   12.800010] pc : coresight_set_assoc_ectdev_mutex+0x30/0x50 [coresight]
[   12.806694] lr : coresight_set_assoc_ectdev_mutex+0x30/0x50 [coresight]

...

[   12.885064] Call trace:
[   12.892352]  coresight_set_assoc_ectdev_mutex+0x30/0x50 [coresight]
[   12.894693]  cti_add_assoc_to_csdev+0x144/0x1b0 [coresight_cti]
[   12.900943]  coresight_register+0x2c8/0x320 [coresight]
[   12.906844]  etm4_add_coresight_dev.isra.27+0x148/0x280 [coresight_etm4x]
[   12.912056]  etm4_probe+0x144/0x1c0 [coresight_etm4x]
[   12.918998]  etm4_probe_amba+0x40/0x78 [coresight_etm4x]
[   12.924032]  amba_probe+0x11c/0x1f0

After patch: similar log

[   12.444467]  cs_system_cfg: CoreSight Configuration manager initialised
[   12.456329] coresight-cpu-debug 850000.debug: Coresight debug-CPU0 initialized
[   12.456754] coresight-cpu-debug 852000.debug: Coresight debug-CPU1 initialized
[   12.469672] coresight-cpu-debug 854000.debug: Coresight debug-CPU2 initialized
[   12.476098] coresight-cpu-debug 856000.debug: Coresight debug-CPU3 initialized
[   12.532409] coresight stm0: STM32 initialized
[   12.533708] coresight cti_sys0: CTI initialized
[   12.539478] coresight cti_sys1: CTI initialized
[   12.550106] coresight cti_cpu0: CTI initialized
[   12.633931] coresight cti_cpu1: CTI initialized
[   12.634664] coresight cti_cpu2: CTI initialized
[   12.638090] coresight cti_cpu3: CTI initialized
[   12.721136] CSCFG registered etm0

...

[   12.762643] CSCFG registered etm1
[   12.762666] coresight etm1: CPU1: etm v4.0 initialized
[   12.776258] CSCFG registered etm2
[   12.776282] coresight etm2: CPU2: etm v4.0 initialized
[   12.784357] CSCFG registered etm3
[   12.785455] coresight etm3: CPU3: etm v4.0 initialized

Error can also be triggered by manually starting the modules using modprobe
in the following order:

root@linaro-developer:/home/linaro/cs-mods# modprobe coresight
root@linaro-developer:/home/linaro/cs-mods# modprobe coresight-cti
root@linaro-developer:/home/linaro/cs-mods# modprobe coresight-etm4x

Tested on Dragonboard DB410c
Applies to coresight/next

Fixes: 23722fb46725 ("coresight: Fix possible deadlock with lock dependency")
Signed-off-by: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20221123193818.6253-1-mike.leach@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-cti-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-cti-core.c b/drivers/hwtracing/coresight/coresight-cti-core.c
index c6e8c6542f24..d2cf4f4848e1 100644
--- a/drivers/hwtracing/coresight/coresight-cti-core.c
+++ b/drivers/hwtracing/coresight/coresight-cti-core.c
@@ -564,7 +564,7 @@ static void cti_add_assoc_to_csdev(struct coresight_device *csdev)
 			 * if we found a matching csdev then update the ECT
 			 * association pointer for the device with this CTI.
 			 */
-			coresight_set_assoc_ectdev_mutex(csdev->ect_dev,
+			coresight_set_assoc_ectdev_mutex(csdev,
 							 ect_item->csdev);
 			break;
 		}
-- 
2.35.1



