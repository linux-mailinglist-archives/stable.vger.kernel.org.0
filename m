Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2667431C4E
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbhJRNkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:40:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233637AbhJRNid (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:38:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40D94610E8;
        Mon, 18 Oct 2021 13:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563927;
        bh=OJJ5bTMNlhWBksduviIDVeHHZl0uEw45tI5803glFK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xJZFwAgAvTpxKwH4avk2GLJxUqE7XRNsRKFnyu7eZcCd5KwWXSZtIbo9hQjoYEEUd
         bnfXKU5UQNzu+PsnhSoSd7Z7SYlHlmerkZslOMks5BLLFl0eXtMA4IsodiTolCTlil
         xIIF3vbKBBOmkDI7lcTgy9vDyXJosIS+Ac5Ht3g4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shannon Nelson <snelson@pensando.io>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 69/69] ionic: dont remove netdev->dev_addr when syncing uc list
Date:   Mon, 18 Oct 2021 15:25:07 +0200
Message-Id: <20211018132331.767350432@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132329.453964125@linuxfoundation.org>
References: <20211018132329.453964125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>

commit 5c976a56570f29aaf4a2f9a1bf99789c252183c9 upstream.

Bridging, and possibly other upper stack gizmos, adds the
lower device's netdev->dev_addr to its own uc list, and
then requests it be deleted when the upper bridge device is
removed.  This delete request also happens with the bridging
vlan_filtering is enabled and then disabled.

Bonding has a similar behavior with the uc list, but since it
also uses set_mac to manage netdev->dev_addr, it doesn't have
the same the failure case.

Because we store our netdev->dev_addr in our uc list, we need
to ignore the delete request from dev_uc_sync so as to not
lose the address and all hope of communicating.  Note that
ndo_set_mac_address is expressly changing netdev->dev_addr,
so no limitation is set there.

Fixes: 2a654540be10 ("ionic: Add Rx filter and rx_mode ndo support")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -912,6 +912,10 @@ static int ionic_addr_add(struct net_dev
 
 static int ionic_addr_del(struct net_device *netdev, const u8 *addr)
 {
+	/* Don't delete our own address from the uc list */
+	if (ether_addr_equal(addr, netdev->dev_addr))
+		return 0;
+
 	return ionic_lif_addr(netdev_priv(netdev), addr, false);
 }
 


