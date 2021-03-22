Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3128344137
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbhCVMbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:31:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230450AbhCVMbG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:31:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA58661990;
        Mon, 22 Mar 2021 12:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416266;
        bh=BB4kcriIzzYm2PLNBQqg8ElTg9CHjOH+YsUkav71SX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDQ+jkr91D+2hjp583siWCzBf39qBPMYPYjjkNv0ie77nhE9zZ5zmSLwzT40im2Mp
         y8D5DifS13YPMsO9+CfQu9t1WdK6PnMqUve5wyKTlbYJNb8G1wj/XqQBtK1yhab+G4
         +0K5Vx7pVZkvmS+gKViJE8sRy6VFpsYH+PnxSgIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Yi Zhang <yi.zhang@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.11 042/120] nvme-tcp: fix misuse of __smp_processor_id with preemption enabled
Date:   Mon, 22 Mar 2021 13:27:05 +0100
Message-Id: <20210322121931.059273339@linuxfoundation.org>
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

commit bb83337058a7000644cdeffc67361d2473534756 upstream.

For our pure advisory use-case, we only rely on this call as a hint, so
fix the warning complaints of using the smp_processor_id variants with
preemption enabled.

Fixes: db5ad6b7f8cd ("nvme-tcp: try to send request in queue_rq context")
Fixes: ada831772188 ("nvme-tcp: Fix warning with CONFIG_DEBUG_PREEMPT")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -287,7 +287,7 @@ static inline void nvme_tcp_queue_reques
 	 * directly, otherwise queue io_work. Also, only do that if we
 	 * are on the same cpu, so we don't introduce contention.
 	 */
-	if (queue->io_cpu == __smp_processor_id() &&
+	if (queue->io_cpu == raw_smp_processor_id() &&
 	    sync && empty && mutex_trylock(&queue->send_mutex)) {
 		queue->more_requests = !last;
 		nvme_tcp_send_all(queue);


