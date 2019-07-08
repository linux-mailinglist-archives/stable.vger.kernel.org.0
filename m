Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B55D16234B
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390457AbfGHPeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:34:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390471AbfGHPeC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:34:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31B9A20651;
        Mon,  8 Jul 2019 15:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562600041;
        bh=+7FiTRrLiAJdrxgP+15TtcJzC8osl96ZZyLt6gKPPFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F3RmA1JNbjjYPA72IWaOYoPTLVrjoFl+MxQbjwm5PfD9IWKi3CLZ4StpMZPWG4ZRY
         3B9ZXzNitV6Gwjnix5d4J8gM1T1BQ4YHuWH06LkzK6VofMI8SwK1qh8dBwW8+Roomr
         cOrNovw+JrWgwU6jEz5me8wWO263Ny4hRMbzJDVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Huang Rui <ray.huang@amd.com>, Rex Zhu <Rex.Zhu@amd.com>,
        Likun Gao <Likun.Gao@amd.com>, Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.1 74/96] drm/amdgpu: Dont skip display settings in hwmgr_resume()
Date:   Mon,  8 Jul 2019 17:13:46 +0200
Message-Id: <20190708150530.449312447@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

commit 688f3d1ebedffa310b6591bd1b63fa0770d945fe upstream.

I'm not entirely sure why this is, but for some reason:

921935dc6404 ("drm/amd/powerplay: enforce display related settings only on needed")

Breaks runtime PM resume on the Radeon PRO WX 3100 (Lexa) in one the
pre-production laptops I have. The issue manifests as the following
messages in dmesg:

[drm] UVD and UVD ENC initialized successfully.
amdgpu 0000:3b:00.0: [drm:amdgpu_ring_test_helper [amdgpu]] *ERROR* ring vce1 test failed (-110)
[drm:amdgpu_device_ip_resume_phase2 [amdgpu]] *ERROR* resume of IP block <vce_v3_0> failed -110
[drm:amdgpu_device_resume [amdgpu]] *ERROR* amdgpu_device_ip_resume failed (-110).

And happens after about 6-10 runtime PM suspend/resume cycles (sometimes
sooner, if you're lucky!). Unfortunately I can't seem to pin down
precisely which part in psm_adjust_power_state_dynamic that is causing
the issue, but not skipping the display setting setup seems to fix it.
Hopefully if there is a better fix for this, this patch will spark
discussion around it.

Fixes: 921935dc6404 ("drm/amd/powerplay: enforce display related settings only on needed")
Cc: Evan Quan <evan.quan@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: Rex Zhu <Rex.Zhu@amd.com>
Cc: Likun Gao <Likun.Gao@amd.com>
Cc: <stable@vger.kernel.org> # v5.1+
Signed-off-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/powerplay/hwmgr/hwmgr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/powerplay/hwmgr/hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/hwmgr.c
@@ -325,7 +325,7 @@ int hwmgr_resume(struct pp_hwmgr *hwmgr)
 	if (ret)
 		return ret;
 
-	ret = psm_adjust_power_state_dynamic(hwmgr, true, NULL);
+	ret = psm_adjust_power_state_dynamic(hwmgr, false, NULL);
 
 	return ret;
 }


