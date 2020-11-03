Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F062A55BA
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731146AbgKCVEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:04:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:42596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387990AbgKCVEa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:04:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAEC6205ED;
        Tue,  3 Nov 2020 21:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437470;
        bh=3eol1acl+C68n5/aWIpoRKtuM51gU4LAbFrTdWOf1iM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dWQNFb8Oub31kWiG79caK9Lm3xmr4PAEMVlCUSpVultQ6F+B8oXvsvEjl3XYkS8O5
         n7BsJPzQmMiZuJBkndH+pOYrOYGJM04AJ3glZ4NxJO1cDbQhUyK/hJ093s+Ga4Pso8
         m9lI+Fbz6WJO7V68xH7Kb676cc7639XQHomG9Psg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 052/191] RDMA/qedr: Fix memory leak in iWARP CM
Date:   Tue,  3 Nov 2020 21:35:44 +0100
Message-Id: <20201103203239.374451899@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alok Prasad <palok@marvell.com>

[ Upstream commit a2267f8a52eea9096861affd463f691be0f0e8c9 ]

Fixes memory leak in iWARP CM

Fixes: e411e0587e0d ("RDMA/qedr: Add iWARP connection management functions")
Link: https://lore.kernel.org/r/20201021115008.28138-1-palok@marvell.com
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Alok Prasad <palok@marvell.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/qedr_iw_cm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/qedr/qedr_iw_cm.c b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
index e908dfbaa1378..1f1d6a000e5c9 100644
--- a/drivers/infiniband/hw/qedr/qedr_iw_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
@@ -677,6 +677,7 @@ int qedr_iw_destroy_listen(struct iw_cm_id *cm_id)
 						    listener->qed_handle);
 
 	cm_id->rem_ref(cm_id);
+	kfree(listener);
 	return rc;
 }
 
-- 
2.27.0



