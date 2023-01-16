Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 390B166C47E
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbjAPPzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbjAPPzV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:55:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627B7233D6
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:55:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF0C26102D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D47EC433D2;
        Mon, 16 Jan 2023 15:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884516;
        bh=OZdxbFmQygVHPemq9U8uC29BE4Vfx5z7SbJCBjirapk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=olDF6HrfNLcNGM1f9QHQu623CYCPV+teJU5mSAZFgNSVwKJ+Bpykhfq9hoVHKZxAq
         9ehnHOLETRR6Zsr5Rq51T0duy/xxn5xLLoHJf1TUPbDLILzlDBNP2RxrmaDY9Z30F4
         nx6SlnMyOPNPcgO8mCyGBRYDi8Y+Ho0gga8iFMDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 034/183] drm/amd/pm: correct the reference clock for fan speed(rpm) calculation
Date:   Mon, 16 Jan 2023 16:49:17 +0100
Message-Id: <20230116154804.816490507@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Evan Quan <evan.quan@amd.com>

commit 6fea87637bf36bd285227f490132e83582ab7513 upstream.

Correct the reference clock as 25Mhz for SMU13 fan speed calculation.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x, 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -1258,7 +1258,8 @@ int smu_v13_0_set_fan_speed_rpm(struct s
 				uint32_t speed)
 {
 	struct amdgpu_device *adev = smu->adev;
-	uint32_t tach_period, crystal_clock_freq;
+	uint32_t crystal_clock_freq = 2500;
+	uint32_t tach_period;
 	int ret;
 
 	if (!speed)
@@ -1268,7 +1269,6 @@ int smu_v13_0_set_fan_speed_rpm(struct s
 	if (ret)
 		return ret;
 
-	crystal_clock_freq = amdgpu_asic_get_xclk(adev);
 	tach_period = 60 * crystal_clock_freq * 10000 / (8 * speed);
 	WREG32_SOC15(THM, 0, regCG_TACH_CTRL,
 		     REG_SET_FIELD(RREG32_SOC15(THM, 0, regCG_TACH_CTRL),


