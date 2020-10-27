Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094E729B474
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1789446AbgJ0PCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:02:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1789410AbgJ0PCJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:02:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D072922283;
        Tue, 27 Oct 2020 15:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810928;
        bh=ZEAxDEAwnclqN4HOqQt+dV8f3ipy5wn8ge1j/LOeM24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OagETKNSeqQsp9njP77HJV67+ZN4mpQaKE5ORgeCVZwBXzN493azBcQdcQPDGYgmL
         HepHjGkjC6HjLTsn6liDBhvlHdEgfB15NDbp1A0z68Y6yir45+9wmX/pyLhO1SYQEf
         x0iswjnOXWz8mLCvP1PsQcbqZYK19/IIBAqOE7mU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tingwei Zhang <tingwei@codeaurora.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 282/633] coresight: cti: Fix bug clearing sysfs links on callback
Date:   Tue, 27 Oct 2020 14:50:25 +0100
Message-Id: <20201027135535.906027700@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Leach <mike.leach@linaro.org>

[ Upstream commit cab280bf3533c72f95ebdb65ce534b5cdc4729dc ]

During module unload, a coresight driver module will call back into
the CTI driver to remove any links between the two devices.

The current code has 2 issues:-
1) in the CTI driver the matching code is matching to the wrong device
so misses all the links.
2) The callback is called too late in the unload process resulting in a
crash.

This fixes both the issues.

Fixes: 177af8285b59 ("coresight: cti: Enable CTI associated with devices")
Reported-by: Tingwei Zhang <tingwei@codeaurora.org>
Acked-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Tingwei Zhang <tingwei@codeaurora.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200928163513.70169-19-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-cti.c | 2 +-
 drivers/hwtracing/coresight/coresight.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-cti.c b/drivers/hwtracing/coresight/coresight-cti.c
index 92aa535f9e134..167fbc2e7033f 100644
--- a/drivers/hwtracing/coresight/coresight-cti.c
+++ b/drivers/hwtracing/coresight/coresight-cti.c
@@ -592,7 +592,7 @@ void cti_remove_assoc_from_csdev(struct coresight_device *csdev)
 		ctidrv = csdev_to_cti_drvdata(csdev->ect_dev);
 		ctidev = &ctidrv->ctidev;
 		list_for_each_entry(tc, &ctidev->trig_cons, node) {
-			if (tc->con_dev == csdev->ect_dev) {
+			if (tc->con_dev == csdev) {
 				cti_remove_sysfs_link(ctidrv, tc);
 				tc->con_dev = NULL;
 				break;
diff --git a/drivers/hwtracing/coresight/coresight.c b/drivers/hwtracing/coresight/coresight.c
index f3efbb3b2b4d1..cf03af09c6ced 100644
--- a/drivers/hwtracing/coresight/coresight.c
+++ b/drivers/hwtracing/coresight/coresight.c
@@ -1023,7 +1023,6 @@ static void coresight_device_release(struct device *dev)
 {
 	struct coresight_device *csdev = to_coresight_device(dev);
 
-	cti_remove_assoc_from_csdev(csdev);
 	fwnode_handle_put(csdev->dev.fwnode);
 	kfree(csdev->refcnt);
 	kfree(csdev);
@@ -1357,6 +1356,7 @@ void coresight_unregister(struct coresight_device *csdev)
 {
 	etm_perf_del_symlink_sink(csdev);
 	/* Remove references of that device in the topology */
+	cti_remove_assoc_from_csdev(csdev);
 	coresight_remove_conns(csdev);
 	coresight_release_platform_data(csdev, csdev->pdata);
 	device_unregister(&csdev->dev);
-- 
2.25.1



