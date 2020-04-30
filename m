Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203F71BFD65
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 16:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgD3OMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 10:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727932AbgD3NvL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:51:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4554621775;
        Thu, 30 Apr 2020 13:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254671;
        bh=UUerJjfHpwzmoAU169iQTTzVJIn8QWxF04p5YHMxj/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rnMbCvu/rpeJ4MCupTQyBzL3lUCyoWwOVPRcPRAattMCrzHYPe3kIaxsjR+ZpGDir
         706txQbJ3BYB7GUqSM7pQxrYrj0bugHcqlanWV+7caLwPb1S5Oc0rmz9AaEJadSSHz
         X+uY67Rhgs5qQrA2jVlWtXAqeugVZLC7Dz7ZgHMo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Kent Russell <kent.russell@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.6 23/79] drm/scheduler: fix drm_sched_get_cleanup_job
Date:   Thu, 30 Apr 2020 09:49:47 -0400
Message-Id: <20200430135043.19851-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 8623b5255ae7ccaf276aac3920787bf575fa6b37 ]

We are racing to initialize sched->thread here, just always check the
current thread.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Link: https://patchwork.freedesktop.org/patch/361303/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/scheduler/sched_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/scheduler/sched_main.c b/drivers/gpu/drm/scheduler/sched_main.c
index 60c4c6a1aac68..75737ec596141 100644
--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -687,7 +687,7 @@ drm_sched_get_cleanup_job(struct drm_gpu_scheduler *sched)
 	 */
 	if ((sched->timeout != MAX_SCHEDULE_TIMEOUT &&
 	    !cancel_delayed_work(&sched->work_tdr)) ||
-	    __kthread_should_park(sched->thread))
+	    kthread_should_park())
 		return NULL;
 
 	spin_lock_irqsave(&sched->job_list_lock, flags);
-- 
2.20.1

