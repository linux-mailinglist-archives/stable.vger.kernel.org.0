Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973A8344139
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhCVMbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:31:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231168AbhCVMbJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:31:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9EAF61992;
        Mon, 22 Mar 2021 12:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416269;
        bh=OYhk2sLLhLgEUA2BHzblj5FlAW2+8yRrOnUvQyWhkH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MdCnIa4yZjPKVOIfBf+UtqKqOuXs4quK9Gacrgi7nQpghK3TMTDNUZzRMq/b5/zGZ
         9rkPpvTnLpLLmLNfCHZ4jpdHk63Pqab3VmCY8Aini/15RWq5JoIAdado7g7NHnfFIg
         bbNeRR+39XelAf5NEn2JhTiiyfoe2zmj4aHppa7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.11 043/120] nvme-tcp: fix possible hang when failing to set io queues
Date:   Mon, 22 Mar 2021 13:27:06 +0100
Message-Id: <20210322121931.096604977@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

commit 72f572428b83d0bc7028e7c4326d1a5f45205e44 upstream.

We only setup io queues for nvme controllers, and it makes absolutely no
sense to allow a controller (re)connect without any I/O queues.  If we
happen to fail setting the queue count for any reason, we should not
allow this to be a successful reconnect as I/O has no chance in going
through. Instead just fail and schedule another reconnect.

Fixes: 3f2304f8c6d6 ("nvme-tcp: add NVMe over TCP host driver")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/tcp.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1748,8 +1748,11 @@ static int nvme_tcp_alloc_io_queues(stru
 		return ret;
 
 	ctrl->queue_count = nr_io_queues + 1;
-	if (ctrl->queue_count < 2)
-		return 0;
+	if (ctrl->queue_count < 2) {
+		dev_err(ctrl->device,
+			"unable to set any I/O queues\n");
+		return -ENOMEM;
+	}
 
 	dev_info(ctrl->device,
 		"creating %d I/O queues.\n", nr_io_queues);


