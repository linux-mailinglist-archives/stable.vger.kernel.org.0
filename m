Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8CC29C221
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1813708AbgJ0Rbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760974AbgJ0OhX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:37:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0251922264;
        Tue, 27 Oct 2020 14:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809442;
        bh=fx7nSc4+HAA+ZI3A8vS+yupNxWF316MaiDraXpmIKTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vykwPpqEitKzQ4QRd3iwk7y3TovE/5/ACir9ZZ3yixC/hQIZAUhDTFysdQAppQsIH
         kMj8jDSHe3wWWXy2v7qWk3C8XD7TLz7LF/O5cKwiZ0GP/kw2pgLQOXeKoc4gA0y91B
         H71izEAdisp9OdoW9KPkLFiKY8KKpKdZhHOPDQvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 198/408] IB/mlx4: Adjust delayed work when a dup is observed
Date:   Tue, 27 Oct 2020 14:52:16 +0100
Message-Id: <20201027135504.284490872@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Håkon Bugge <haakon.bugge@oracle.com>

[ Upstream commit 785167a114855c5aa75efca97000e405c2cc85bf ]

When scheduling delayed work to clean up the cache, if the entry already
has been scheduled for deletion, we adjust the delay.

Fixes: 3cf69cc8dbeb ("IB/mlx4: Add CM paravirtualization")
Link: https://lore.kernel.org/r/20200803061941.1139994-7-haakon.bugge@oracle.com
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/cm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx4/cm.c b/drivers/infiniband/hw/mlx4/cm.c
index b591861934b3c..81d6a3460b55d 100644
--- a/drivers/infiniband/hw/mlx4/cm.c
+++ b/drivers/infiniband/hw/mlx4/cm.c
@@ -280,6 +280,9 @@ static void schedule_delayed(struct ib_device *ibdev, struct id_map_entry *id)
 	if (!sriov->is_going_down && !id->scheduled_delete) {
 		id->scheduled_delete = 1;
 		schedule_delayed_work(&id->timeout, CM_CLEANUP_CACHE_TIMEOUT);
+	} else if (id->scheduled_delete) {
+		/* Adjust timeout if already scheduled */
+		mod_delayed_work(system_wq, &id->timeout, CM_CLEANUP_CACHE_TIMEOUT);
 	}
 	spin_unlock_irqrestore(&sriov->going_down_lock, flags);
 	spin_unlock(&sriov->id_map_lock);
-- 
2.25.1



