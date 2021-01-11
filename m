Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8D42F164C
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729943AbhAKNur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:50:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:56732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730838AbhAKNJ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:09:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FA83229CA;
        Mon, 11 Jan 2021 13:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370525;
        bh=ZA4k0GC8grVRUuMqf0Ra6XGIn0Ip1OIEAcHR2mIHaaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bpUXzl20kW16GCk6YZHIyWo8jihAdTcMT82RSY6e5rXFWV/tUD/bRmMI8Py+B9Oyb
         PBkqYTxiwTUCA/+qY/4pLIxzazK5TFOn0HFxNFpNND9h0eZ4ztQEzsX++kQbDaYOHu
         y1vNRH9aBXdG5hpSQJjPm4T+sEVEOes/Cyo0oUtw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Xie He <xie.he.0141@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 30/77] net: hdlc_ppp: Fix issues when mod_timer is called while timer is running
Date:   Mon, 11 Jan 2021 14:01:39 +0100
Message-Id: <20210111130037.850248761@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
References: <20210111130036.414620026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 1fef73597fa545c35fddc953979013882fbd4e55 ]

ppp_cp_event is called directly or indirectly by ppp_rx with "ppp->lock"
held. It may call mod_timer to add a new timer. However, at the same time
ppp_timer may be already running and waiting for "ppp->lock". In this
case, there's no need for ppp_timer to continue running and it can just
exit.

If we let ppp_timer continue running, it may call add_timer. This causes
kernel panic because add_timer can't be called with a timer pending.
This patch fixes this problem.

Fixes: e022c2f07ae5 ("WAN: new synchronous PPP implementation for generic HDLC.")
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wan/hdlc_ppp.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/wan/hdlc_ppp.c
+++ b/drivers/net/wan/hdlc_ppp.c
@@ -572,6 +572,13 @@ static void ppp_timer(struct timer_list
 	unsigned long flags;
 
 	spin_lock_irqsave(&ppp->lock, flags);
+	/* mod_timer could be called after we entered this function but
+	 * before we got the lock.
+	 */
+	if (timer_pending(&proto->timer)) {
+		spin_unlock_irqrestore(&ppp->lock, flags);
+		return;
+	}
 	switch (proto->state) {
 	case STOPPING:
 	case REQ_SENT:


