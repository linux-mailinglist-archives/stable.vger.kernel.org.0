Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8018D200F8B
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391101AbgFSPT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:19:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392586AbgFSPSX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:18:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A116F206DB;
        Fri, 19 Jun 2020 15:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579903;
        bh=x7XNxG+6Ey9iNd/8UiXWD76fUZIbSvQFJ+JJaQo5fqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kwMwkNTyvb/3kwduxI/Bxk7m9YuSESNKX0OyErRc1GN0uS5z7TErSdY2e+SMzn6uJ
         lctye9bLx5ZLwioA6pffmfb/zgecp2P/u/TD+k1q3NHGq8ghPJUUHhYkCbI2Bz5UCp
         WnFN9VknbldpH060cP4NJn+YGecFOT+rNlt6wUwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, limingyu <limingyu@uniontech.com>,
        zhoubinbin <zhoubinbin@uniontech.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 017/376] drm/amdgpu: Init data to avoid oops while reading pp_num_states.
Date:   Fri, 19 Jun 2020 16:28:55 +0200
Message-Id: <20200619141711.185922893@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: limingyu <limingyu@uniontech.com>

[ Upstream commit 6f81b2d047c59eb77cd04795a44245d6a52cdaec ]

For chip like CHIP_OLAND with si enabled(amdgpu.si_support=1),
the amdgpu will expose pp_num_states to the /sys directory.
In this moment, read the pp_num_states file will excute the
amdgpu_get_pp_num_states func. In our case, the data hasn't
been initialized, so the kernel will access some ilegal
address, trigger the segmentfault and system will reboot soon:

    uos@uos-PC:~$ cat /sys/devices/pci0000\:00/0000\:00\:00.0/0000\:01\:00
    .0/pp_num_states

    Message from syslogd@uos-PC at Apr 22 09:26:20 ...
     kernel:[   82.154129] Internal error: Oops: 96000004 [#1] SMP

This patch aims to fix this problem, avoid that reading file
triggers the kernel sementfault.

Signed-off-by: limingyu <limingyu@uniontech.com>
Signed-off-by: zhoubinbin <zhoubinbin@uniontech.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
index abe94a55ecad..49e2e43f2e4a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
@@ -444,8 +444,11 @@ static ssize_t amdgpu_get_pp_num_states(struct device *dev,
 		ret = smu_get_power_num_states(&adev->smu, &data);
 		if (ret)
 			return ret;
-	} else if (adev->powerplay.pp_funcs->get_pp_num_states)
+	} else if (adev->powerplay.pp_funcs->get_pp_num_states) {
 		amdgpu_dpm_get_pp_num_states(adev, &data);
+	} else {
+		memset(&data, 0, sizeof(data));
+	}
 
 	pm_runtime_mark_last_busy(ddev->dev);
 	pm_runtime_put_autosuspend(ddev->dev);
-- 
2.25.1



