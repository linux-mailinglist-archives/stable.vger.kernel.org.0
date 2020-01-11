Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 964C7137DE5
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgAKKCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:02:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:33166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728819AbgAKKCj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:02:39 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D98852077C;
        Sat, 11 Jan 2020 10:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736959;
        bh=iu9/s3BMOP1/KtOrOmZzB/tj8XuAQWeyw5t7+Au6Zhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zo4kskDOLFLqnyGhaQHr0zgbUZ+gHoTThQHmbCqI1B46WARetFEYXBJITVnck29Vx
         I2v68g+STfQXQ5ghe0qKKdc+hCNywOvMjHqcc1EEG1gHMyFIJKEEEB/AisrjMbS6ev
         Uf5iJ/CAPLNiYK5u2I13Hcy12yCo5zINXDu48LgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 47/91] coresight: tmc-etf: Do not call smp_processor_id from preemptible
Date:   Sat, 11 Jan 2020 10:49:40 +0100
Message-Id: <20200111094902.887009248@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094844.748507863@linuxfoundation.org>
References: <20200111094844.748507863@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 024c1fd9dbcc1d8a847f1311f999d35783921b7f ]

During a perf session we try to allocate buffers on the "node" associated
with the CPU the event is bound to. If it is not bound to a CPU, we
use the current CPU node, using smp_processor_id(). However this is unsafe
in a pre-emptible context and could generate the splats as below :

 BUG: using smp_processor_id() in preemptible [00000000] code: perf/2544
 caller is tmc_alloc_etf_buffer+0x5c/0x60
 CPU: 2 PID: 2544 Comm: perf Not tainted 5.1.0-rc6-147786-g116841e #344
 Hardware name: ARM LTD ARM Juno Development Platform/ARM Juno Development Platform, BIOS EDK II Feb  1 2019
 Call trace:
  dump_backtrace+0x0/0x150
  show_stack+0x14/0x20
  dump_stack+0x9c/0xc4
  debug_smp_processor_id+0x10c/0x110
  tmc_alloc_etf_buffer+0x5c/0x60
  etm_setup_aux+0x1c4/0x230
  rb_alloc_aux+0x1b8/0x2b8
  perf_mmap+0x35c/0x478
  mmap_region+0x34c/0x4f0
  do_mmap+0x2d8/0x418
  vm_mmap_pgoff+0xd0/0xf8
  ksys_mmap_pgoff+0x88/0xf8
  __arm64_sys_mmap+0x28/0x38
  el0_svc_handler+0xd8/0x138
  el0_svc+0x8/0xc

Use NUMA_NO_NODE hint instead of using the current node for events
not bound to CPUs.

Fixes: 2e499bbc1a929ac ("coresight: tmc: implementing TMC-ETF AUX space API")
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: stable <stable@vger.kernel.org> # 4.7+
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20190620221237.3536-4-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-tmc-etf.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-tmc-etf.c b/drivers/hwtracing/coresight/coresight-tmc-etf.c
index 14df4e34c21c..faf68412eb92 100644
--- a/drivers/hwtracing/coresight/coresight-tmc-etf.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etf.c
@@ -292,9 +292,7 @@ static void *tmc_alloc_etf_buffer(struct coresight_device *csdev, int cpu,
 	int node;
 	struct cs_buffers *buf;
 
-	if (cpu == -1)
-		cpu = smp_processor_id();
-	node = cpu_to_node(cpu);
+	node = (event->cpu == -1) ? NUMA_NO_NODE : cpu_to_node(event->cpu);
 
 	/* Allocate memory structure for interaction with Perf */
 	buf = kzalloc_node(sizeof(struct cs_buffers), GFP_KERNEL, node);
-- 
2.20.1



