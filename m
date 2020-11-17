Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D6C2B6452
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732581AbgKQNpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:45:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:50190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732463AbgKQNim (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:38:42 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31E0E2467D;
        Tue, 17 Nov 2020 13:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620321;
        bh=6jaVK7/XoudamzTGUIujKzbiF0gIgM+0MvtYseH/cGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OOzNmyE2kcrIE/hJKaC44ktBCEBllQnECVdQ1i5/cWbksbZK5klyM5ABrWsnQW3E1
         muc4gxgDdPjPgLHDkqmpf4Zv2XmUSc0Us2pMlnVmkORCKZePk91X1bJXbluwSm41AZ
         vne4m8DeK88pnKLhhXDlIwwRRSaMAJHUZyWtQ3Qs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 179/255] nvme: fix incorrect behavior when BLKROSET is called by the user
Date:   Tue, 17 Nov 2020 14:05:19 +0100
Message-Id: <20201117122147.640259511@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 65c5a055b0d567b7e7639d942c0605da9cc54c5e ]

The offending commit breaks BLKROSET ioctl because a device
revalidation will blindly override BLKROSET setting. Hence,
we remove the disk rw setting in case NVME_NS_ATTR_RO is cleared
from by the controller.

Fixes: 1293477f4f32 ("nvme: set gendisk read only based on nsattr")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index b130696b00592..349fba056cb65 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2064,8 +2064,6 @@ static void nvme_update_disk_info(struct gendisk *disk,
 
 	if (id->nsattr & NVME_NS_ATTR_RO)
 		set_disk_ro(disk, true);
-	else
-		set_disk_ro(disk, false);
 }
 
 static inline bool nvme_first_scan(struct gendisk *disk)
-- 
2.27.0



