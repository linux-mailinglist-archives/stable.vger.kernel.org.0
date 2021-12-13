Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A504729C1
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242963AbhLMKYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343493AbhLMKWb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:22:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C19C09B079;
        Mon, 13 Dec 2021 01:59:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD706B80E7E;
        Mon, 13 Dec 2021 09:59:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D58C34605;
        Mon, 13 Dec 2021 09:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389547;
        bh=8kFx/03PwMXw2IXS6IthD3YZPFSQH6x1/xMw8p86IO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1uLBARWJ1CfuEhm201spgqtrTzWtIRT4h/mmnSt5bu+vFjdez9S1zhg00XDgPXdtc
         sr0oGWeC9jdHbgk2VJ3XdYbSXu5Gbk+hjZmGXlpcMVxEeDWygiiRPGUSNxUpQC35GP
         4FvXCxmWv/iOmJsFuHHx7bySVMxVMsTElk/mwfJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jude Shih <Jude.Shih@amd.com>,
        Pavle Kotarac <Pavle.Kotarac@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 125/171] drm/amd/display: Fix DPIA outbox timeout after S3/S4/reset
Date:   Mon, 13 Dec 2021 10:30:40 +0100
Message-Id: <20211213092949.259883823@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit af6902ec415655236adea91826bd96ed0ab16f42 upstream.

[Why]
The HW interrupt gets disabled after S3/S4/reset so we don't receive
notifications for HPD or AUX from DMUB - leading to timeout and
black screen with (or without) DPIA links connected.

[How]
Re-enable the interrupt after S3/S4/reset like we do for the other
DC interrupts.

Guard both instances of the outbox interrupt enable or we'll hang
during restore on ASIC that don't support it.

Fixes: 6eff272dbee7ad ("drm/amd/display: Fix DPIA outbox timeout after GPU reset")

Reviewed-by: Jude Shih <Jude.Shih@amd.com>
Acked-by: Pavle Kotarac <Pavle.Kotarac@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2213,7 +2213,8 @@ static int dm_resume(void *handle)
 	if (amdgpu_in_reset(adev)) {
 		dc_state = dm->cached_dc_state;
 
-		amdgpu_dm_outbox_init(adev);
+		if (dc_enable_dmub_notifications(adev->dm.dc))
+			amdgpu_dm_outbox_init(adev);
 
 		r = dm_dmub_hw_init(adev);
 		if (r)
@@ -2262,6 +2263,10 @@ static int dm_resume(void *handle)
 	/* TODO: Remove dc_state->dccg, use dc->dccg directly. */
 	dc_resource_state_construct(dm->dc, dm_state->context);
 
+	/* Re-enable outbox interrupts for DPIA. */
+	if (dc_enable_dmub_notifications(adev->dm.dc))
+		amdgpu_dm_outbox_init(adev);
+
 	/* Before powering on DC we need to re-initialize DMUB. */
 	r = dm_dmub_hw_init(adev);
 	if (r)


