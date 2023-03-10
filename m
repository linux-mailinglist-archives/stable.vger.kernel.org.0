Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E51656B48AE
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbjCJPFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:05:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233898AbjCJPFE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:05:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF7F65441
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:58:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88D3D61A32
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6CBC4339B;
        Fri, 10 Mar 2023 14:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460301;
        bh=epABEj/SZ0cq9aedys3d9Su29rP6FVdRmXEXlofm5Gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDnH0zSDeMvKGFkvWFC1jokc75auBr7b3vbyyKYI82lHg2EG9A+TXR1/WBPhCaWyk
         dWSVoOm0kVkiJOWRSGVsiekJIbg/SiBV1aI+tS0e4c23evVhBNcY/6n+eC2T6ReWH/
         UHt/oQeuiLTaKEPmV/6RAtBWmUixOzKqL5SpjwTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Abaci Robot <abaci@linux.alibaba.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 290/529] thermal: intel: Fix unsigned comparison with less than zero
Date:   Fri, 10 Mar 2023 14:37:13 +0100
Message-Id: <20230310133818.407866089@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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
index 4f1a2f7c016cc..8d6707e48d023 100644
--- a/drivers/thermal/intel/intel_soc_dts_iosf.c
+++ b/drivers/thermal/intel/intel_soc_dts_iosf.c
@@ -404,7 +404,7 @@ struct intel_soc_dts_sensors *intel_soc_dts_iosf_init(
 {
 	struct intel_soc_dts_sensors *sensors;
 	bool notification;
-	u32 tj_max;
+	int tj_max;
 	int ret;
 	int i;
 
-- 
2.39.2



