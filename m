Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B01638EF28
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbhEXP4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:56:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234285AbhEXPz2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:55:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12E4B6143C;
        Mon, 24 May 2021 15:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870905;
        bh=1thRWn/Ko8lZOPys+Us69FIXuUyvzd84Oklr9SZ8F9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HQyCZBPiwWh3nSIfen4peIyqhCKcspVvTAnva9O6uGiJWg2XFy8TK40EIKI1FjgK8
         Q0newV54exa2eSG8LuXF2wXgSOboeX9hr8BXxFE9SK+3SViQmyT0I/U+eWt7aGoX6L
         O8maBRf3GxKMKN0Dxy0R0Zg+GlL6Omn4kdinFU8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Narayan Ayalasomayajula <narayan.ayalasomayajula@wdc.com>,
        Anil Mishra <anil.mishra@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 054/104] nvme-tcp: fix possible use-after-completion
Date:   Mon, 24 May 2021 17:25:49 +0200
Message-Id: <20210524152334.635527739@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

commit 825619b09ad351894d2c6fb6705f5b3711d145c7 upstream.

Commit db5ad6b7f8cd ("nvme-tcp: try to send request in queue_rq
context") added a second context that may perform a network send.
This means that now RX and TX are not serialized in nvme_tcp_io_work
and can run concurrently.

While there is correct mutual exclusion in the TX path (where
the send_mutex protect the queue socket send activity) RX activity,
and more specifically request completion may run concurrently.

This means we must guarantee that any mutation of the request state
related to its lifetime, bytes sent must not be accessed when a completion
may have possibly arrived back (and processed).

The race may trigger when a request completion arrives, processed
_and_ reused as a fresh new request, exactly in the (relatively short)
window between the last data payload sent and before the request iov_iter
is advanced.

Consider the following race:
1. 16K write request is queued
2. The nvme command and the data is sent to the controller (in-capsule
   or solicited by r2t)
3. After the last payload is sent but before the req.iter is advanced,
   the controller sends back a completion.
4. The completion is processed, the request is completed, and reused
   to transfer a new request (write or read)
5. The new request is queued, and the driver reset the request parameters
   (nvme_tcp_setup_cmd_pdu).
6. Now context in (2) resumes execution and advances the req.iter

==> use-after-completion as this is already a new request.

Fix this by making sure the request is not advanced after the last
data payload send, knowing that a completion may have arrived already.

An alternative solution would have been to delay the request completion
or state change waiting for reference counting on the TX path, but besides
adding atomic operations to the hot-path, it may present challenges in
multi-stage R2T scenarios where a r2t handler needs to be deferred to
an async execution.

Reported-by: Narayan Ayalasomayajula <narayan.ayalasomayajula@wdc.com>
Tested-by: Anil Mishra <anil.mishra@wdc.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -940,7 +940,6 @@ static int nvme_tcp_try_send_data(struct
 		if (ret <= 0)
 			return ret;
 
-		nvme_tcp_advance_req(req, ret);
 		if (queue->data_digest)
 			nvme_tcp_ddgst_update(queue->snd_hash, page,
 					offset, ret);
@@ -957,6 +956,7 @@ static int nvme_tcp_try_send_data(struct
 			}
 			return 1;
 		}
+		nvme_tcp_advance_req(req, ret);
 	}
 	return -EAGAIN;
 }


