Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252B92A16B5
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbgJaLoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:44:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727119AbgJaLob (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:44:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65AA620739;
        Sat, 31 Oct 2020 11:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144670;
        bh=/eWSMNuw7hAI76MfM3ORRrqREp2ulmo2HGI74xNA2bA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVj7AQKzMaB4sU+gNOEDBaebvthwc2Jv5DT+0waBShwjgK9uB6xSw0Iha9wUHYROt
         gSJ0NxC6sGuvHsGzJKolg9gim/lN7oyO/GwYmsYFbaRQnVlRvmYu4HLWkcVRry3sNf
         AQ/Ks9wvzbmQQUtxy9jZewtsKNKXRoDn26MfZShA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 37/74] ibmveth: Fix use of ibmveth in a bridge.
Date:   Sat, 31 Oct 2020 12:36:19 +0100
Message-Id: <20201031113501.823280545@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

[ Upstream commit 2ac8af0967aaa2b67cb382727e784900d2f4d0da ]

The check for src mac address in ibmveth_is_packet_unsupported is wrong.
Commit 6f2275433a2f wanted to shut down messages for loopback packets,
but now suppresses bridged frames, which are accepted by the hypervisor
otherwise bridging won't work at all.

Fixes: 6f2275433a2f ("ibmveth: Detect unsupported packets before sending to the hypervisor")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Link: https://lore.kernel.org/r/20201026104221.26570-1-msuchanek@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmveth.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1031,12 +1031,6 @@ static int ibmveth_is_packet_unsupported
 		ret = -EOPNOTSUPP;
 	}
 
-	if (!ether_addr_equal(ether_header->h_source, netdev->dev_addr)) {
-		netdev_dbg(netdev, "source packet MAC address does not match veth device's, dropping packet.\n");
-		netdev->stats.tx_dropped++;
-		ret = -EOPNOTSUPP;
-	}
-
 	return ret;
 }
 


