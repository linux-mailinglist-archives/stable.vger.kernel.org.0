Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC99213348C
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgAGU66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:58:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:59214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727988AbgAGU65 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:58:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E59F214D8;
        Tue,  7 Jan 2020 20:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430737;
        bh=aWycraDdsslyDR3Yr4H3z8S0kZAHv+9ESZLp2ssFPU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DNgBz/jHAo5ChuiKj58Zzr32MtoyvLttOqcyqRPsZfKUzlMlMdBMxINnJcDohqquz
         HgN9VEhRbqF1qobID207CnYwPHd8Z5ikQrxmasTcxZ82sRkF+zbebsXR0fcLeM0ZRo
         AEL2MTt9nuGtE6owGNcagNBvkeAd8+cBcTtZZAV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Wang <kevin1.wang@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 074/191] drm/amdgpu/smu: add metrics table lock for navi (v2)
Date:   Tue,  7 Jan 2020 21:53:14 +0100
Message-Id: <20200107205336.942915805@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit e0e384c398d4638e54b6d2098f0ceaafdab870ee upstream.

To protect access to the metrics table.

v2: unlock on error

Bug: https://gitlab.freedesktop.org/drm/amd/issues/900
Reviewed-by: Kevin Wang <kevin1.wang@amd.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/powerplay/navi10_ppt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/powerplay/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/powerplay/navi10_ppt.c
@@ -547,17 +547,20 @@ static int navi10_get_metrics_table(stru
 	struct smu_table_context *smu_table= &smu->smu_table;
 	int ret = 0;
 
+	mutex_lock(&smu->metrics_lock);
 	if (!smu_table->metrics_time || time_after(jiffies, smu_table->metrics_time + msecs_to_jiffies(100))) {
 		ret = smu_update_table(smu, SMU_TABLE_SMU_METRICS, 0,
 				(void *)smu_table->metrics_table, false);
 		if (ret) {
 			pr_info("Failed to export SMU metrics table!\n");
+			mutex_unlock(&smu->metrics_lock);
 			return ret;
 		}
 		smu_table->metrics_time = jiffies;
 	}
 
 	memcpy(metrics_table, smu_table->metrics_table, sizeof(SmuMetrics_t));
+	mutex_unlock(&smu->metrics_lock);
 
 	return ret;
 }


