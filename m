Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2339133B66F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbhCON5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231916AbhCON5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03DF064F05;
        Mon, 15 Mar 2021 13:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816639;
        bh=8GZ4p3TXLepViQ513HLpLPRkvv5/j8M+HDptTBlUlhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u1sgJLaRyaCIu3PvTJYbMSAuKsTwj9AOcIm8lE6D0N2kDL/g0iKSUEI3bL4o7o2pD
         hWWekJ0ofxB2HjJ1mfTsPvXyU70pcdJYM2HeiNMuwhDGVfye4wJevoTtz+Z1tmoptp
         gjWK6w7xYed8mniGlLxF7Csx9x1ZwRjKgEhCXP9w=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Wiesner <jwiesner@suse.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 035/306] ibmvnic: always store valid MAC address
Date:   Mon, 15 Mar 2021 14:51:38 +0100
Message-Id: <20210315135508.824885507@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Jiri Wiesner <jwiesner@suse.com>

commit 67eb211487f0c993d9f402d1c196ef159fd6a3b5 upstream.

The last change to ibmvnic_set_mac(), 8fc3672a8ad3, meant to prevent
users from setting an invalid MAC address on an ibmvnic interface
that has not been brought up yet. The change also prevented the
requested MAC address from being stored by the adapter object for an
ibmvnic interface when the state of the ibmvnic interface is
VNIC_PROBED - that is after probing has finished but before the
ibmvnic interface is brought up. The MAC address stored by the
adapter object is used and sent to the hypervisor for checking when
an ibmvnic interface is brought up.

The ibmvnic driver ignoring the requested MAC address when in
VNIC_PROBED state caused LACP bonds (bonds in 802.3ad mode) with more
than one slave to malfunction. The bonding code must be able to
change the MAC address of its slaves before they are brought up
during enslaving. The inability of kernels with 8fc3672a8ad3 to set
the MAC addresses of bonding slaves is observable in the output of
"ip address show". The MAC addresses of the slaves are the same as
the MAC address of the bond on a working system whereas the slaves
retain their original MAC addresses on a system with a malfunctioning
LACP bond.

Fixes: 8fc3672a8ad3 ("ibmvnic: fix ibmvnic_set_mac")
Signed-off-by: Jiri Wiesner <jwiesner@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1923,10 +1923,9 @@ static int ibmvnic_set_mac(struct net_de
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	if (adapter->state != VNIC_PROBED) {
-		ether_addr_copy(adapter->mac_addr, addr->sa_data);
+	ether_addr_copy(adapter->mac_addr, addr->sa_data);
+	if (adapter->state != VNIC_PROBED)
 		rc = __ibmvnic_set_mac(netdev, addr->sa_data);
-	}
 
 	return rc;
 }


