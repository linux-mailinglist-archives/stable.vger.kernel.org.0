Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9729B16729C
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731748AbgBUIFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:05:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:38512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731572AbgBUIFH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:05:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D10AF2073A;
        Fri, 21 Feb 2020 08:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272307;
        bh=Dalcud8G3DF/3fo1QodJmuZ93FL/HOW+boXVE+ef1Cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x/oLgZF1fmtAbdCX5JNRXnzwzHLfxgHe2XrCLq4qagUq+NSMaTj9g/RBOft+Zc6Ym
         Pwmdbw7hyVKyvhWQzD1zzKooqJDm0m4U2JEQ7zbpvxQY7m2zK4FCHuNNfNYqblbaFf
         cER1g+smTRgOWLkUrskfexwpla2pfZJk/uy6SQYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yong Zhao <Yong.Zhao@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 093/344] drm/amdkfd: Fix a bug in SDMA RLC queue counting under HWS mode
Date:   Fri, 21 Feb 2020 08:38:12 +0100
Message-Id: <20200221072357.407635741@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yong Zhao <Yong.Zhao@amd.com>

[ Upstream commit f38abc15d157b7b31fa7f651dc8bf92858c963f8 ]

The sdma_queue_count increment should be done before
execute_queues_cpsch(), which calls pm_calc_rlib_size() where
sdma_queue_count is used to calculate whether over_subscription is
triggered.

With the previous code, when a SDMA queue is created,
compute_queue_count in pm_calc_rlib_size() is one more than the
actual compute queue number, because the queue_count has been
incremented while sdma_queue_count has not. This patch fixes that.

Signed-off-by: Yong Zhao <Yong.Zhao@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index f335f73919d15..a2ed9c257cb0d 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1181,16 +1181,18 @@ static int create_queue_cpsch(struct device_queue_manager *dqm, struct queue *q,
 
 	list_add(&q->list, &qpd->queues_list);
 	qpd->queue_count++;
+
+	if (q->properties.type == KFD_QUEUE_TYPE_SDMA)
+		dqm->sdma_queue_count++;
+	else if (q->properties.type == KFD_QUEUE_TYPE_SDMA_XGMI)
+		dqm->xgmi_sdma_queue_count++;
+
 	if (q->properties.is_active) {
 		dqm->queue_count++;
 		retval = execute_queues_cpsch(dqm,
 				KFD_UNMAP_QUEUES_FILTER_DYNAMIC_QUEUES, 0);
 	}
 
-	if (q->properties.type == KFD_QUEUE_TYPE_SDMA)
-		dqm->sdma_queue_count++;
-	else if (q->properties.type == KFD_QUEUE_TYPE_SDMA_XGMI)
-		dqm->xgmi_sdma_queue_count++;
 	/*
 	 * Unconditionally increment this counter, regardless of the queue's
 	 * type or whether the queue is active.
-- 
2.20.1



