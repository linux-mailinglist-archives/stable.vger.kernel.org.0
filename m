Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 345AD4AA97B
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 15:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380167AbiBEOk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 09:40:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbiBEOk7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 09:40:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2118BC061346
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 06:40:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 897F7B801B8
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 14:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9FEC340E9;
        Sat,  5 Feb 2022 14:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644072055;
        bh=o4y6qAuG/cLvI43yAxdZxu8OH0+IqcvS+PbumboyG6I=;
        h=Subject:To:Cc:From:Date:From;
        b=uhRD4bwUObtPVxJFJXkXTI1TFaO6sLFjtZ2y8IJvuo0oR7s3+A9yEjAiGPzvD46qW
         h5n7xiKHU6AuuaEleuPxlGsMt1DTgFg2285KiaFdEmAWyrfp40W9spAMVJuOkJBOeX
         br4AcOxEA9giilD0LoT9t7NVM2IjVzaZd/ig2yMU=
Subject: FAILED: patch "[PATCH] drm/amd/pm: correct the MGpuFanBoost support for Beige Goby" failed to apply to 5.10-stable tree
To:     evan.quan@amd.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Feb 2022 15:40:52 +0100
Message-ID: <1644072052229173@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3ec5586b4699cfb75cdfa09425e11d121db40773 Mon Sep 17 00:00:00 2001
From: Evan Quan <evan.quan@amd.com>
Date: Mon, 24 Jan 2022 13:40:35 +0800
Subject: [PATCH] drm/amd/pm: correct the MGpuFanBoost support for Beige Goby

The existing way cannot handle Beige Goby well as a different
PPTable data structure(PPTable_beige_goby_t instead of PPTable_t)
is used there.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index 777f717c37ae..a4207293158c 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -3696,14 +3696,14 @@ static ssize_t sienna_cichlid_get_gpu_metrics(struct smu_context *smu,
 
 static int sienna_cichlid_enable_mgpu_fan_boost(struct smu_context *smu)
 {
-	struct smu_table_context *table_context = &smu->smu_table;
-	PPTable_t *smc_pptable = table_context->driver_pptable;
+	uint16_t *mgpu_fan_boost_limit_rpm;
 
+	GET_PPTABLE_MEMBER(MGpuFanBoostLimitRpm, &mgpu_fan_boost_limit_rpm);
 	/*
 	 * Skip the MGpuFanBoost setting for those ASICs
 	 * which do not support it
 	 */
-	if (!smc_pptable->MGpuFanBoostLimitRpm)
+	if (*mgpu_fan_boost_limit_rpm == 0)
 		return 0;
 
 	return smu_cmn_send_smc_msg_with_param(smu,

