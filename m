Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3A024BCE4
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729227AbgHTJnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:43:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728902AbgHTJmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:42:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A521E20855;
        Thu, 20 Aug 2020 09:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916541;
        bh=nr/2VzfFW/HOWdF78Zd5ouU6Ua0NDBxDOqvDSXOvJ9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GGOD8rxHUSrbo+cMycOh3CloluEwCc+tvb0d+euU/n4VVYJ0REo46QMaprlZNaLnO
         LH1FOUDSM+ntCYihJ1Qf7sZuva2j+ut3nF/ObQxnMr/oANkdf6UrkBzQJudBld/KRb
         gX8vQ1GSqww7DZMuLhFXi68rzvDFLJV0th3bsWV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <rong.a.chen@intel.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 165/204] vdpa_sim: init iommu lock
Date:   Thu, 20 Aug 2020 11:21:02 +0200
Message-Id: <20200820091614.460785917@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
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
index e2dc8edd680e0..3554f8de00e64 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -330,6 +330,7 @@ static struct vdpasim *vdpasim_create(void)
 
 	INIT_WORK(&vdpasim->work, vdpasim_work);
 	spin_lock_init(&vdpasim->lock);
+	spin_lock_init(&vdpasim->iommu_lock);
 
 	dev = &vdpasim->vdpa.dev;
 	dev->coherent_dma_mask = DMA_BIT_MASK(64);
-- 
2.25.1



