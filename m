Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 191E632C94
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbfFCJKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:10:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728057AbfFCJKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:10:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCB5027E2B;
        Mon,  3 Jun 2019 09:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553020;
        bh=NpyuSjHPPTnpSP0X4aCapNlrtqaQK/xT3HA/UKqCRs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QUyt22Oh0bglIQJxLTfEffteLvm43fac6mZlN0Lnu1UMo0ggU1k4gOXXrCoJa1pqs
         +zAGp10blYW3TiGHcj/NURQynD9JIou1mWQfpA53g1TglDmn1oKqDUY6mj2lT1q8Fr
         jvlI+1gWct4WzW1E2VT0H1NPQHf6mx5juMyRh7F4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 24/32] net/tls: fix state removal with feature flags off
Date:   Mon,  3 Jun 2019 11:08:18 +0200
Message-Id: <20190603090315.200642387@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090308.472021390@linuxfoundation.org>
References: <20190603090308.472021390@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 3686637e507b48525fcea6fb91e1988bdbc14530 ]

TLS offload drivers shouldn't (and currently don't) block
the TLS offload feature changes based on whether there are
active offloaded connections or not.

This seems to be a good idea, because we want the admin to
be able to disable the TLS offload at any time, and there
is no clean way of disabling it for active connections
(TX side is quite problematic).  So if features are cleared
existing connections will stay offloaded until they close,
and new connections will not attempt offload to a given
device.

However, the offload state removal handling is currently
broken if feature flags get cleared while there are
active TLS offloads.

RX side will completely bail from cleanup, even on normal
remove path, leaving device state dangling, potentially
causing issues when the 5-tuple is reused.  It will also
fail to release the netdev reference.

Remove the RX-side warning message, in next release cycle
it should be printed when features are disabled, rather
than when connection dies, but for that we need a more
efficient method of finding connection of a given netdev
(a'la BPF offload code).

Fixes: 4799ac81e52a ("tls: Add rx inline crypto offload")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_device.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -916,12 +916,6 @@ void tls_device_offload_cleanup_rx(struc
 	if (!netdev)
 		goto out;
 
-	if (!(netdev->features & NETIF_F_HW_TLS_RX)) {
-		pr_err_ratelimited("%s: device is missing NETIF_F_HW_TLS_RX cap\n",
-				   __func__);
-		goto out;
-	}
-
 	netdev->tlsdev_ops->tls_dev_del(netdev, tls_ctx,
 					TLS_OFFLOAD_CTX_DIR_RX);
 


