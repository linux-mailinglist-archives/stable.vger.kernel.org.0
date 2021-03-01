Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26EC3328E55
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241625AbhCAT2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:28:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:46144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241550AbhCATYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:24:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EE2364F49;
        Mon,  1 Mar 2021 17:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618853;
        bh=IfeKqYHzE5ijcL9CnrsNpblBJMSXNUjvaOu3zxi3lIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jcx++tmblDDPSbZ67kBjRwV4mmyb4ZfAJVX65MY/LjV2xSN14jC4/UH6TbRXpM/p1
         vqHR4bG5hV7zrOWBJOErHXnF1XPhKJUVZ+Q7db72KQFtiAdXs6uPWNT5v6Rz72LoVN
         aJlTk7tbGN4qhlo8vjc7R5Q46xia8kH1i+yeCAvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minwoo Im <minwoo.im.dev@gmail.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 242/663] nvme-multipath: set nr_zones for zoned namespaces
Date:   Mon,  1 Mar 2021 17:08:10 +0100
Message-Id: <20210301161153.795097040@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 73a1a2298f3e9df24cea7a9aab412ba9470f6159 ]

The bio based drivers only require the request_queue's nr_zones is set,
so set this field in the head if the namespace path is zoned.

Fixes: 240e6ee272c07 ("nvme: support for zoned namespaces")
Reported-by: Minwoo Im <minwoo.im.dev@gmail.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 292e535a385d4..e812a0d0fdb3d 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -676,6 +676,10 @@ void nvme_mpath_add_disk(struct nvme_ns *ns, struct nvme_id_ns *id)
 	if (blk_queue_stable_writes(ns->queue) && ns->head->disk)
 		blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES,
 				   ns->head->disk->queue);
+#ifdef CONFIG_BLK_DEV_ZONED
+	if (blk_queue_is_zoned(ns->queue) && ns->head->disk)
+		ns->head->disk->queue->nr_zones = ns->queue->nr_zones;
+#endif
 }
 
 void nvme_mpath_remove_disk(struct nvme_ns_head *head)
-- 
2.27.0



