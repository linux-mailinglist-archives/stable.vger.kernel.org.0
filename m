Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58AC9226505
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731112AbgGTPuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:50:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731108AbgGTPuL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:50:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAE4322B4D;
        Mon, 20 Jul 2020 15:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260211;
        bh=IGi0Xef7jbHhMsYfOprqPDNw4VFPWt/swz7U6H8LxOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V/EYyjE4KRBWZmwCJX1wMKVZgokQtohQ56wppvPPU7aLpTLF6mQtsV0F7+qHdYYLC
         bGLoyaQ8VQtZe2rs9YAqSbbz3xm8OoBoyuobXVPJ/rZCJMq5W6sjOaoqdMsKa+WCsw
         tyABxV1GjC+b5J4GvuTbMLzL0YlzK6Ls74Wz8SdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bernard Zhao <bernard@vivo.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 020/133] drm/msm: fix potential memleak in error branch
Date:   Mon, 20 Jul 2020 17:36:07 +0200
Message-Id: <20200720152804.704407352@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bernard Zhao <bernard@vivo.com>

[ Upstream commit 177d3819633cd520e3f95df541a04644aab4c657 ]

In function msm_submitqueue_create, the queue is a local
variable, in return -EINVAL branch, queue didn`t add to ctx`s
list yet, and also didn`t kfree, this maybe bring in potential
memleak.

Signed-off-by: Bernard Zhao <bernard@vivo.com>
[trivial commit msg fixup]
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_submitqueue.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_submitqueue.c b/drivers/gpu/drm/msm/msm_submitqueue.c
index 5115f75b5b7f3..325da440264a3 100644
--- a/drivers/gpu/drm/msm/msm_submitqueue.c
+++ b/drivers/gpu/drm/msm/msm_submitqueue.c
@@ -78,8 +78,10 @@ int msm_submitqueue_create(struct drm_device *drm, struct msm_file_private *ctx,
 	queue->flags = flags;
 
 	if (priv->gpu) {
-		if (prio >= priv->gpu->nr_rings)
+		if (prio >= priv->gpu->nr_rings) {
+			kfree(queue);
 			return -EINVAL;
+		}
 
 		queue->prio = prio;
 	}
-- 
2.25.1



