Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21EAE66C9D7
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234062AbjAPQ4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234011AbjAPQ40 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:56:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B9215561
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:39:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCD8FB8107D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F89C433EF;
        Mon, 16 Jan 2023 16:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887169;
        bh=wgwf/sDU0yM5J0MRN/m0LmvTSs78patBROJJZPxjQHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tam59g9X3CgxVUFEzRqZPrGf0IG6oDDSrLfXeZ58rC9L0HdF/lB59aBjXz+kJN0wE
         qDohxDfjd8hGPBgUPRqceUdsVMe+t4OrcDVCRJjcyaNjKAbO/H4ab/1IVS27uW71M0
         fsBzixxsLfE/S4+aYS7tEAuUmBY6V13205Dhn5hE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 048/521] perf: Fix possible memleak in pmu_dev_alloc()
Date:   Mon, 16 Jan 2023 16:45:10 +0100
Message-Id: <20230116154849.401486290@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit e8d7a90c08ce963c592fb49845f2ccc606a2ac21 ]

In pmu_dev_alloc(), when dev_set_name() failed, it will goto free_dev
and call put_device(pmu->dev) to release it.
However pmu->dev->release is assigned after this, which makes warning
and memleak.
Call dev_set_name() after pmu->dev->release = pmu_dev_release to fix it.

  Device '(null)' does not have a release() function...
  WARNING: CPU: 2 PID: 441 at drivers/base/core.c:2332 device_release+0x1b9/0x240
  ...
  Call Trace:
    <TASK>
    kobject_put+0x17f/0x460
    put_device+0x20/0x30
    pmu_dev_alloc+0x152/0x400
    perf_pmu_register+0x96b/0xee0
    ...
  kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
  unreferenced object 0xffff888014759000 (size 2048):
    comm "modprobe", pid 441, jiffies 4294931444 (age 38.332s)
    backtrace:
      [<0000000005aed3b4>] kmalloc_trace+0x27/0x110
      [<000000006b38f9b8>] pmu_dev_alloc+0x50/0x400
      [<00000000735f17be>] perf_pmu_register+0x96b/0xee0
      [<00000000e38477f1>] 0xffffffffc0ad8603
      [<000000004e162216>] do_one_initcall+0xd0/0x4e0
      ...

Fixes: abe43400579d ("perf: Sysfs enumeration")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20221111103653.91058-1-chenzhongjin@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index ba66ea3ca705..668e5492e4c4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9682,13 +9682,15 @@ static int pmu_dev_alloc(struct pmu *pmu)
 
 	pmu->dev->groups = pmu->attr_groups;
 	device_initialize(pmu->dev);
-	ret = dev_set_name(pmu->dev, "%s", pmu->name);
-	if (ret)
-		goto free_dev;
 
 	dev_set_drvdata(pmu->dev, pmu);
 	pmu->dev->bus = &pmu_bus;
 	pmu->dev->release = pmu_dev_release;
+
+	ret = dev_set_name(pmu->dev, "%s", pmu->name);
+	if (ret)
+		goto free_dev;
+
 	ret = device_add(pmu->dev);
 	if (ret)
 		goto free_dev;
-- 
2.35.1



