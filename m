Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE4B1CAEC6
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbgEHMrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:47:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729587AbgEHMrq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:47:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07023221F7;
        Fri,  8 May 2020 12:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942066;
        bh=YraofylXLPuAdEuUBvMoUNOnCgiq6OQ36ul0xoP7O/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cGbwxQJzOR15Dk4LRhzv80WlpamrZx8u6BP04ihPrJmOv9g7HyOEk/fBQa00Qj+e5
         8DHMmkyJATMmyimlYfl8lPhjmEi+QyGXYlr3/AUmNw3MOnxNV0s+zizyMtDf+T79MA
         rev0IUmtQKs1aVLJHORhOdkW/dv4jjN773FPux+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 284/312] l2tp: fix use-after-free during module unload
Date:   Fri,  8 May 2020 14:34:35 +0200
Message-Id: <20200508123144.376454291@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

commit 2f86953e7436c9b9a4690909c5e2db24799e173b upstream.

Tunnel deletion is delayed by both a workqueue (l2tp_tunnel_delete -> wq
 -> l2tp_tunnel_del_work) and RCU (sk_destruct -> RCU ->
l2tp_tunnel_destruct).

By the time l2tp_tunnel_destruct() runs to destroy the tunnel and finish
destroying the socket, the private data reserved via the net_generic
mechanism has already been freed, but l2tp_tunnel_destruct() actually
uses this data.

Make sure tunnel deletion for the netns has completed before returning
from l2tp_exit_net() by first flushing the tunnel removal workqueue, and
then waiting for RCU callbacks to complete.

Fixes: 167eb17e0b17 ("l2tp: create tunnel sockets in the right namespace")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/l2tp/l2tp_core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1953,6 +1953,9 @@ static __net_exit void l2tp_exit_net(str
 		l2tp_tunnel_delete(tunnel);
 	}
 	rcu_read_unlock_bh();
+
+	flush_workqueue(l2tp_wq);
+	rcu_barrier();
 }
 
 static struct pernet_operations l2tp_net_ops = {


