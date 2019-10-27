Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56DA6E6768
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730886AbfJ0VUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:20:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728941AbfJ0VUk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:20:40 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FC5D205C9;
        Sun, 27 Oct 2019 21:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211239;
        bh=4HTSAcKMHHhArRvWh4ks/beeLB7R+fEj+N19kWOwOaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u8IjIzWoCtPDrsFpb7sAa7NaPHYlBfpu7QEjIW12uYJlUrhqmsoegRzAazqegkkgr
         ZTDsVj3Xs4UJJsomT2J3HHM7MBT7NF9WnRt+5xsCJfJ8gEsBP0SoubXxd5hXFUhAKD
         lhaoUusy+JonRUHvp9qBHCjjiBw2jh0UUjRVVIRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ederson de Souza <ederson.desouza@intel.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 079/197] sched: etf: Fix ordering of packets with same txtime
Date:   Sun, 27 Oct 2019 21:59:57 +0100
Message-Id: <20191027203355.952831914@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit 28aa7c86c2b49f659c8460a89e53b506c45979bb ]

When a application sends many packets with the same txtime, they may
be transmitted out of order (different from the order in which they
were enqueued).

This happens because when inserting elements into the tree, when the
txtime of two packets are the same, the new packet is inserted at the
left side of the tree, causing the reordering. The only effect of this
change should be that packets with the same txtime will be transmitted
in the order they are enqueued.

The application in question (the AVTP GStreamer plugin, still in
development) is sending video traffic, in which each video frame have
a single presentation time, the problem is that when packetizing,
multiple packets end up with the same txtime.

The receiving side was rejecting packets because they were being
received out of order.

Fixes: 25db26a91364 ("net/sched: Introduce the ETF Qdisc")
Reported-by: Ederson de Souza <ederson.desouza@intel.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_etf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_etf.c
+++ b/net/sched/sch_etf.c
@@ -177,7 +177,7 @@ static int etf_enqueue_timesortedlist(st
 
 		parent = *p;
 		skb = rb_to_skb(parent);
-		if (ktime_after(txtime, skb->tstamp)) {
+		if (ktime_compare(txtime, skb->tstamp) >= 0) {
 			p = &parent->rb_right;
 			leftmost = false;
 		} else {


