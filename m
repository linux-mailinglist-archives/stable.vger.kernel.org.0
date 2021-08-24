Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8341A3F64F3
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239251AbhHXRIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:08:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239293AbhHXRGu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:06:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BE4D619FA;
        Tue, 24 Aug 2021 16:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824390;
        bh=uwsmN8nWTEHWmw8gZ2TUrS8K/QuWhsW3qZyySIH122c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FURbfTZ+md0tWqOez7VqMfJu85fuGokc99OeONdFrT2lZBFFHNgC302Avx4AkxjjF
         na+d0EYYs1YPP34wrYkUujIrbyoI+U88P+7XubbhG7AJ/2pFBX5hPpk/dkKBFxlf3J
         5tKvqVEEd/pYXrhsnjzwwpjzAnoIPVhRcskElyznRywllNcTQdwelYThdWeT6meQSL
         Sh5AWXvJlKgoiCXDZQe4uf+nqvEZ7fA+/Z04lUF064lnfu/oZXxES1AGoyL88i81eS
         9Y5ZYyNAOTd2aev6gro9UBWvwymiW8wW//aoIjKHP7nR0zEyBCwILXgxPDS1stZXUG
         axYr09IshY21w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 41/98] vhost-vdpa: Fix integer overflow in vhost_vdpa_process_iotlb_update()
Date:   Tue, 24 Aug 2021 12:58:11 -0400
Message-Id: <20210824165908.709932-42-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

[ Upstream commit 0e398290cff997610b66e73573faaee70c9a700e ]

The "msg->iova + msg->size" addition can have an integer overflow
if the iotlb message is from a malicious user space application.
So let's fix it.

Fixes: 1b48dc03e575 ("vhost: vdpa: report iova range")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/20210728130756.97-1-xieyongji@bytedance.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 80184153ac7d..c4d53ff06bf8 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -623,7 +623,8 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 	long pinned;
 	int ret = 0;
 
-	if (msg->iova < v->range.first ||
+	if (msg->iova < v->range.first || !msg->size ||
+	    msg->iova > U64_MAX - msg->size + 1 ||
 	    msg->iova + msg->size - 1 > v->range.last)
 		return -EINVAL;
 
-- 
2.30.2

