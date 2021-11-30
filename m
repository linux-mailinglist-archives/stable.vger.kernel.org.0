Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0DE4637DD
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243467AbhK3O4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:56:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48632 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243194AbhK3Oyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:54:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C853EB81A21;
        Tue, 30 Nov 2021 14:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD08C53FCF;
        Tue, 30 Nov 2021 14:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283884;
        bh=wiHEs+Ws9zJoSPVN+Gr8NlOunVPYd93tWM951MdfUdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IxvvgOld5OYn1/4jQpGU2RiPOplkIRMB+gH8P1aBCg2cYZb+Z/dfVNj19+WQV/gZh
         nj0hF66G15pDElV/c5N3619w05AqZAz3radKHF8UeL7p4NSsy427+sUHFwmgvtTiZV
         c+GancBQaZ/PtTpFxBfsYZEh4U/ja2arEErgyu9F7tNa3T+kuN55CYr9o6bpXij5oi
         kFFRXBv/HWa/maHI4teSqxJG+GsxN50zjUT4TfHBkaDNbT81l/To6t9nc+3qtknmZ7
         NiV0a6lOyzRt6v1bR//Tv3KRvutOq0Hd6x0tgg/pdy4rEgqtYbRrKFbyPpfVKVQt1w
         eMQAm0FD8+aQA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maurizio Lombardi <mlombard@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        John Meneghini <jmeneghi@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, kch@nvidia.com,
        linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 27/43] nvmet-tcp: fix a race condition between release_queue and io_work
Date:   Tue, 30 Nov 2021 09:50:04 -0500
Message-Id: <20211130145022.945517-27-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145022.945517-1-sashal@kernel.org>
References: <20211130145022.945517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit a208fc56721775987c1b86e20d86d7e0d017c0b2 ]

If the initiator executes a reset controller operation while
performing I/O, the target kernel will crash because of a race condition
between release_queue and io_work;
nvmet_tcp_uninit_data_in_cmds() may be executed while io_work
is running, calling flush_work() was not sufficient to
prevent this because io_work could requeue itself.

Fix this bug by using cancel_work_sync() to prevent io_work
from requeuing itself and set rcv_state to NVMET_TCP_RECV_ERR to
make sure we don't receive any more data from the socket.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 1251fd6e92780..f726964b56555 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1407,7 +1407,9 @@ static void nvmet_tcp_release_queue_work(struct work_struct *w)
 	mutex_unlock(&nvmet_tcp_queue_mutex);
 
 	nvmet_tcp_restore_socket_callbacks(queue);
-	flush_work(&queue->io_work);
+	cancel_work_sync(&queue->io_work);
+	/* stop accepting incoming data */
+	queue->rcv_state = NVMET_TCP_RECV_ERR;
 
 	nvmet_tcp_uninit_data_in_cmds(queue);
 	nvmet_sq_destroy(&queue->nvme_sq);
-- 
2.33.0

