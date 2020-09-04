Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 115FF25D9A3
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 15:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbgIDNbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 09:31:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730449AbgIDNaV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 09:30:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DCD920797;
        Fri,  4 Sep 2020 13:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599226200;
        bh=fEDNqrKk1L90tOKccmYsk0EvJvpUJC/b4KtBrKOxCcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mwOz1mbIrWF/N+oqu3UxaClyB4ojoOb4B/MrVh9DlFVBvjGAsTGJS0mIbHizJwaug
         OJ7nX7wwkaNkSsoBZ4PO2id+81+f5gqxylKDt1x9VpKM1tSM23d7So4gNlBhMlr3D8
         W/4+ZzYY6hsgjzXXwh3FHSlZUkXvvOkQaY4czHnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Emily Deng <Emily.Deng@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Walter Lozano <walter.lozano@collabora.com>
Subject: [PATCH 5.4 04/16] drm/sched:  Fix passing zero to PTR_ERR warning v2
Date:   Fri,  4 Sep 2020 15:29:57 +0200
Message-Id: <20200904120257.416041995@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904120257.203708503@linuxfoundation.org>
References: <20200904120257.203708503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Grodzovsky <andrey.grodzovsky@amd.com>

commit d7c5782acd354bdb5ed0fa10e1e397eaed558390 upstream.

Fix a static code checker warning.

v2: Drop PTR_ERR_OR_ZERO.

Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Reviewed-by: Emily Deng <Emily.Deng@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Walter Lozano <walter.lozano@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/scheduler/sched_main.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -496,8 +496,10 @@ void drm_sched_resubmit_jobs(struct drm_
 		fence = sched->ops->run_job(s_job);
 
 		if (IS_ERR_OR_NULL(fence)) {
+			if (IS_ERR(fence))
+				dma_fence_set_error(&s_fence->finished, PTR_ERR(fence));
+
 			s_job->s_fence->parent = NULL;
-			dma_fence_set_error(&s_fence->finished, PTR_ERR(fence));
 		} else {
 			s_job->s_fence->parent = fence;
 		}
@@ -748,8 +750,9 @@ static int drm_sched_main(void *param)
 					  r);
 			dma_fence_put(fence);
 		} else {
+			if (IS_ERR(fence))
+				dma_fence_set_error(&s_fence->finished, PTR_ERR(fence));
 
-			dma_fence_set_error(&s_fence->finished, PTR_ERR(fence));
 			drm_sched_process_job(NULL, &sched_job->cb);
 		}
 


