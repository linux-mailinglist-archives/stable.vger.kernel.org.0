Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF4701A0B1A
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgDGKXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:23:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:33626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728550AbgDGKXo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:23:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 107E22082D;
        Tue,  7 Apr 2020 10:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255023;
        bh=kRAFIVrOFJYN7K1JCfavhQ9CnsGKo7eEipc5+stHJdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aa7XoNdIYpdNyH8tF4SX9ADB5LccI0xnup7RZqUEFEiiHB5VZWe6HA8F+qYhFDYp8
         vBIkXJOkaoCidsGYFDqoOER8DI0loeHDepgEyALZl/re3SiYwv7Or/QCH6ow1esgfv
         2HGyRXV7HKjcNoEvofTbOoeClb+HXWPeJiRXuPeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 35/36] net: Fix Tx hash bound checking
Date:   Tue,  7 Apr 2020 12:22:08 +0200
Message-Id: <20200407101458.682372081@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101454.281052964@linuxfoundation.org>
References: <20200407101454.281052964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amritha Nambiar <amritha.nambiar@intel.com>

commit 6e11d1578fba8d09d03a286740ffcf336d53928c upstream.

Fixes the lower and upper bounds when there are multiple TCs and
traffic is on the the same TC on the same device.

The lower bound is represented by 'qoffset' and the upper limit for
hash value is 'qcount + qoffset'. This gives a clean Rx to Tx queue
mapping when there are multiple TCs, as the queue indices for upper TCs
will be offset by 'qoffset'.

v2: Fixed commit description based on comments.

Fixes: 1b837d489e06 ("net: Revoke export for __skb_tx_hash, update it to just be static skb_tx_hash")
Fixes: eadec877ce9c ("net: Add support for subordinate traffic classes to netdev_pick_tx")
Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/dev.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2795,6 +2795,8 @@ static u16 skb_tx_hash(const struct net_
 
 	if (skb_rx_queue_recorded(skb)) {
 		hash = skb_get_rx_queue(skb);
+		if (hash >= qoffset)
+			hash -= qoffset;
 		while (unlikely(hash >= qcount))
 			hash -= qcount;
 		return hash + qoffset;


