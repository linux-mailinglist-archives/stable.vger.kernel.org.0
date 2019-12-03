Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84944111F97
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbfLCWme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:42:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:57482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727887AbfLCWma (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:42:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DB1B207DD;
        Tue,  3 Dec 2019 22:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412949;
        bh=MPHWoj54lG3YeA/Bjj1a9WRZin6Iim6rDflS+9K2Mf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z70EO+J5HRH/zXxuleINZ6OSuhrFzhauwW84Qz5jv/tyxHZdTZtUlrhg0zY1mhdeb
         731miaYkKPzfCKbjKVa3RvsQPuS5oNg9hojG+Zi9kiefUWxDBJsPT+uyxqu6iFGaTJ
         HuUxH+BZHyFSduaCZ2pevNWSl0MXHRop7k7tdQDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shirish S <shirish.s@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 077/135] drm/amdgpu: dont schedule jobs while in reset
Date:   Tue,  3 Dec 2019 23:35:17 +0100
Message-Id: <20191203213029.135880551@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shirish S <shirish.s@amd.com>

[ Upstream commit f2efc6e60089c99c342a6b7da47f1037e06c4296 ]

[Why]

doing kthread_park()/unpark() from drm_sched_entity_fini
while GPU reset is in progress defeats all the purpose of
drm_sched_stop->kthread_park.
If drm_sched_entity_fini->kthread_unpark() happens AFTER
drm_sched_stop->kthread_park nothing prevents from another
(third) thread to keep submitting job to HW which will be
picked up by the unparked scheduler thread and try to submit
to HW but fail because the HW ring is deactivated.

[How]
grab the reset lock before calling drm_sched_entity_fini()

Signed-off-by: Shirish S <shirish.s@amd.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
index 7398b4850649b..b7633484d15f2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c
@@ -597,8 +597,11 @@ void amdgpu_ctx_mgr_entity_fini(struct amdgpu_ctx_mgr *mgr)
 			continue;
 		}
 
-		for (i = 0; i < num_entities; i++)
+		for (i = 0; i < num_entities; i++) {
+			mutex_lock(&ctx->adev->lock_reset);
 			drm_sched_entity_fini(&ctx->entities[0][i].entity);
+			mutex_unlock(&ctx->adev->lock_reset);
+		}
 	}
 }
 
-- 
2.20.1



