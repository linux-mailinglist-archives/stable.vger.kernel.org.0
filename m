Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B9B541CA6
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382433AbiFGWC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382481AbiFGWCi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:02:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB20024F7AE;
        Tue,  7 Jun 2022 12:14:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38C746187F;
        Tue,  7 Jun 2022 19:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F31C385A5;
        Tue,  7 Jun 2022 19:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629274;
        bh=1rY7bqasLjyT2TBe+kiOEacP0hDZYUDWD+Gxh39GZZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZpjzhzSan+KfMMSJnQ9tPmM1b+0Uzb7WAwOfNH68JFo6wktWHyFO0RB7068itistp
         zk8SfaPyiAsG4iz2UhvDjX0I3gwJR5Rk86AwfxEURRuSrqMAk2WrkfBBu36qF90Qvn
         cTYlOZcNgNMBrJRpXa5gOmKftb06jvFbYFUP0fvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 591/879] nvdimm: Fix firmware activation deadlock scenarios
Date:   Tue,  7 Jun 2022 19:01:49 +0200
Message-Id: <20220607165020.007358082@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit e6829d1bd3c4b58296ee9e412f7ed4d6cb390192 ]

Lockdep reports the following deadlock scenarios for CXL root device
power-management, device_prepare(), operations, and device_shutdown()
operations for 'nd_region' devices:

 Chain exists of:
   &nvdimm_region_key --> &nvdimm_bus->reconfig_mutex --> system_transition_mutex

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(system_transition_mutex);
                                lock(&nvdimm_bus->reconfig_mutex);
                                lock(system_transition_mutex);
   lock(&nvdimm_region_key);

 Chain exists of:
   &cxl_nvdimm_bridge_key --> acpi_scan_lock --> &cxl_root_key

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&cxl_root_key);
                                lock(acpi_scan_lock);
                                lock(&cxl_root_key);
   lock(&cxl_nvdimm_bridge_key);

These stem from holding nvdimm_bus_lock() over hibernate_quiet_exec()
which walks the entire system device topology taking device_lock() along
the way. The nvdimm_bus_lock() is protecting against unregistration,
multiple simultaneous ops callers, and preventing activate_show() from
racing activate_store(). For the first 2, the lock is redundant.
Unregistration already flushes all ops users, and sysfs already prevents
multiple threads to be active in an ops handler at the same time. For
the last userspace should already be waiting for its last
activate_store() to complete, and does not need activate_show() to flush
the write side, so this lock usage can be deleted in these attributes.

Fixes: 48001ea50d17 ("PM, libnvdimm: Add runtime firmware activation support")
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Link: https://lore.kernel.org/r/165074883800.4116052.10737040861825806582.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/core.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 69a03358817f..681cc28703a3 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -368,9 +368,7 @@ static ssize_t capability_show(struct device *dev,
 	if (!nd_desc->fw_ops)
 		return -EOPNOTSUPP;
 
-	nvdimm_bus_lock(dev);
 	cap = nd_desc->fw_ops->capability(nd_desc);
-	nvdimm_bus_unlock(dev);
 
 	switch (cap) {
 	case NVDIMM_FWA_CAP_QUIESCE:
@@ -395,10 +393,8 @@ static ssize_t activate_show(struct device *dev,
 	if (!nd_desc->fw_ops)
 		return -EOPNOTSUPP;
 
-	nvdimm_bus_lock(dev);
 	cap = nd_desc->fw_ops->capability(nd_desc);
 	state = nd_desc->fw_ops->activate_state(nd_desc);
-	nvdimm_bus_unlock(dev);
 
 	if (cap < NVDIMM_FWA_CAP_QUIESCE)
 		return -EOPNOTSUPP;
@@ -443,7 +439,6 @@ static ssize_t activate_store(struct device *dev,
 	else
 		return -EINVAL;
 
-	nvdimm_bus_lock(dev);
 	state = nd_desc->fw_ops->activate_state(nd_desc);
 
 	switch (state) {
@@ -461,7 +456,6 @@ static ssize_t activate_store(struct device *dev,
 	default:
 		rc = -ENXIO;
 	}
-	nvdimm_bus_unlock(dev);
 
 	if (rc == 0)
 		rc = len;
@@ -484,10 +478,7 @@ static umode_t nvdimm_bus_firmware_visible(struct kobject *kobj, struct attribut
 	if (!nd_desc->fw_ops)
 		return 0;
 
-	nvdimm_bus_lock(dev);
 	cap = nd_desc->fw_ops->capability(nd_desc);
-	nvdimm_bus_unlock(dev);
-
 	if (cap < NVDIMM_FWA_CAP_QUIESCE)
 		return 0;
 
-- 
2.35.1



