Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15FFE2A57B2
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731649AbgKCVpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:45:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:51208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732253AbgKCUxW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:53:22 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D83ED22226;
        Tue,  3 Nov 2020 20:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436802;
        bh=mXhfF6Ob3ccPeMIR1MCc+9rz8G+t3MHGIo+yTvLE0DI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2CrXaD6GfHJx7chbnq/RlRk3yw1bkzNwBArnHYoXIYJ7jm5U5vs1xMs0wv1dK7IH9
         axAXz15PgSq8hwlSVOLsK/2kBdmQaZcLiUFALGmQTCUrjkTOy1OYqgtpvKDxQZOSK4
         wMh+yULemqjQb08j7OOhW0FE+HcDaCrV+egPhwJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 018/214] RDMA/qedr: Fix memory leak in iWARP CM
Date:   Tue,  3 Nov 2020 21:34:26 +0100
Message-Id: <20201103203251.561562599@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
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
index e521f3c3dbbf1..653ddf30973ec 100644
--- a/drivers/infiniband/hw/qedr/qedr_iw_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
@@ -727,6 +727,7 @@ int qedr_iw_destroy_listen(struct iw_cm_id *cm_id)
 						    listener->qed_handle);
 
 	cm_id->rem_ref(cm_id);
+	kfree(listener);
 	return rc;
 }
 
-- 
2.27.0



