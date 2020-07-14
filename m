Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740ED21FCDA
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729845AbgGNSrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:47:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729841AbgGNSry (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:47:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A65D22B2E;
        Tue, 14 Jul 2020 18:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752473;
        bh=fqGRKodDfAmRZ3jBF24oNzEycjzTMB88crVtKJQoM9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZvO/8bpMvpc0JZzUOMSYU2JWpbzP37aF6yl9Jh2ul1uW+s7VvhS796q9cPE7o3HJ7
         A5mUreo/B+PDs6VKUsj0d3OEHXRBHgeyZKEc+c07uQGCwfBq2CLVCBviSHst8ZiM97
         6Q8xdzIU2giiL69mV95E/i4uTZzhf2LsRJi/Ycj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.19 54/58] drm/radeon: fix double free
Date:   Tue, 14 Jul 2020 20:44:27 +0200
Message-Id: <20200714184058.858942716@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184056.149119318@linuxfoundation.org>
References: <20200714184056.149119318@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

commit 41855a898650803e24b284173354cc3e44d07725 upstream.

clang static analysis flags this error

drivers/gpu/drm/radeon/ci_dpm.c:5652:9: warning: Use of memory after it is freed [unix.Malloc]
                kfree(rdev->pm.dpm.ps[i].ps_priv);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/radeon/ci_dpm.c:5654:2: warning: Attempt to free released memory [unix.Malloc]
        kfree(rdev->pm.dpm.ps);
        ^~~~~~~~~~~~~~~~~~~~~~

problem is reported in ci_dpm_fini, with these code blocks.

	for (i = 0; i < rdev->pm.dpm.num_ps; i++) {
		kfree(rdev->pm.dpm.ps[i].ps_priv);
	}
	kfree(rdev->pm.dpm.ps);

The first free happens in ci_parse_power_table where it cleans up locally
on a failure.  ci_dpm_fini also does a cleanup.

	ret = ci_parse_power_table(rdev);
	if (ret) {
		ci_dpm_fini(rdev);
		return ret;
	}

So remove the cleanup in ci_parse_power_table and
move the num_ps calculation to inside the loop so ci_dpm_fini
will know how many array elements to free.

Fixes: cc8dbbb4f62a ("drm/radeon: add dpm support for CI dGPUs (v2)")

Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/ci_dpm.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/ci_dpm.c
+++ b/drivers/gpu/drm/radeon/ci_dpm.c
@@ -5574,6 +5574,7 @@ static int ci_parse_power_table(struct r
 	if (!rdev->pm.dpm.ps)
 		return -ENOMEM;
 	power_state_offset = (u8 *)state_array->states;
+	rdev->pm.dpm.num_ps = 0;
 	for (i = 0; i < state_array->ucNumEntries; i++) {
 		u8 *idx;
 		power_state = (union pplib_power_state *)power_state_offset;
@@ -5583,10 +5584,8 @@ static int ci_parse_power_table(struct r
 		if (!rdev->pm.power_state[i].clock_info)
 			return -EINVAL;
 		ps = kzalloc(sizeof(struct ci_ps), GFP_KERNEL);
-		if (ps == NULL) {
-			kfree(rdev->pm.dpm.ps);
+		if (ps == NULL)
 			return -ENOMEM;
-		}
 		rdev->pm.dpm.ps[i].ps_priv = ps;
 		ci_parse_pplib_non_clock_info(rdev, &rdev->pm.dpm.ps[i],
 					      non_clock_info,
@@ -5608,8 +5607,8 @@ static int ci_parse_power_table(struct r
 			k++;
 		}
 		power_state_offset += 2 + power_state->v2.ucNumDPMLevels;
+		rdev->pm.dpm.num_ps = i + 1;
 	}
-	rdev->pm.dpm.num_ps = state_array->ucNumEntries;
 
 	/* fill in the vce power states */
 	for (i = 0; i < RADEON_MAX_VCE_LEVELS; i++) {


