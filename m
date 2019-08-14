Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 800A08D8FB
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbfHNREU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:04:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729185AbfHNRET (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:04:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26617214DA;
        Wed, 14 Aug 2019 17:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802258;
        bh=c5ECV7W2sMFmoAZauGAu8MuqRcIeMfiqCEJhGLY03KA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IKa2wE9n+s27xjlfBzSN4CfN99Il53E4Fa+WvzvcUkf1m+JKJU464bGRiC2s6Tmmx
         JqBN9g/KDIZ5Tb5zbUEbQpSao6o/PjJPVaE9lXU69/5cEFlP3eimIIUDzUV5w3715I
         oErkBt8TVAYd+R1QuJx2Gj3ZNo5hvnVKIby427RY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 5.2 030/144] coresight: Fix DEBUG_LOCKS_WARN_ON for uninitialized attribute
Date:   Wed, 14 Aug 2019 18:59:46 +0200
Message-Id: <20190814165801.098115389@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

commit 5511c0c309db4c526a6e9f8b2b8a1483771574bc upstream.

While running the linux-next with CONFIG_DEBUG_LOCKS_ALLOC enabled,
I get the following splat.

 BUG: key ffffcb5636929298 has not been registered!
 ------------[ cut here ]------------
 DEBUG_LOCKS_WARN_ON(1)
 WARNING: CPU: 1 PID: 53 at kernel/locking/lockdep.c:3669 lockdep_init_map+0x164/0x1f0
 CPU: 1 PID: 53 Comm: kworker/1:1 Tainted: G        W         5.2.0-next-20190712-00015-g00ad4634222e-dirty #603
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

Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Fixes: bb8e370bdc14 ("coresight: perf: Add "sinks" group to PMU directory")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
[Fixed a typograhic error in the changelog]
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20190801172323.18359-2-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/hwtracing/coresight/coresight-etm-perf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwtracing/coresight/coresight-etm-perf.c
+++ b/drivers/hwtracing/coresight/coresight-etm-perf.c
@@ -544,6 +544,7 @@ int etm_perf_add_symlink_sink(struct cor
 	/* See function coresight_get_sink_by_id() to know where this is used */
 	hash = hashlen_hash(hashlen_string(NULL, name));
 
+	sysfs_attr_init(&ea->attr.attr);
 	ea->attr.attr.name = devm_kstrdup(pdev, name, GFP_KERNEL);
 	if (!ea->attr.attr.name)
 		return -ENOMEM;


