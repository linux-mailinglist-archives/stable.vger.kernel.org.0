Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379FE4513B8
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348649AbhKOTyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:54:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343898AbhKOTWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA30B635FB;
        Mon, 15 Nov 2021 18:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002103;
        bh=ZsKfohJl4e2rGbvDRMrzywK5flLwScxWwHbA89+MvZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDbkqOrTTDfce33IuR7a86+nBZq7Ttggy9dUxX4OrlO5DcpbUKLZZZS1DNe3E76Km
         tZiBYFez3YirWYqiU6bm9KJM2/Fz39lBJ2W5CBt/OMUa0xb9GorjpGj0Wc8dOVyePt
         d2NdIAkUuZ73JqFP3UWeWLixadOp0QXu4UfC1V+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 439/917] drm/msm: unlock on error in get_sched_entity()
Date:   Mon, 15 Nov 2021 17:58:54 +0100
Message-Id: <20211115165443.671361984@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 7425e8167507fe512d8ac0825acda4aebf0a7ca0 ]

Add a missing unlock on the error path if drm_sched_entity_init() fails.

Fixes: 68002469e571 ("drm/msm: One sched entity per process per priority")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20211011124005.GE15188@kili
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_submitqueue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/msm_submitqueue.c b/drivers/gpu/drm/msm/msm_submitqueue.c
index b8621c6e05546..7cb158bcbcf67 100644
--- a/drivers/gpu/drm/msm/msm_submitqueue.c
+++ b/drivers/gpu/drm/msm/msm_submitqueue.c
@@ -101,6 +101,7 @@ get_sched_entity(struct msm_file_private *ctx, struct msm_ringbuffer *ring,
 
 		ret = drm_sched_entity_init(entity, sched_prio, &sched, 1, NULL);
 		if (ret) {
+			mutex_unlock(&entity_lock);
 			kfree(entity);
 			return ERR_PTR(ret);
 		}
-- 
2.33.0



