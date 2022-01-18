Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6A0491DE5
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348759AbiARDnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351793AbiARCzL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:55:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E77EC02B85D;
        Mon, 17 Jan 2022 18:44:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD53F60C96;
        Tue, 18 Jan 2022 02:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E07CC36AE3;
        Tue, 18 Jan 2022 02:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473840;
        bh=Csfys2uwM396iME7raG1/d7q99Qkj/wQ1zHtdVop2hQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QeRI8wpRcZ9uvu3Wn3EVNiy30l7dl8sVJLjxDFlOfu150dnr5sar5EUKfZyJ3VXPa
         eMCNNOQtHJgE7NDurPDETfYHx45fQjcIltYNh0mA7dh41HIFoVAb0RKzSyIa2j0fms
         sPuggJ/EeTmQPCbehIIN8hMeAO7T5RF/Ubztgmc9buMLyQj3+V+FAU4S4my88Snxei
         8hU5G0hQlA16zJS1S+ckVIxSRvRs+bFnuizQTF1TVsp/fJu0w5htuMvKCecRwRmgrk
         gV18F/aLqqEsmekVp2sosOnJ3fQGFXck8hm+lTiZb9WNpJYXfbfaOWkgSTAo01wRZq
         3rn38p+/QaYhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marina Nikolic <Marina.Nikolic@amd.com>,
        Evan Quan <evan.quan@amd.com>, Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 097/116] amdgpu/pm: Make sysfs pm attributes as read-only for VFs
Date:   Mon, 17 Jan 2022 21:39:48 -0500
Message-Id: <20220118024007.1950576-97-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marina Nikolic <Marina.Nikolic@amd.com>

[ Upstream commit 11c9cc95f818f0f187e9b579a7f136f532b42445 ]

== Description ==
Setting values of pm attributes through sysfs
should not be allowed in SRIOV mode.
These calls will not be processed by FW anyway,
but error handling on sysfs level should be improved.

== Changes ==
This patch prohibits performing of all set commands
in SRIOV mode on sysfs level.
It offers better error handling as calls that are
not allowed will not be propagated further.

== Test ==
Writing to any sysfs file in passthrough mode will succeed.
Writing to any sysfs file in ONEVF mode will yield error:
"calling process does not have sufficient permission to execute a command".

Signed-off-by: Marina Nikolic <Marina.Nikolic@amd.com>
Acked-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_pm.c b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
index 9f383b9041d28..49109614510b8 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -2098,6 +2098,12 @@ static int default_attr_update(struct amdgpu_device *adev, struct amdgpu_device_
 		}
 	}
 
+	/* setting should not be allowed from VF */
+	if (amdgpu_sriov_vf(adev)) {
+		dev_attr->attr.mode &= ~S_IWUGO;
+		dev_attr->store = NULL;
+	}
+
 #undef DEVICE_ATTR_IS
 
 	return 0;
-- 
2.34.1

