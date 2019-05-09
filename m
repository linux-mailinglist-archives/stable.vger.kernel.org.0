Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4376A190CC
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbfEIStB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:49:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728140AbfEIStA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:49:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73B932182B;
        Thu,  9 May 2019 18:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427739;
        bh=E+ykIYYUrQjojjmCEIaMF/p9FlFHiedvAriHI6DW6HI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQJSbCsasN05gfyyZeoiGxI+Xq20x9dGu6jr0lz7dHXQLmEqpZX/PvKIBNFc5pZiN
         PGlGPSrCl1oSlceUwWCunUUlPa54FRHtfB4RhNn8b3tNT5Y7OTNomRx67apCmSSDlm
         er9q6ZGENKh1XpXZ5BnfmWlVBI8GojzjVQI/mpiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 45/66] virtio-blk: limit number of hw queues by nr_cpu_ids
Date:   Thu,  9 May 2019 20:42:20 +0200
Message-Id: <20190509181306.582804242@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
References: <20190509181301.719249738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit bf348f9b78d413e75bb079462751a1d86b6de36c ]

When tag_set->nr_maps is 1, the block layer limits the number of hw queues
by nr_cpu_ids. No matter how many hw queues are used by virtio-blk, as it
has (tag_set->nr_maps == 1), it can use at most nr_cpu_ids hw queues.

In addition, specifically for pci scenario, when the 'num-queues' specified
by qemu is more than maxcpus, virtio-blk would not be able to allocate more
than maxcpus vectors in order to have a vector for each queue. As a result,
it falls back into MSI-X with one vector for config and one shared for
queues.

Considering above reasons, this patch limits the number of hw queues used
by virtio-blk by nr_cpu_ids.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 23752dc99b008..dd64f586679e1 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -446,6 +446,8 @@ static int init_vq(struct virtio_blk *vblk)
 	if (err)
 		num_vqs = 1;
 
+	num_vqs = min_t(unsigned int, nr_cpu_ids, num_vqs);
+
 	vblk->vqs = kmalloc_array(num_vqs, sizeof(*vblk->vqs), GFP_KERNEL);
 	if (!vblk->vqs)
 		return -ENOMEM;
-- 
2.20.1



