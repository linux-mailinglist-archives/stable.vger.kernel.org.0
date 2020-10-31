Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A47B72A1613
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbgJaLlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:41:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727667AbgJaLlc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:41:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7044820719;
        Sat, 31 Oct 2020 11:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144492;
        bh=Wxa7DhW0uD+3FUQhI/nT+ieV5bbbEKZ/4SFx4QhWt6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UhI5jCFSbJgL2AWyVSCbK2lNQyHPQiFp8aBuMtgUNfCBupuBX6BYJJbrfAmERhqKB
         H9llufWQztPipQDWjuBHAflazcZvaxJ/zB/5axIPVQCHOjRtxDhTnAbYk2q7rU57LH
         q92K5uGlkh7XV77GHSlO/gaJuTjdI286WJBOEAwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Pan <ljp@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 38/70] ibmvnic: fix ibmvnic_set_mac
Date:   Sat, 31 Oct 2020 12:36:10 +0100
Message-Id: <20201031113501.322314981@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Pan <ljp@linux.ibm.com>

[ Upstream commit 8fc3672a8ad3e782bac80e979bc2a2c10960cbe9 ]

Jakub Kicinski brought up a concern in ibmvnic_set_mac().
ibmvnic_set_mac() does this:

	ether_addr_copy(adapter->mac_addr, addr->sa_data);
	if (adapter->state != VNIC_PROBED)
		rc = __ibmvnic_set_mac(netdev, addr->sa_data);

So if state == VNIC_PROBED, the user can assign an invalid address to
adapter->mac_addr, and ibmvnic_set_mac() will still return 0.

The fix is to validate ethernet address at the beginning of
ibmvnic_set_mac(), and move the ether_addr_copy to
the case of "adapter->state != VNIC_PROBED".

Fixes: c26eba03e407 ("ibmvnic: Update reset infrastructure to support tunable parameters")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
Link: https://lore.kernel.org/r/20201027220456.71450-1-ljp@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1828,9 +1828,13 @@ static int ibmvnic_set_mac(struct net_de
 	int rc;
 
 	rc = 0;
-	ether_addr_copy(adapter->mac_addr, addr->sa_data);
-	if (adapter->state != VNIC_PROBED)
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
+
+	if (adapter->state != VNIC_PROBED) {
+		ether_addr_copy(adapter->mac_addr, addr->sa_data);
 		rc = __ibmvnic_set_mac(netdev, addr->sa_data);
+	}
 
 	return rc;
 }


