Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8670759217F
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240385AbiHNPhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241159AbiHNPgX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:36:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858CE1A818;
        Sun, 14 Aug 2022 08:31:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A38C860C41;
        Sun, 14 Aug 2022 15:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E47C433C1;
        Sun, 14 Aug 2022 15:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491104;
        bh=Af3jcoVqp4n85cL2Avo/BF8hyovV41qhH0H2eZrbCrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jo22fmruLKSrYxAdiHQ7QuulJxauKkAk1giW8SM38AkZXxTj7L3fidPKxe+mP2hFI
         rts5/ofhnObpvygMyrpgipNrNn8unFIXVCznl2Q3Jkkz63vp65t0c5kQGeOpQ05ZyO
         LByCEmfHxZnfHIe8IPHizQDKlYh3jg2sySPWsbnk03b8U0QRO92x6QbSxXZYYA5vuG
         uF/XUdUoOj+w6GFWIViiiWPDvBU1wf1WjOl/Yb8e4/CmN5R2sqlQBNTJSn/lYyTDLN
         NJ1SWnYBf/eXNLzcw5br7HYcV1bfkqm2TKyFm8RetBy6GanqQ1Xl99Lnk0HtQSbFce
         /9lEdadkw4W6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dafna Hirschfeld <dhirschfeld@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        obitton@habana.ai, rkatta@habana.ai, ttayar@habana.ai,
        bjauhari@habana.ai, oshpigelman@habana.ai, osharabi@habana.ai,
        ynudelman@habana.ai, dliberman@habana.ai, fkassabri@habana.ai
Subject: [PATCH AUTOSEL 5.18 29/56] habanalabs: add terminating NULL to attrs arrays
Date:   Sun, 14 Aug 2022 11:29:59 -0400
Message-Id: <20220814153026.2377377-29-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153026.2377377-1-sashal@kernel.org>
References: <20220814153026.2377377-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dafna Hirschfeld <dhirschfeld@habana.ai>

[ Upstream commit 78d503087be190eab36290644ccec050135e7c70 ]

Arrays of struct attribute are expected to be NULL terminated.
This is required by API methods such as device_add_groups.
This fixes a crash when loading the driver for Goya device.

Signed-off-by: Dafna Hirschfeld <dhirschfeld@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/common/sysfs.c    | 2 ++
 drivers/misc/habanalabs/gaudi/gaudi.c     | 1 +
 drivers/misc/habanalabs/goya/goya_hwmgr.c | 2 ++
 3 files changed, 5 insertions(+)

diff --git a/drivers/misc/habanalabs/common/sysfs.c b/drivers/misc/habanalabs/common/sysfs.c
index 9ebeb18ab85e..da8181068895 100644
--- a/drivers/misc/habanalabs/common/sysfs.c
+++ b/drivers/misc/habanalabs/common/sysfs.c
@@ -73,6 +73,7 @@ static DEVICE_ATTR_RO(clk_cur_freq_mhz);
 static struct attribute *hl_dev_clk_attrs[] = {
 	&dev_attr_clk_max_freq_mhz.attr,
 	&dev_attr_clk_cur_freq_mhz.attr,
+	NULL,
 };
 
 static ssize_t vrm_ver_show(struct device *dev, struct device_attribute *attr, char *buf)
@@ -93,6 +94,7 @@ static DEVICE_ATTR_RO(vrm_ver);
 
 static struct attribute *hl_dev_vrm_attrs[] = {
 	&dev_attr_vrm_ver.attr,
+	NULL,
 };
 
 static ssize_t uboot_ver_show(struct device *dev, struct device_attribute *attr,
diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 21c2b678ff72..1c271edb9297 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -9391,6 +9391,7 @@ static DEVICE_ATTR_RO(infineon_ver);
 
 static struct attribute *gaudi_vrm_dev_attrs[] = {
 	&dev_attr_infineon_ver.attr,
+	NULL,
 };
 
 static void gaudi_add_device_attr(struct hl_device *hdev, struct attribute_group *dev_clk_attr_grp,
diff --git a/drivers/misc/habanalabs/goya/goya_hwmgr.c b/drivers/misc/habanalabs/goya/goya_hwmgr.c
index 6580fc6a486a..b595721751c1 100644
--- a/drivers/misc/habanalabs/goya/goya_hwmgr.c
+++ b/drivers/misc/habanalabs/goya/goya_hwmgr.c
@@ -359,6 +359,7 @@ static struct attribute *goya_clk_dev_attrs[] = {
 	&dev_attr_pm_mng_profile.attr,
 	&dev_attr_tpc_clk.attr,
 	&dev_attr_tpc_clk_curr.attr,
+	NULL,
 };
 
 static ssize_t infineon_ver_show(struct device *dev, struct device_attribute *attr, char *buf)
@@ -375,6 +376,7 @@ static DEVICE_ATTR_RO(infineon_ver);
 
 static struct attribute *goya_vrm_dev_attrs[] = {
 	&dev_attr_infineon_ver.attr,
+	NULL,
 };
 
 void goya_add_device_attr(struct hl_device *hdev, struct attribute_group *dev_clk_attr_grp,
-- 
2.35.1

