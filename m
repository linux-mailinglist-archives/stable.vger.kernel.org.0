Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA227328527
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbhCAQt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:49:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:46640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235125AbhCAQnG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:43:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 120C464EEF;
        Mon,  1 Mar 2021 16:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616187;
        bh=uWsaVMw3nfqRylxvj6D6O0iTkJVES9tNa4ySaa+boa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SoLGax7Wqxs9MNWSMQXH7nqYr36dxG/hhwAbtKa7EPDWHwiRHT2QLJ9Mfd1iw9J8P
         pzzlID0vDI/09rtGFiZxq7ecpeRBiz8jTac7HJwJIFq71RThTQcpGO0B/n939dsOAc
         Ue3MUGz/Nt3lUYvEOtH+tcn7ZVra4yT6/KneclAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>, Paul Durrant <paul@xen.org>,
        Wei Liu <wl@xen.org>, "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 034/176] xen/netback: fix spurious event detection for common event case
Date:   Mon,  1 Mar 2021 17:11:47 +0100
Message-Id: <20210301161022.670835763@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit a3daf3d39132b405781be8d9ede0c449b244b64e ]

In case of a common event for rx and tx queue the event should be
regarded to be spurious if no rx and no tx requests are pending.

Unfortunately the condition for testing that is wrong causing to
decide a event being spurious if no rx OR no tx requests are
pending.

Fix that plus using local variables for rx/tx pending indicators in
order to split function calls and if condition.

Fixes: 23025393dbeb3b ("xen/netback: use lateeoi irq binding")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Paul Durrant <paul@xen.org>
Reviewed-by: Wei Liu <wl@xen.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/interface.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index 007600b7b8686..8ec25a5f1ee92 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -162,13 +162,15 @@ irqreturn_t xenvif_interrupt(int irq, void *dev_id)
 {
 	struct xenvif_queue *queue = dev_id;
 	int old;
+	bool has_rx, has_tx;
 
 	old = atomic_fetch_or(NETBK_COMMON_EOI, &queue->eoi_pending);
 	WARN(old, "Interrupt while EOI pending\n");
 
-	/* Use bitwise or as we need to call both functions. */
-	if ((!xenvif_handle_tx_interrupt(queue) |
-	     !xenvif_handle_rx_interrupt(queue))) {
+	has_tx = xenvif_handle_tx_interrupt(queue);
+	has_rx = xenvif_handle_rx_interrupt(queue);
+
+	if (!has_rx && !has_tx) {
 		atomic_andnot(NETBK_COMMON_EOI, &queue->eoi_pending);
 		xen_irq_lateeoi(irq, XEN_EOI_FLAG_SPURIOUS);
 	}
-- 
2.27.0



