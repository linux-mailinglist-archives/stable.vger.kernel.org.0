Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145A85BB4D0
	for <lists+stable@lfdr.de>; Sat, 17 Sep 2022 01:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiIPXwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 19:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiIPXwh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 19:52:37 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBE1B99E4;
        Fri, 16 Sep 2022 16:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663372356; x=1694908356;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5QqU6/PjWI46gAIHkqTe2uJoC21ULzDVvGSKXDHWr0U=;
  b=oKLTOCjrdzfoeEGt7LIUgGvkqbD+PmNpj+4fOJWPfAwcVe73IUB8djQl
   pmTZoP4IR6zL146L7WFnc6ucuFHWkPo4VcnwCfm1v44iGJ4dgX07x9kI3
   3TOIWYTMNfAg7+7JcMwShEJUWzuBxXXahX4pUtCZPHmFL4aNE3G9Hy9Qf
   akaRYxuXvXDNjBzX6JaZDNdC7T22eJeYBYl/3db8SbuI/Y33yliYNEQe8
   b7x5IHD0zgKCyw+mkpJomRcow5BVntifeNqfAarDuAWeSgb4w68N19h13
   TWKcCVGhuNgMhGcaiTUlEUFu/0niYjxapr1/YZwNjdwsMZ7+yHmX0F7Lq
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10472"; a="278830517"
X-IronPort-AV: E=Sophos;i="5.93,321,1654585200"; 
   d="scan'208";a="278830517"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2022 16:52:35 -0700
X-IronPort-AV: E=Sophos;i="5.93,321,1654585200"; 
   d="scan'208";a="595426903"
Received: from rhweight-mobl.amr.corp.intel.com (HELO rhweight-mobl.ra.intel.com) ([10.255.230.2])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2022 16:52:35 -0700
From:   Russ Weight <russell.h.weight@intel.com>
To:     mdf@kernel.org, hao.wu@intel.com, yilun.xu@intel.com,
        trix@redhat.com, linux-fpga@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     lgoncalv@redhat.com, marpagan@redhat.com,
        matthew.gerlach@linux.intel.com,
        basheer.ahmed.muddebihal@intel.com, tianfei.zhang@intel.com,
        Russ Weight <russell.h.weight@intel.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable@vger.kernel.org
Subject: [PATCH v1 1/1] fpga: m10bmc-sec: Fix possible memory leak of flash_buf
Date:   Fri, 16 Sep 2022 16:52:05 -0700
Message-Id: <20220916235205.106873-1-russell.h.weight@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There is an error check following the allocation of flash_buf that returns
without freeing flash_buf. It makes more sense to do the error check
before the allocation and the reordering eliminates the memory leak.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 154afa5c31cd ("fpga: m10bmc-sec: expose max10 flash update count")
Signed-off-by: Russ Weight <russell.h.weight@intel.com>
Cc: <stable@vger.kernel.org>
---
 drivers/fpga/intel-m10-bmc-sec-update.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/fpga/intel-m10-bmc-sec-update.c b/drivers/fpga/intel-m10-bmc-sec-update.c
index 526c8cdd1474..79d48852825e 100644
--- a/drivers/fpga/intel-m10-bmc-sec-update.c
+++ b/drivers/fpga/intel-m10-bmc-sec-update.c
@@ -148,10 +148,6 @@ static ssize_t flash_count_show(struct device *dev,
 	stride = regmap_get_reg_stride(sec->m10bmc->regmap);
 	num_bits = FLASH_COUNT_SIZE * 8;
 
-	flash_buf = kmalloc(FLASH_COUNT_SIZE, GFP_KERNEL);
-	if (!flash_buf)
-		return -ENOMEM;
-
 	if (FLASH_COUNT_SIZE % stride) {
 		dev_err(sec->dev,
 			"FLASH_COUNT_SIZE (0x%x) not aligned to stride (0x%x)\n",
@@ -160,6 +156,10 @@ static ssize_t flash_count_show(struct device *dev,
 		return -EINVAL;
 	}
 
+	flash_buf = kmalloc(FLASH_COUNT_SIZE, GFP_KERNEL);
+	if (!flash_buf)
+		return -ENOMEM;
+
 	ret = regmap_bulk_read(sec->m10bmc->regmap, STAGING_FLASH_COUNT,
 			       flash_buf, FLASH_COUNT_SIZE / stride);
 	if (ret) {
-- 
2.25.1

