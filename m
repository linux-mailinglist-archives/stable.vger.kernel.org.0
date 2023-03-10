Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D43B16B4599
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbjCJOfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbjCJOfH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:35:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D55359F
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:35:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30A67B822BB
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939DDC4339C;
        Fri, 10 Mar 2023 14:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458902;
        bh=3V1ay/dICWIQHa/vjldJ3fuJAYyffG02M0Qmty0ulxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0KQDx439ftt/o7MP6sz73SZjYgSwPftFyiLuajiUZHQ1zCX245TM2rbGEoWuJlZ6K
         IgNZ0twukthsfHACs16jL3bhORTOGRs4sOnqSmJpC0WA5U4+3JJF3JL/bISWoPZZyD
         gu69V9SMpRsBw8/bt8OYNGpdnk3/o5CYvDTuKulw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Abaci Robot <abaci@linux.alibaba.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 181/357] thermal: intel: Fix unsigned comparison with less than zero
Date:   Fri, 10 Mar 2023 14:37:50 +0100
Message-Id: <20230310133742.727824845@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
2.39.2



