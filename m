Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D012F9F98
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 13:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391533AbhARM1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 07:27:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:39540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390732AbhARLps (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:45:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E96422D3E;
        Mon, 18 Jan 2021 11:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970297;
        bh=EKTbyFaF2UQrly7zSwaVBucChT2Tp/Ny4dti8XsZIms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NARBNwIhwWSb4Bby+ZTBT32VA+dTsFsTgdPioME1dx2SVuL9/L/mMFQGqInJKMY31
         m6dM5Y+LEGCFda05nPUj0CCADYoWnKcX4lri+3OUy/hngramb0CZ2Rz88dJAmPQrIp
         5ygfaXbCaL8gUYqGRtMgXuFrxG1iB0xT/CBpULAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Or Gerlitz <gerlitz.or@gmail.com>,
        Yi Zhang <yi.zhang@redhat.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 120/152] nvme-tcp: Fix warning with CONFIG_DEBUG_PREEMPT
Date:   Mon, 18 Jan 2021 12:34:55 +0100
Message-Id: <20210118113358.478751518@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

commit ada831772188192243f9ea437c46e37e97a5975d upstream.

We shouldn't call smp_processor_id() in a preemptible
context, but this is advisory at best, so instead
call __smp_processor_id().

Fixes: db5ad6b7f8cd ("nvme-tcp: try to send request in queue_rq context")
Reported-by: Or Gerlitz <gerlitz.or@gmail.com>
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/host/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -286,7 +286,7 @@ static inline void nvme_tcp_queue_reques
 	 * directly, otherwise queue io_work. Also, only do that if we
 	 * are on the same cpu, so we don't introduce contention.
 	 */
-	if (queue->io_cpu == smp_processor_id() &&
+	if (queue->io_cpu == __smp_processor_id() &&
 	    sync && empty && mutex_trylock(&queue->send_mutex)) {
 		queue->more_requests = !last;
 		nvme_tcp_send_all(queue);


