Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C34328677
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237251AbhCARKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:10:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:35320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236660AbhCAREV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:04:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE67B64FF0;
        Mon,  1 Mar 2021 16:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616764;
        bh=TcRIckDQhnkluPVk4WyQeKhdvoOaLf24ear0HNEgQzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vb2DXlWgtMzuL1Jwh2/az5e7+XBZC/pAUTdu4Zqs6aH3EVZurhpwULqpNQ4xZ4tO3
         Ly476G0lHWZxjFoqYugCX9eSUsHooFRpo8g1mFP5A9xiNu1DE06IV5gNPZFwep2blV
         Rll3DH8GYbshhxAtg2dgbqiW4sNY2sSD6PzLSuIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>, Paul Durrant <paul@xen.org>,
        Wei Liu <wl@xen.org>, "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 060/247] xen/netback: fix spurious event detection for common event case
Date:   Mon,  1 Mar 2021 17:11:20 +0100
Message-Id: <20210301161034.601273235@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
index c960cb7e3251f..3b5fdb24ef1b9 100644
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



