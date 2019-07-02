Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C10E95CB35
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbfGBILx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:11:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727542AbfGBIJp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:09:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C000A20665;
        Tue,  2 Jul 2019 08:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054985;
        bh=xDodtIMsKPm6YhLyrC/CzznVosZQjbuw83e+gldJATs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DRtgOtqTN2RJhAg1Zcm4230P2nv+6AglZLjFzjLhoQZ6pCrhXjLTqS1198MCKAY1k
         8SipTZt+Q0leU2mp4+k6ukWq5WMcJJtedJgZfQF6fXA+G40L5ymxetn9kwkhmbNz+g
         LGwKgFfRQ8rE0lZHF+gVzBflE6UOMosifd0ujknA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Sowmini Varadhan <sowmini.varadhan@oracle.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 29/43] net/packet: fix memory leak in packet_set_ring()
Date:   Tue,  2 Jul 2019 10:02:09 +0200
Message-Id: <20190702080125.364407469@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080123.904399496@linuxfoundation.org>
References: <20190702080123.904399496@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 55655e3d1197fff16a7a05088fb0e5eba50eac55 ]

syzbot found we can leak memory in packet_set_ring(), if user application
provides buggy parameters.

Fixes: 7f953ab2ba46 ("af_packet: TX_RING support for TPACKET_V3")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4354,7 +4354,7 @@ static int packet_set_ring(struct sock *
 				    req3->tp_sizeof_priv ||
 				    req3->tp_feature_req_word) {
 					err = -EINVAL;
-					goto out;
+					goto out_free_pg_vec;
 				}
 			}
 			break;
@@ -4418,6 +4418,7 @@ static int packet_set_ring(struct sock *
 			prb_shutdown_retire_blk_timer(po, rb_queue);
 	}
 
+out_free_pg_vec:
 	if (pg_vec)
 		free_pg_vec(pg_vec, order, req->tp_block_nr);
 out:


