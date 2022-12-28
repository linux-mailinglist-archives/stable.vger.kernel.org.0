Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302CF657AE0
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbiL1PPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbiL1PPv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:15:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED0D228
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:15:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 079FCB81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781B1C433EF;
        Wed, 28 Dec 2022 15:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240547;
        bh=XLnQrrv0n0qLt+falotwTKdhlXBgb5ff7UCWk2stfrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZdxx9QKWHmGejp4OMviGUtyK/HXAqnI1+jh3lBy2bCxxqxE1mtgB7bqBx2lIQ71P
         /uwpPZBGzkWf1/Qo9ASxIVTc/abZRKTljAicPpMdZ9yvjHBv/wnIoBVFSf8mzVLce4
         g9lr6fqAtNq/U3agIm9y1CLMBEzdIR8cl9hUkXvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Chen Yu <yu.c.chen@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0138/1146] ACPI: pfr_telemetry: use ACPI_FREE() to free acpi_object
Date:   Wed, 28 Dec 2022 15:27:57 +0100
Message-Id: <20221228144333.897495866@linuxfoundation.org>
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

From: Wang ShaoBo <bobo.shaobowang@huawei.com>

[ Upstream commit 0f2aa7fc2a9aee05bafb965d5b1638d3e74b4c61 ]

acpi_evaluate_dsm_typed()/acpi_evaluate_dsm() should be coupled
with ACPI_FREE() to free the ACPI memory, because we need to
track the allocation of acpi_object when ACPI_DBG_TRACK_ALLOCATIONS
enabled, so use ACPI_FREE() instead of kfree().

Fixes: b0013e037a8b ("ACPI: Introduce Platform Firmware Runtime Telemetry driver")
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/pfr_telemetry.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/pfr_telemetry.c b/drivers/acpi/pfr_telemetry.c
index 9abf350bd7a5..27fb6cdad75f 100644
--- a/drivers/acpi/pfr_telemetry.c
+++ b/drivers/acpi/pfr_telemetry.c
@@ -144,7 +144,7 @@ static int get_pfrt_log_data_info(struct pfrt_log_data_info *data_info,
 	ret = 0;
 
 free_acpi_buffer:
-	kfree(out_obj);
+	ACPI_FREE(out_obj);
 
 	return ret;
 }
@@ -180,7 +180,7 @@ static int set_pfrt_log_level(int level, struct pfrt_log_device *pfrt_log_dev)
 		ret = -EBUSY;
 	}
 
-	kfree(out_obj);
+	ACPI_FREE(out_obj);
 
 	return ret;
 }
@@ -218,7 +218,7 @@ static int get_pfrt_log_level(struct pfrt_log_device *pfrt_log_dev)
 	ret = obj->integer.value;
 
 free_acpi_buffer:
-	kfree(out_obj);
+	ACPI_FREE(out_obj);
 
 	return ret;
 }
-- 
2.35.1



