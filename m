Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAF0657A52
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233697AbiL1PKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233739AbiL1PJy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:09:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E31113E81
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:09:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB455B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:09:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5426BC433D2;
        Wed, 28 Dec 2022 15:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240189;
        bh=IqJZ+mc+y1zrA9Wz06cUVtD47RJVvdK8LZZdWL57Zj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d21jlaoSOs712G7u23uP7RC0alaRBALZHrgaXgg3i1NbOVRAoMl5ONpXVVu17MZPm
         LLK991YT6ycELiOjrAD/9Gubq0QsxGUtRtQcsIFPLSq6ij/kzJoI+HCBkMKGBfo/Uh
         epcVAhKmEFbqNTtVXjedd6IURu1+NcflMr0B7fgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Chen Yu <yu.c.chen@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0128/1073] ACPI: pfr_update: use ACPI_FREE() to free acpi_object
Date:   Wed, 28 Dec 2022 15:28:36 +0100
Message-Id: <20221228144331.512758976@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit e335beed78ec82656dcb554f9fe560709f0dc408 ]

acpi_evaluate_dsm_typed()/acpi_evaluate_dsm() should be coupled with
ACPI_FREE() to free the ACPI memory, because we need to track the
allocation of acpi_object when ACPI_DBG_TRACK_ALLOCATIONS enabled,
so use ACPI_FREE() instead of kfree().

Fixes: 0db89fa243e5 ("ACPI: Introduce Platform Firmware Runtime Update device driver")
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/pfr_update.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/pfr_update.c b/drivers/acpi/pfr_update.c
index 6bb0b778b5da..9d2bdc13253a 100644
--- a/drivers/acpi/pfr_update.c
+++ b/drivers/acpi/pfr_update.c
@@ -178,7 +178,7 @@ static int query_capability(struct pfru_update_cap_info *cap_hdr,
 	ret = 0;
 
 free_acpi_buffer:
-	kfree(out_obj);
+	ACPI_FREE(out_obj);
 
 	return ret;
 }
@@ -224,7 +224,7 @@ static int query_buffer(struct pfru_com_buf_info *info,
 	ret = 0;
 
 free_acpi_buffer:
-	kfree(out_obj);
+	ACPI_FREE(out_obj);
 
 	return ret;
 }
@@ -385,7 +385,7 @@ static int start_update(int action, struct pfru_device *pfru_dev)
 	ret = 0;
 
 free_acpi_buffer:
-	kfree(out_obj);
+	ACPI_FREE(out_obj);
 
 	return ret;
 }
-- 
2.35.1



