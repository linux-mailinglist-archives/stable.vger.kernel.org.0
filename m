Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA70B3F63C6
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbhHXQ6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234982AbhHXQ5g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 217FE61452;
        Tue, 24 Aug 2021 16:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824210;
        bh=GW1cChix8yRQjWAtbGMQrsUfwA/OFHQv+8fKhDB2LZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jp0VXJR68Basz3hN3DgBTW4XU353RPrS8Xj/aWOs7Ou0WJOJ0owtNIxY6u5fFayLo
         58wcca9eW9lxHkte30A70xkhD8Lexy9saR23cYOUS/6BEz1DN8E/3mQDGPZ4+X38wX
         1w4RMwqaLMeK/yzg+weELys9EjOdTJ782HKfJF7Rc/meSJyKL2oIGum75KAEqNE26t
         ofVKS9HrerIWRrMx4oVFN1gzN1ybiRCj53agPFaH6iUldMuBzIDNbcK7zCe/sqI2rC
         yw7KguDQHzlV7G+GB0wPEMPblSPMrWO5x+IGm7nt84h+O+qq551UUXmI//YFMVM1f2
         7LiOEcfcOjbUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 043/127] vdpa_sim: Fix return value check for vdpa_alloc_device()
Date:   Tue, 24 Aug 2021 12:54:43 -0400
Message-Id: <20210824165607.709387-44-sashal@kernel.org>
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

[ Upstream commit 2b847f21145d84e2e1dde99d3e2c00a5468f02e4 ]

The vdpa_alloc_device() returns an error pointer upon
failure, not NULL. To handle the failure correctly, this
replaces NULL check with IS_ERR() check and propagate the
error upwards.

Fixes: 2c53d0f64c06 ("vdpasim: vDPA device simulator")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Link: https://lore.kernel.org/r/20210715080026.242-1-xieyongji@bytedance.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 98f793bc9376..26337ba42445 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -251,8 +251,10 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
 
 	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
 				    dev_attr->name);
-	if (!vdpasim)
+	if (IS_ERR(vdpasim)) {
+		ret = PTR_ERR(vdpasim);
 		goto err_alloc;
+	}
 
 	vdpasim->dev_attr = *dev_attr;
 	INIT_WORK(&vdpasim->work, dev_attr->work_fn);
-- 
2.30.2

