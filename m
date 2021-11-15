Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067A1450CCB
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238546AbhKORnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:43:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:57862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238528AbhKORlP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:41:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FFBD632EF;
        Mon, 15 Nov 2021 17:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997228;
        bh=9EbQe+johC3kl+xeyfsK4NS3F4gVDSx3Mr+87J2Gpy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WEy+wjgd4V9SBbty7OiFG/ekiklHnsIxsAlTejh6X40EBGFtQzHfJCC8QSFeGynx9
         Efb49tOYua2z0Zn8Q9HCzgsJrBEmbmKpFPNFba0jtGrBZnPAxTLWXdHk6ZkdrhBul4
         WodZ1g8K6ItXn7Mnig10j7x/gcr2HqkfARQ0m8vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maurizio Lombardi <mlombard@redhat.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        John Meneghini <jmeneghi@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/575] nvmet-tcp: fix a memory leak when releasing a queue
Date:   Mon, 15 Nov 2021 17:56:35 +0100
Message-Id: <20211115165346.058628665@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 926245c7d22271307606c88b1fbb2539a8550e94 ]

page_frag_free() won't completely release the memory
allocated for the commands, the cache page must be explicitly
freed by calling __page_frag_cache_drain().

This bug can be easily reproduced by repeatedly
executing the following command on the initiator:

$echo 1 > /sys/devices/virtual/nvme-fabrics/ctl/nvme0/reset_controller

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 5266d534c4b31..b4ef7e9e8461f 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1398,6 +1398,7 @@ static void nvmet_tcp_uninit_data_in_cmds(struct nvmet_tcp_queue *queue)
 
 static void nvmet_tcp_release_queue_work(struct work_struct *w)
 {
+	struct page *page;
 	struct nvmet_tcp_queue *queue =
 		container_of(w, struct nvmet_tcp_queue, release_work);
 
@@ -1417,6 +1418,8 @@ static void nvmet_tcp_release_queue_work(struct work_struct *w)
 		nvmet_tcp_free_crypto(queue);
 	ida_simple_remove(&nvmet_tcp_queue_ida, queue->idx);
 
+	page = virt_to_head_page(queue->pf_cache.va);
+	__page_frag_cache_drain(page, queue->pf_cache.pagecnt_bias);
 	kfree(queue);
 }
 
-- 
2.33.0



