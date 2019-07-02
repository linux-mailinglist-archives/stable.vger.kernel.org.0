Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4CA5CB59
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbfGBIHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:07:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727724AbfGBIHa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:07:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1947206A2;
        Tue,  2 Jul 2019 08:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054850;
        bh=gx5vd93f8/k8hXxgW9ILkcK+6s7352CHCW6PXJg7i+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LrZ3vjSbopsbIdxE0/iziCe7UA9xZBdi7uaaaldCqTKwQP2xQ+jq5dRep1tQcS4ri
         S+7iHG0q36Ns5+WQtywvJqQswJYAFbd4Gtl5UMW4t1XEMewgSbh7TRAm+R8g/fQgXu
         d3QnDHzfur+zHylSjR7y0buf+nGBrS8mEY1I/v6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Sowmini Varadhan <sowmini.varadhan@oracle.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 53/72] net/packet: fix memory leak in packet_set_ring()
Date:   Tue,  2 Jul 2019 10:01:54 +0200
Message-Id: <20190702080127.333607089@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
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
@@ -4316,7 +4316,7 @@ static int packet_set_ring(struct sock *
 				    req3->tp_sizeof_priv ||
 				    req3->tp_feature_req_word) {
 					err = -EINVAL;
-					goto out;
+					goto out_free_pg_vec;
 				}
 			}
 			break;
@@ -4380,6 +4380,7 @@ static int packet_set_ring(struct sock *
 			prb_shutdown_retire_blk_timer(po, rb_queue);
 	}
 
+out_free_pg_vec:
 	if (pg_vec)
 		free_pg_vec(pg_vec, order, req->tp_block_nr);
 out:


