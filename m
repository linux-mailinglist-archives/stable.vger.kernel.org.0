Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2011921FC1D
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729326AbgGNSwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730519AbgGNSwc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:52:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25A1E22AB0;
        Tue, 14 Jul 2020 18:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752751;
        bh=gDKXQ/PAHVKYxnxL2ZYanWXTvcB6U0Hatju/fOfkOns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hRXFMOsQFkRAb7ACmoGjpsk0CPZmIuINkY9NkKHxPRxezD2qHNOImDgZIA7BjLYt+
         ir8MG9ABOdvZ301fWMiW5OO8jnyuwwdwA1ilFmEpX8h1WD0CjEjo4nK059enbRnZ6E
         y1jxvS8JK86WQNlZWoGgnyZy3VL+BtM02yGBI3ds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 5.4 096/109] drm/amdgpu: dont do soft recovery if gpu_recovery=0
Date:   Tue, 14 Jul 2020 20:44:39 +0200
Message-Id: <20200714184110.163371173@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Olšák <marek.olsak@amd.com>

commit f4892c327a8e5df7ce16cab40897daf90baf6bec upstream.

It's impossible to debug shader hangs with soft recovery.

Signed-off-by: Marek Olšák <marek.olsak@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -36,7 +36,8 @@ static void amdgpu_job_timedout(struct d
 
 	memset(&ti, 0, sizeof(struct amdgpu_task_info));
 
-	if (amdgpu_ring_soft_recovery(ring, job->vmid, s_job->s_fence->parent)) {
+	if (amdgpu_gpu_recovery &&
+	    amdgpu_ring_soft_recovery(ring, job->vmid, s_job->s_fence->parent)) {
 		DRM_ERROR("ring %s timeout, but soft recovered\n",
 			  s_job->sched->name);
 		return;


