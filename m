Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3309696099
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 15:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730494AbfHTNmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 09:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730090AbfHTNl7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Aug 2019 09:41:59 -0400
Received: from sasha-vm.mshome.net (unknown [12.236.144.82])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA53D22DA7;
        Tue, 20 Aug 2019 13:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566308518;
        bh=pULf/NAYntD2MtpyYU9EQBMbQQn9+vSDDP6Lf4XG7O4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nedVEDSNL7wNplWLctnBEY2jd7JaODrWrK6TxF24zkKNJZiGR+F7y+dKCoH1lDp/a
         wvTh6quGYc5todUCvuLBzSHTGBRGBbGKwI9vrf3K12Xc4N6gpSoARNBLgZ4lZcv+KY
         EagH8F/HTeRM00oT7u/ImTOz7LwOgQhUHFhHk3cY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Monk.liu@amd.com, Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 40/44] drm/scheduler: use job count instead of peek
Date:   Tue, 20 Aug 2019 09:40:24 -0400
Message-Id: <20190820134028.10829-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190820134028.10829-1-sashal@kernel.org>
References: <20190820134028.10829-1-sashal@kernel.org>
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

[ Upstream commit e1b4ce25dbc93ab0cb8ed0f236a3b9ff7b03802c ]

The spsc_queue_peek function is accessing queue->head which belongs to
the consumer thread and shouldn't be accessed by the producer

This is fixing a rare race condition when destroying entities.

Signed-off-by: Christian König <christian.koenig@amd.com>
Acked-by: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Reviewed-by: Monk.liu@amd.com
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/scheduler/sched_entity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/scheduler/sched_entity.c b/drivers/gpu/drm/scheduler/sched_entity.c
index 35ddbec1375ae..671c90f34ede6 100644
--- a/drivers/gpu/drm/scheduler/sched_entity.c
+++ b/drivers/gpu/drm/scheduler/sched_entity.c
@@ -95,7 +95,7 @@ static bool drm_sched_entity_is_idle(struct drm_sched_entity *entity)
 	rmb(); /* for list_empty to work without lock */
 
 	if (list_empty(&entity->list) ||
-	    spsc_queue_peek(&entity->job_queue) == NULL)
+	    spsc_queue_count(&entity->job_queue) == 0)
 		return true;
 
 	return false;
@@ -281,7 +281,7 @@ void drm_sched_entity_fini(struct drm_sched_entity *entity)
 	/* Consumption of existing IBs wasn't completed. Forcefully
 	 * remove them here.
 	 */
-	if (spsc_queue_peek(&entity->job_queue)) {
+	if (spsc_queue_count(&entity->job_queue)) {
 		if (sched) {
 			/* Park the kernel for a moment to make sure it isn't processing
 			 * our enity.
-- 
2.20.1

