Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C938EF56A7
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391091AbfKHTKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:10:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:42230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390558AbfKHTKH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:10:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD61A2087E;
        Fri,  8 Nov 2019 19:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240206;
        bh=YhMzm4NgSEM2VlaCR0suJJCJG7KofwFCLJtHo+JQlgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uWF8kh/s8lRXGRNio2rqmwBwPSDoeOXY1g7ePzHCEZfomViinFNVZKyB9tGO72yoD
         DjPRbt9aiP0j4ike6r7C1Z//drn+Q+ZOKVeATgsdTnHlnph/1b5D18GajLG2qjnhX2
         5hrmwbrLOgijSBJnFaK/zPB8rmC9fu5h2y13FHcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 126/140] net: netem: fix error path for corrupted GSO frames
Date:   Fri,  8 Nov 2019 19:50:54 +0100
Message-Id: <20191108174912.631787150@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit a7fa12d15855904aff1716e1fc723c03ba38c5cc ]

To corrupt a GSO frame we first perform segmentation.  We then
proceed using the first segment instead of the full GSO skb and
requeue the rest of the segments as separate packets.

If there are any issues with processing the first segment we
still want to process the rest, therefore we jump to the
finish_segs label.

Commit 177b8007463c ("net: netem: fix backlog accounting for
corrupted GSO frames") started using the pointer to the first
segment in the "rest of segments processing", but as mentioned
above the first segment may had already been freed at this point.

Backlog corrections for parent qdiscs have to be adjusted.

Fixes: 177b8007463c ("net: netem: fix backlog accounting for corrupted GSO frames")
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_netem.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -509,6 +509,7 @@ static int netem_enqueue(struct sk_buff
 		if (skb->ip_summed == CHECKSUM_PARTIAL &&
 		    skb_checksum_help(skb)) {
 			qdisc_drop(skb, sch, to_free);
+			skb = NULL;
 			goto finish_segs;
 		}
 
@@ -593,9 +594,10 @@ static int netem_enqueue(struct sk_buff
 finish_segs:
 	if (segs) {
 		unsigned int len, last_len;
-		int nb = 0;
+		int nb;
 
-		len = skb->len;
+		len = skb ? skb->len : 0;
+		nb = skb ? 1 : 0;
 
 		while (segs) {
 			skb2 = segs->next;
@@ -612,7 +614,8 @@ finish_segs:
 			}
 			segs = skb2;
 		}
-		qdisc_tree_reduce_backlog(sch, -nb, prev_len - len);
+		/* Parent qdiscs accounted for 1 skb of size @prev_len */
+		qdisc_tree_reduce_backlog(sch, -(nb - 1), -(len - prev_len));
 	}
 	return NET_XMIT_SUCCESS;
 }


