Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9B21483C9
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390795AbgAXL00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:26:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:41130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388623AbgAXL0Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:26:25 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8960206D4;
        Fri, 24 Jan 2020 11:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865184;
        bh=/nO3Ttx6srVgUV9YENUbndo2PQS8wsJTxorwB71OhYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0tbC6gQpMYKpffFvGcGsyDbIzsHtCP8BQ1Q8oHIZoWRIYUTb8OAO9rShG14dF0yYb
         Q0NvnjPDpebzPvm47pwvHYbgOzOEffpy8+PBu/mE0WCWbBZiE2S8+ZywdtK6AxszRD
         L5PZStMj0FpHx7Isj6m7utMWNdxMEOug37Q8IAXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Maximets <i.maximets@samsung.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 476/639] xdp: fix possible cq entry leak
Date:   Fri, 24 Jan 2020 10:30:46 +0100
Message-Id: <20200124093147.759308228@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Maximets <i.maximets@samsung.com>

[ Upstream commit 675716400da6f15b9d3db04ef74ee74ca9a00af3 ]

Completion queue address reservation could not be undone.
In case of bad 'queue_id' or skb allocation failure, reserved entry
will be leaked reducing the total capacity of completion queue.

Fix that by moving reservation to the point where failure is not
possible. Additionally, 'queue_id' checking moved out from the loop
since there is no point to check it there.

Fixes: 35fcde7f8deb ("xsk: support for Tx")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Tested-by: William Tu <u9012063@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 547fc4554b22c..c90854bc3048e 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -218,6 +218,9 @@ static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
 
 	mutex_lock(&xs->mutex);
 
+	if (xs->queue_id >= xs->dev->real_num_tx_queues)
+		goto out;
+
 	while (xskq_peek_desc(xs->tx, &desc)) {
 		char *buffer;
 		u64 addr;
@@ -228,12 +231,6 @@ static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
 			goto out;
 		}
 
-		if (xskq_reserve_addr(xs->umem->cq))
-			goto out;
-
-		if (xs->queue_id >= xs->dev->real_num_tx_queues)
-			goto out;
-
 		len = desc.len;
 		skb = sock_alloc_send_skb(sk, len, 1, &err);
 		if (unlikely(!skb)) {
@@ -245,7 +242,7 @@ static int xsk_generic_xmit(struct sock *sk, struct msghdr *m,
 		addr = desc.addr;
 		buffer = xdp_umem_get_data(xs->umem, addr);
 		err = skb_store_bits(skb, 0, buffer, len);
-		if (unlikely(err)) {
+		if (unlikely(err) || xskq_reserve_addr(xs->umem->cq)) {
 			kfree_skb(skb);
 			goto out;
 		}
-- 
2.20.1



