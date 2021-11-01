Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B713C44186A
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbhKAJra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:47:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233361AbhKAJpW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:45:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 945FF61245;
        Mon,  1 Nov 2021 09:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759015;
        bh=H1Q+Mto469tI1JfCZfuNRc2lo8Cufo1dE2p6fPJNXao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0huupRXu9znsF5mefqbT1F4G+weGcfnIyvVVMz13E4dEl4EdpgZzM+9Ff3Ll6nVTw
         XN2AuYzBRhvb28343V3+DI8Ao/jdQaN5RUPCm3LjmAcfkTEE0GpNBYsXVVjSbUkHLt
         6eRobysvY7FiRRVhTaoKPtGhf4y51Dl78Yn9v3IE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Gospodarek <gospo@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 079/125] net: Prevent infinite while loop in skb_tx_hash()
Date:   Mon,  1 Nov 2021 10:17:32 +0100
Message-Id: <20211101082548.180723456@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

commit 0c57eeecc559ca6bc18b8c4e2808bc78dbe769b0 upstream.

Drivers call netdev_set_num_tc() and then netdev_set_tc_queue()
to set the queue count and offset for each TC.  So the queue count
and offset for the TCs may be zero for a short period after dev->num_tc
has been set.  If a TX packet is being transmitted at this time in the
code path netdev_pick_tx() -> skb_tx_hash(), skb_tx_hash() may see
nonzero dev->num_tc but zero qcount for the TC.  The while loop that
keeps looping while hash >= qcount will not end.

Fix it by checking the TC's qcount to be nonzero before using it.

Fixes: eadec877ce9c ("net: Add support for subordinate traffic classes to netdev_pick_tx")
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3246,6 +3246,12 @@ static u16 skb_tx_hash(const struct net_
 
 		qoffset = sb_dev->tc_to_txq[tc].offset;
 		qcount = sb_dev->tc_to_txq[tc].count;
+		if (unlikely(!qcount)) {
+			net_warn_ratelimited("%s: invalid qcount, qoffset %u for tc %u\n",
+					     sb_dev->name, qoffset, tc);
+			qoffset = 0;
+			qcount = dev->real_num_tx_queues;
+		}
 	}
 
 	if (skb_rx_queue_recorded(skb)) {


