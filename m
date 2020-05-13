Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6131D0E4D
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387951AbgEMJx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:53:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387949AbgEMJx1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:53:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85EB820753;
        Wed, 13 May 2020 09:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363607;
        bh=5m7kQVIn3ABU5S27QHa+70ddN/AuJ4o58qU92xoL8FU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZMa6B3FQIOsnxFD7TPXmsKC7y0eSAk0DamP7g9dhPxGLdwGnw7VHgWpPtSBYx5B2P
         Kv9Qh3I91asDtAp/FvgxNmDzrKFfbnfDuxbMmCyvbtlYXLPjGp6mxehFGdQOXt8J+Z
         aZ9qQGfy/8ZWdJajbbQVr4xbBANpp+mX/kcZ4Xqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sultan Alsawaf <sultan@kerneltoast.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 052/118] wireguard: queueing: cleanup ptr_ring in error path of packet_queue_init
Date:   Wed, 13 May 2020 11:44:31 +0200
Message-Id: <20200513094421.677186726@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit 130c58606171326c81841a49cc913cd354113dd9 ]

Prior, if the alloc_percpu of packet_percpu_multicore_worker_alloc
failed, the previously allocated ptr_ring wouldn't be freed. This commit
adds the missing call to ptr_ring_cleanup in the error case.

Reported-by: Sultan Alsawaf <sultan@kerneltoast.com>
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/queueing.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireguard/queueing.c
+++ b/drivers/net/wireguard/queueing.c
@@ -35,8 +35,10 @@ int wg_packet_queue_init(struct crypt_qu
 		if (multicore) {
 			queue->worker = wg_packet_percpu_multicore_worker_alloc(
 				function, queue);
-			if (!queue->worker)
+			if (!queue->worker) {
+				ptr_ring_cleanup(&queue->ring, NULL);
 				return -ENOMEM;
+			}
 		} else {
 			INIT_WORK(&queue->work, function);
 		}


