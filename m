Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C51A2A59B4
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729893AbgKCUiL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:38:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:48056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729878AbgKCUiK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:38:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CF9B22277;
        Tue,  3 Nov 2020 20:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435890;
        bh=HZ0UlOng7ybFLQxvqtHXjpkSuYOAUR3Hx67xi1gwmLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OW/eS1WsJxgVxb06zNXB3uyOK5QkF4/Hgu4VBpCTihfka26WW47sqXwjGi3ZAtV8C
         aPjQeQasObovRzSuXD4+dMPaMfARS6ogOGHydIc8FQnlXnf4Uq2sLhH08+yAi2Kevf
         nBirTIl4OgEt5NiI68rZ+/D7ECQpQL2P7U8KClB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 028/391] RDMA/qedr: Fix memory leak in iWARP CM
Date:   Tue,  3 Nov 2020 21:31:19 +0100
Message-Id: <20201103203349.703907354@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
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
index c7169d2c69e5b..c4bc58736e489 100644
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



