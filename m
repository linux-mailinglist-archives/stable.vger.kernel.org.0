Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C23F6A3203
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 16:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjBZPPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 10:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbjBZPOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 10:14:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D1F211FB;
        Sun, 26 Feb 2023 07:04:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B880360C40;
        Sun, 26 Feb 2023 14:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6D9C4339B;
        Sun, 26 Feb 2023 14:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677423092;
        bh=UrYKVhSSOQFbVkK0Z4AvnA6vhoJisr2++OgHjuEfVfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I+pU+59COhwBFibCeuZj6fyqh64fqh2tQizSGfPe6AW6hvo5P0l9RGrTxfwTw6BiJ
         VQbuWL/C7+WKfxSbkVwN+udUXZlCp0k8Yu4Fx69EyC0fFs9DS+37kppCoChW2jfkr+
         R1Zr2GsXJnCrP+CS5HpnQsWA1zy1aaMelYbToMB999Oxnxyym5WV2qVYWwT6sni/yG
         pDm8nc8OKWxcssT63GPP5lkvaEPvHhyQAlpr4FwxtOQaReuetIv0cKyDHx+Vrr35TO
         LcHEY8FbDlWTvvkGsZERLqvSAK5Luw3mTzS+s6l7zwIkYJI4LKkhTjwEPzWvMXLPN2
         CpZVaK2bD8Spg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        daniel.lezcano@linaro.org, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 03/19] thermal: intel: Fix unsigned comparison with less than zero
Date:   Sun, 26 Feb 2023 09:51:05 -0500
Message-Id: <20230226145123.829229-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226145123.829229-1-sashal@kernel.org>
References: <20230226145123.829229-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit e7fcfe67f9f410736b758969477b17ea285e8e6c ]

The return value from the call to intel_tcc_get_tjmax() is int, which can
be a negative error code. However, the return value is being assigned to
an u32 variable 'tj_max', so making 'tj_max' an int.

Eliminate the following warning:
./drivers/thermal/intel/intel_soc_dts_iosf.c:394:5-11: WARNING: Unsigned expression compared with zero: tj_max < 0

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3637
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/intel_soc_dts_iosf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/intel/intel_soc_dts_iosf.c b/drivers/thermal/intel/intel_soc_dts_iosf.c
index 5716b62e0f732..410f13f6cba48 100644
--- a/drivers/thermal/intel/intel_soc_dts_iosf.c
+++ b/drivers/thermal/intel/intel_soc_dts_iosf.c
@@ -396,7 +396,7 @@ struct intel_soc_dts_sensors *intel_soc_dts_iosf_init(
 {
 	struct intel_soc_dts_sensors *sensors;
 	bool notification;
-	u32 tj_max;
+	int tj_max;
 	int ret;
 	int i;
 
-- 
2.39.0

