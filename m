Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3DD8CFFBF
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 19:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbfJHRYI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 13:24:08 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:48915 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725900AbfJHRYH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 13:24:07 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id ADD0921F2E;
        Tue,  8 Oct 2019 13:24:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 13:24:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ga50vS
        kgz7Cx4nwx/9zfkAUZtfnAQfGBfNcwl04Pfz0=; b=EzZMIsD2MXi7736Qv2I/Bn
        6bZzchffP1aKcAtxWKg3yrWp0C+wUrPNtAXKtpU8q4oPNFfPAsJzWEfLdkqt49Hd
        MPbKQiJe+Zsoof1v21ohYG+1myWyjjEIvxHobrzeisRA49Wp7Sg6GY3vHKxUmde+
        RY/KweTFQ4N2ZP6tjnSNn8uDrWB5dt/imWYrwmwlhKHkasnJOxxyPCn+4tnAvNyh
        h9MumhDJ+l+pBLKZ44PakJmqW2ikChiL8FGeVaIEWHJrdW5B9026kt0SCJNLQRBb
        AxeVX+tSpC8tmHuQyKgIoWkWpLw3WtRlqTojGAkNfADwSVfwUifHUGst7nO5Bl8w
        ==
X-ME-Sender: <xms:NsacXcITCwoIZcTxqz6Jm1A3rvLEZTcKBshJtzbBTTQWZ5hPA8s2_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheelgdduudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:NsacXZsBkjKAouKEOGU-xPgDK2WJvW11I_4LP-lhFjgEpCB4qsNQMQ>
    <xmx:NsacXWMCFTK2VigPYlxBH2As6P4OgVqTtsfxl3Gupos2SeqUpr8wnQ>
    <xmx:NsacXSUCKucTfFSpVFW2_75EZlidnXXktbXwkXnifBpwyzIBVE9Ebw>
    <xmx:NsacXeJ2NmH3aFym7afuZ_we2fyJ0RA8jj_liV3fTk6REvMHfAwsYA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D7315D60057;
        Tue,  8 Oct 2019 13:24:05 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amd/powerplay: add sensor lock support for smu" failed to apply to 5.3-stable tree
To:     kevin1.wang@amd.com, alexander.deucher@amd.com,
        kenneth.feng@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 19:24:04 +0200
Message-ID: <1570555444202158@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.3-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 00921306751001b539ebee34171485cd9c749024 Mon Sep 17 00:00:00 2001
From: Kevin Wang <kevin1.wang@amd.com>
Date: Thu, 26 Sep 2019 16:22:13 +0800
Subject: [PATCH] drm/amd/powerplay: add sensor lock support for smu

when multithreading access sysfs of amdgpu_pm_info at the sametime.
the swsmu driver cause smu firmware hang.

eg:
single thread access:
Message A + Param A ==> right
Message B + Param B ==> right
Message C + Param C ==> right
multithreading access:
Message A + Param B ==> error
Message B + Param A ==> error
Message C + Param C ==> right

the patch will add sensor lock(mutex) to avoid this error.

Signed-off-by: Kevin Wang <kevin1.wang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.3.x

diff --git a/drivers/gpu/drm/amd/powerplay/amdgpu_smu.c b/drivers/gpu/drm/amd/powerplay/amdgpu_smu.c
index 33960fb38a5d..4acf139ea014 100644
--- a/drivers/gpu/drm/amd/powerplay/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/powerplay/amdgpu_smu.c
@@ -843,6 +843,8 @@ static int smu_sw_init(void *handle)
 	smu->smu_baco.state = SMU_BACO_STATE_EXIT;
 	smu->smu_baco.platform_support = false;
 
+	mutex_init(&smu->sensor_lock);
+
 	smu->watermarks_bitmap = 0;
 	smu->power_profile_mode = PP_SMC_POWER_PROFILE_BOOTUP_DEFAULT;
 	smu->default_power_profile_mode = PP_SMC_POWER_PROFILE_BOOTUP_DEFAULT;
diff --git a/drivers/gpu/drm/amd/powerplay/arcturus_ppt.c b/drivers/gpu/drm/amd/powerplay/arcturus_ppt.c
index f1f072012fac..d493a3f8c07a 100644
--- a/drivers/gpu/drm/amd/powerplay/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/powerplay/arcturus_ppt.c
@@ -1018,6 +1018,7 @@ static int arcturus_read_sensor(struct smu_context *smu,
 	if (!data || !size)
 		return -EINVAL;
 
+	mutex_lock(&smu->sensor_lock);
 	switch (sensor) {
 	case AMDGPU_PP_SENSOR_MAX_FAN_RPM:
 		*(uint32_t *)data = pptable->FanMaximumRpm;
@@ -1044,6 +1045,7 @@ static int arcturus_read_sensor(struct smu_context *smu,
 	default:
 		ret = smu_smc_read_sensor(smu, sensor, data, size);
 	}
+	mutex_unlock(&smu->sensor_lock);
 
 	return ret;
 }
diff --git a/drivers/gpu/drm/amd/powerplay/inc/amdgpu_smu.h b/drivers/gpu/drm/amd/powerplay/inc/amdgpu_smu.h
index 6109815a0401..23171a4d9a31 100644
--- a/drivers/gpu/drm/amd/powerplay/inc/amdgpu_smu.h
+++ b/drivers/gpu/drm/amd/powerplay/inc/amdgpu_smu.h
@@ -344,6 +344,7 @@ struct smu_context
 	const struct smu_funcs		*funcs;
 	const struct pptable_funcs	*ppt_funcs;
 	struct mutex			mutex;
+	struct mutex			sensor_lock;
 	uint64_t pool_size;
 
 	struct smu_table_context	smu_table;
diff --git a/drivers/gpu/drm/amd/powerplay/navi10_ppt.c b/drivers/gpu/drm/amd/powerplay/navi10_ppt.c
index 2574f7186e16..0b461404af6b 100644
--- a/drivers/gpu/drm/amd/powerplay/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/powerplay/navi10_ppt.c
@@ -1386,6 +1386,7 @@ static int navi10_read_sensor(struct smu_context *smu,
 	if(!data || !size)
 		return -EINVAL;
 
+	mutex_lock(&smu->sensor_lock);
 	switch (sensor) {
 	case AMDGPU_PP_SENSOR_MAX_FAN_RPM:
 		*(uint32_t *)data = pptable->FanMaximumRpm;
@@ -1409,6 +1410,7 @@ static int navi10_read_sensor(struct smu_context *smu,
 	default:
 		ret = smu_smc_read_sensor(smu, sensor, data, size);
 	}
+	mutex_unlock(&smu->sensor_lock);
 
 	return ret;
 }
diff --git a/drivers/gpu/drm/amd/powerplay/vega20_ppt.c b/drivers/gpu/drm/amd/powerplay/vega20_ppt.c
index 64386ee3f878..bbd8ebd58434 100644
--- a/drivers/gpu/drm/amd/powerplay/vega20_ppt.c
+++ b/drivers/gpu/drm/amd/powerplay/vega20_ppt.c
@@ -3023,6 +3023,7 @@ static int vega20_read_sensor(struct smu_context *smu,
 	if(!data || !size)
 		return -EINVAL;
 
+	mutex_lock(&smu->sensor_lock);
 	switch (sensor) {
 	case AMDGPU_PP_SENSOR_MAX_FAN_RPM:
 		*(uint32_t *)data = pptable->FanMaximumRpm;
@@ -3048,6 +3049,7 @@ static int vega20_read_sensor(struct smu_context *smu,
 	default:
 		ret = smu_smc_read_sensor(smu, sensor, data, size);
 	}
+	mutex_unlock(&smu->sensor_lock);
 
 	return ret;
 }

