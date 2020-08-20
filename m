Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33EF124BE51
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730746AbgHTNXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:23:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728223AbgHTJeM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:34:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3274222BED;
        Thu, 20 Aug 2020 09:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916045;
        bh=Y+fIIY8x7WyEz2cmhqro6qkEptl2S2GE6qcCTO4P/Mc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bzeB29XOKfL4G+Uoj5uaqPpcdIkSgeZ3v54f5mmhiumHzb4Su1hJWGbulCs9dZ+T1
         uM8nkGhL1IjrwFfIFdNTWrXhEgPRYKSYZ3AdVA1qZW35keyCqcOGcVTiPQ+Ht0aurd
         73+8ouFJIUMYrZF1seL497g74NfDjp+KVmZqG9VY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <rong.a.chen@intel.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 195/232] vdpa_sim: init iommu lock
Date:   Thu, 20 Aug 2020 11:20:46 +0200
Message-Id: <20200820091622.235916680@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 1e3e792650d2c0df8dd796906275b7c79e278664 ]

The patch adding the iommu lock did not initialize it.
The struct is zero-initialized so this is mostly a problem
when using lockdep.

Reported-by: kernel test robot <rong.a.chen@intel.com>
Cc: Max Gurtovoy <maxg@mellanox.com>
Fixes: 0ea9ee430e74 ("vdpasim: protect concurrent access to iommu iotlb")
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 8ac6f341dcc16..412fa85ba3653 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -331,6 +331,7 @@ static struct vdpasim *vdpasim_create(void)
 
 	INIT_WORK(&vdpasim->work, vdpasim_work);
 	spin_lock_init(&vdpasim->lock);
+	spin_lock_init(&vdpasim->iommu_lock);
 
 	dev = &vdpasim->vdpa.dev;
 	dev->coherent_dma_mask = DMA_BIT_MASK(64);
-- 
2.25.1



