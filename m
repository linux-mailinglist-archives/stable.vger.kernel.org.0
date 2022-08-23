Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A81DC59D8F1
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348786AbiHWJNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349332AbiHWJLa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:11:30 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0835386C37;
        Tue, 23 Aug 2022 01:31:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 09485CE1B34;
        Tue, 23 Aug 2022 08:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D13C433C1;
        Tue, 23 Aug 2022 08:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243472;
        bh=skXDE7HoEs1CM7r5+jZrhjl8BpmwHHmVvjU7vqHj44E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GewB7pae6xuQCN6bM2E6RBHQfMhyuvQjVaRlbFJyaAc9ZOvV9GU8vxkfLsGdgS6QR
         O1/NKMXPda+7o6aa/sCofl5b0U3cyPp5J3L83DoUYxF3WsRD2ti71oTe5ZJSIOtpWt
         N5W2qydmL8P8eiJM00IPSo/bfFWTpXAU05rei7i8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dafna Hirschfeld <dhirschfeld@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 288/365] habanalabs: add terminating NULL to attrs arrays
Date:   Tue, 23 Aug 2022 10:03:09 +0200
Message-Id: <20220823080130.259653833@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index fba322241096..25d735aee6a3 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -9187,6 +9187,7 @@ static DEVICE_ATTR_RO(infineon_ver);
 
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



