Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8756B469EB5
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380004AbhLFPnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:43:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389372AbhLFPhm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:37:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F358C08EAE6;
        Mon,  6 Dec 2021 07:23:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD3E4B81125;
        Mon,  6 Dec 2021 15:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204E2C33AE4;
        Mon,  6 Dec 2021 15:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804214;
        bh=ViCM4pw7ivH3Q4x7TTU2A5lvG5xOLkS0I4EGkHXvdtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dZLsiVjLlhrQEa83mYKbHAU/d6VNk8olcTwpXahgVIcSBFyGGMoulxhs9pkDgA+B8
         lBdYWnIjeWYhtc/yUWJFIaQd5qJl/Shcg3/zVTTB64G136B/C7iROKTTyC39bZ8Nvt
         M59ufBSxNa5CiJ/a6FtluC3N0oXY4r/Y1h+JjG7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, shaoyunl <shaoyun.liu@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/207] drm/amd/amdkfd: Fix kernel panic when reset failed and been triggered again
Date:   Mon,  6 Dec 2021 15:54:49 +0100
Message-Id: <20211206145611.441344495@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: shaoyunl <shaoyun.liu@amd.com>

[ Upstream commit 2cf49e00d40d5132e3d067b5aa6d84791929ab15 ]

In SRIOV configuration, the reset may failed to bring asic back to normal but stop cpsch
already been called, the start_cpsch will not be called since there is no resume in this
case.  When reset been triggered again, driver should avoid to do uninitialization again.

Signed-off-by: shaoyunl <shaoyun.liu@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index f8fce9d05f50c..4f2e0cc8a51a8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1225,6 +1225,11 @@ static int stop_cpsch(struct device_queue_manager *dqm)
 	bool hanging;
 
 	dqm_lock(dqm);
+	if (!dqm->sched_running) {
+		dqm_unlock(dqm);
+		return 0;
+	}
+
 	if (!dqm->is_hws_hang)
 		unmap_queues_cpsch(dqm, KFD_UNMAP_QUEUES_FILTER_ALL_QUEUES, 0);
 	hanging = dqm->is_hws_hang || dqm->is_resetting;
-- 
2.33.0



