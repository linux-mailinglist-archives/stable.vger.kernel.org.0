Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADEEC8A01A
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 15:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfHLNxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 09:53:33 -0400
Received: from foss.arm.com ([217.140.110.172]:50496 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbfHLNxd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Aug 2019 09:53:33 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F320915A2;
        Mon, 12 Aug 2019 06:53:32 -0700 (PDT)
Received: from dawn-kernel.cambridge.arm.com (unknown [10.1.197.116])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3226B3F718;
        Mon, 12 Aug 2019 06:53:32 -0700 (PDT)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     stable@vger.kernel.org
Cc:     suzuki.poulose@arm.com, mathieu.poirier@linaro.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org
Subject: [PATCH] coresight: Fix DEBUG_LOCKS_WARN_ON for uninitialized attribute
Date:   Mon, 12 Aug 2019 14:53:28 +0100
Message-Id: <20190812135328.30952-1-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 5511c0c309db4c526a6e9f8b2b8a1483771574bc upstream

While running the linux-next with CONFIG_DEBUG_LOCKS_ALLOC enabled,
I get the following splat.

 BUG: key ffffcb5636929298 has not been registered!
 ------------[ cut here ]------------
 DEBUG_LOCKS_WARN_ON(1)
 WARNING: CPU: 1 PID: 53 at kernel/locking/lockdep.c:3669 lockdep_init_map+0x164/0x1f0
 CPU: 1 PID: 53 Comm: kworker/1:1 Tainted: G  W  5.2.0-next-20190712-00015-g00ad4634222e-dirty #603
 Workqueue: events amba_deferred_retry_func
 pstate: 60c00005 (nZCv daif +PAN +UAO)
 pc : lockdep_init_map+0x164/0x1f0
 lr : lockdep_init_map+0x164/0x1f0

 [ trimmed ]

 Call trace:
  lockdep_init_map+0x164/0x1f0
  __kernfs_create_file+0x9c/0x158
  sysfs_add_file_mode_ns+0xa8/0x1d0
  sysfs_add_file_to_group+0x88/0xd8
  etm_perf_add_symlink_sink+0xcc/0x138
  coresight_register+0x110/0x280
  tmc_probe+0x160/0x420

 [ trimmed ]

 ---[ end trace ab4cc669615ba1b0 ]---

Fix this by initialising the dynamically allocated attribute properly.

Fixes: bb8e370bdc14 ("coresight: perf: Add "sinks" group to PMU directory")
Cc: stable@vger.kernel.org # 5.2.x-
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 drivers/hwtracing/coresight/coresight-etm-perf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwtracing/coresight/coresight-etm-perf.c b/drivers/hwtracing/coresight/coresight-etm-perf.c
index 3c6294432748..1ef098ff27c3 100644
--- a/drivers/hwtracing/coresight/coresight-etm-perf.c
+++ b/drivers/hwtracing/coresight/coresight-etm-perf.c
@@ -544,6 +544,7 @@ int etm_perf_add_symlink_sink(struct coresight_device *csdev)
 	/* See function coresight_get_sink_by_id() to know where this is used */
 	hash = hashlen_hash(hashlen_string(NULL, name));
 
+	sysfs_attr_init(&ea->attr.attr);
 	ea->attr.attr.name = devm_kstrdup(pdev, name, GFP_KERNEL);
 	if (!ea->attr.attr.name)
 		return -ENOMEM;
-- 
2.21.0

