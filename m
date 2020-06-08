Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448F71F2B57
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732535AbgFIAOo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:14:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730739AbgFHXTG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:19:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 656472083E;
        Mon,  8 Jun 2020 23:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658346;
        bh=qnsVTrLCxPqpngpuR5EA72ryLCgJ1hxZMzU5jpMT6iI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3xdTaWK1IvSVN6zB0j0v5nUhwi24VQegobA5K/629zXBtC1FupETwL91KTq69Cvu
         I59bbFWQDCQrDSe3i4huARz2VeHHl3Vg04zXr9uoj/h011sgTYLqenePT9NYVIWvuV
         4suuMiRr0wIkowKRbiHMSpvlci4aLbFUizt/PqcU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     limingyu <limingyu@uniontech.com>,
        zhoubinbin <zhoubinbin@uniontech.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 014/175] drm/amdgpu: Init data to avoid oops while reading pp_num_states.
Date:   Mon,  8 Jun 2020 19:16:07 -0400
Message-Id: <20200608231848.3366970-14-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 51263b8d94b1..c8008b956363 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_pm.c
@@ -416,8 +416,11 @@ static ssize_t amdgpu_get_pp_num_states(struct device *dev,
 		ret = smu_get_power_num_states(&adev->smu, &data);
 		if (ret)
 			return ret;
-	} else if (adev->powerplay.pp_funcs->get_pp_num_states)
+	} else if (adev->powerplay.pp_funcs->get_pp_num_states) {
 		amdgpu_dpm_get_pp_num_states(adev, &data);
+	} else {
+		memset(&data, 0, sizeof(data));
+	}
 
 	buf_len = snprintf(buf, PAGE_SIZE, "states: %d\n", data.nums);
 	for (i = 0; i < data.nums; i++)
-- 
2.25.1

