Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37C96A9097
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389215AbfIDSKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:10:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390085AbfIDSKg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:10:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88E9022CEA;
        Wed,  4 Sep 2019 18:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620636;
        bh=9d3XUrSeTaSLmwocDQ5m6ib+sKI74fEJgL3mfYS6ZAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fWAIV5m6UaUNZHtas6eX6UHxweV4ld8t9wEhGgp//oKJ/KNL5bcjW6PhuNQOhyOEc
         E73aeqAT5uA2uIdlfQKw7IbDjudwOq+M86jVenM1LGYW/ASjCDmqO5xAxduxulCjRY
         V69l8qt5/qDZTXTbHM+OqmKjVTyM/iJ0AM9k6/PE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Monk.liu@amd.com, Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 038/143] drm/scheduler: use job count instead of peek
Date:   Wed,  4 Sep 2019 19:53:01 +0200
Message-Id: <20190904175315.541114767@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



