Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996BC3F63C0
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbhHXQ6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234970AbhHXQ5d (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 092F06147F;
        Tue, 24 Aug 2021 16:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824207;
        bh=EObCMEwt2gcaVA5GvOYHQIG9LN4neQRYNG2RejSGSJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gU2n7awCawLLdBXWODTC8tf9/zhaouQrblpINWDm3krBl8ZqDeZ6HH2fwRPOHWqv1
         M7QXp1P/ZP1lO9I8QE8HI+EbXbqSilFshct9QJmPHeKasp0WipP4qjT6WQegSyTJzb
         TGAabannWaVBeFxLhXqWRVux9NMy6vpz7HG6SooEUnDcXIHZTuvKHNJ4o/K7nDdx9C
         fgTbJGf1JFTDvbBKymhTMD9jeVAGiXEYVjCzedbTMtPiMIydwUT0kqi8MtIRBBKVrA
         MqdcCglb85zRVE74dtQ8fYXBMtARDiBU4L9FYEJV7qcBJ1HbBDN3n62Ff6Xt2SenCu
         pHVWp+iljpx/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 040/127] vhost-vdpa: Fix integer overflow in vhost_vdpa_process_iotlb_update()
Date:   Tue, 24 Aug 2021 12:54:40 -0400
Message-Id: <20210824165607.709387-41-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
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
index fb41db3da611..b5201bedf93f 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -614,7 +614,8 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 	long pinned;
 	int ret = 0;
 
-	if (msg->iova < v->range.first ||
+	if (msg->iova < v->range.first || !msg->size ||
+	    msg->iova > U64_MAX - msg->size + 1 ||
 	    msg->iova + msg->size - 1 > v->range.last)
 		return -EINVAL;
 
-- 
2.30.2

