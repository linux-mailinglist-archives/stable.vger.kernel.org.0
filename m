Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBCE37C544
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbhELPjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:39:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233701AbhELP3E (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:29:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF0A26193E;
        Wed, 12 May 2021 15:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832518;
        bh=FG5kT/gty4np41y74Sjdqb2aFVfHc88v4Z11q4JpcF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=myRdFj45q7RMshoXDc1e3AUYYPvHwrMWsVdrqc5l3HlBTqHG6JqpjZJ372S+cj5Nz
         S1tvik+au5FOw/c05qifms2pXmhYB0lzbL2ruzxkh9n2xAOOec7hZhzSgv8nF8H615
         JICGySI3PqkAtvUIzZXQiykMivD9KIlull0XAx4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin George <marting@netapp.com>,
        Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 312/530] nvme: retrigger ANA log update if group descriptor isnt found
Date:   Wed, 12 May 2021 16:47:02 +0200
Message-Id: <20210512144830.060729757@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit dd8f7fa908f66dd44abcd83cbb50410524b9f8ef ]

If ANA is enabled but no ANA group descriptor is found when creating
a new namespace the ANA log is most likely out of date, so trigger
a re-read. The namespace will be tagged with the NS_ANA_PENDING flag
to exclude it from path selection until the ANA log has been re-read.

Fixes: 32acab3181c7 ("nvme: implement multipath access to nvme subsystems")
Reported-by: Martin George <marting@netapp.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index e812a0d0fdb3..f750cf98ae26 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -667,6 +667,10 @@ void nvme_mpath_add_disk(struct nvme_ns *ns, struct nvme_id_ns *id)
 		if (desc.state) {
 			/* found the group desc: update */
 			nvme_update_ns_ana_state(&desc, ns);
+		} else {
+			/* group desc not found: trigger a re-read */
+			set_bit(NVME_NS_ANA_PENDING, &ns->flags);
+			queue_work(nvme_wq, &ns->ctrl->ana_work);
 		}
 	} else {
 		ns->ana_state = NVME_ANA_OPTIMIZED; 
-- 
2.30.2



