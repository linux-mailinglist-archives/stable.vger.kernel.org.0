Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F01144169C
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbhKAJ1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:27:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232502AbhKAJY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:24:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DBBE611C7;
        Mon,  1 Nov 2021 09:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758503;
        bh=ZK86WI+eOdidgSAEYew7NOQz3EXb8KIE1nGckZK2JQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=otQ9HwUfElgN3eizoTGrpyq3L/2NM6JSKFz15aLUqzImFXChjGFmbSx6vYyH3BRrq
         4XjqFFgcvEee4XowewtnGRqiBj1PawES8bp7njsJkEgqh3kV0jp8e7ZwMp8FyOi3nb
         nN+IX1AtQVjTQ/ek3EQiC7KUEULYNqqGkYPHr52Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Gospodarek <gospo@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 26/35] net: Prevent infinite while loop in skb_tx_hash()
Date:   Mon,  1 Nov 2021 10:17:38 +0100
Message-Id: <20211101082457.871170890@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082451.430720900@linuxfoundation.org>
References: <20211101082451.430720900@linuxfoundation.org>
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
@@ -2846,6 +2846,12 @@ static u16 skb_tx_hash(const struct net_
 
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


