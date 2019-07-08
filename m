Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D089D62153
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732309AbfGHPPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:15:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732307AbfGHPPS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:15:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93FAC216F4;
        Mon,  8 Jul 2019 15:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562598918;
        bh=qHMiyzD3NSictxhW3ptpV7ID5WhsyxLiRKcaXoJTaTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Bi+LY6JycLqrKQXQuzT5VQvnuVABXCdH6EXPxro9h1rEOrg9MukEyv45pMxudytf
         wEu32z7A5UoxdGLOpUW3ZAlIfvVsVxNM/mO2u1xoIC09V3qMYz2i4MzkRDaqLYGNr+
         OCDUjWQMXa/apZSL1BslpsBbv0J3YnEq2xxdlQSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandra Winter <wintera@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 17/73] s390/qeth: fix VLAN attribute in bridge_hostnotify udev event
Date:   Mon,  8 Jul 2019 17:12:27 +0200
Message-Id: <20190708150520.387956214@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 335726195e460cb6b3f795b695bfd31f0ea70ef0 ]

Enabling sysfs attribute bridge_hostnotify triggers a series of udev events
for the MAC addresses of all currently connected peers. In case no VLAN is
set for a peer, the device reports the corresponding MAC addresses with
VLAN ID 4096. This currently results in attribute VLAN=4096 for all
non-VLAN interfaces in the initial series of events after host-notify is
enabled.

Instead, no VLAN attribute should be reported in the udev event for
non-VLAN interfaces.

Only the initial events face this issue. For dynamic changes that are
reported later, the device uses a validity flag.

This also changes the code so that it now sets the VLAN attribute for
MAC addresses with VID 0. On Linux, no qeth interface will ever be
registered with VID 0: Linux kernel registers VID 0 on all network
interfaces initially, but qeth will drop .ndo_vlan_rx_add_vid for VID 0.
Peers with other OSs could register MACs with VID 0.

Fixes: 9f48b9db9a22 ("qeth: bridgeport support - address notifications")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_l2_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 34d3b7aff513..22045e7d78ac 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -2112,7 +2112,7 @@ static void qeth_bridgeport_an_set_cb(void *priv,
 
 	l2entry = (struct qdio_brinfo_entry_l2 *)entry;
 	code = IPA_ADDR_CHANGE_CODE_MACADDR;
-	if (l2entry->addr_lnid.lnid)
+	if (l2entry->addr_lnid.lnid < VLAN_N_VID)
 		code |= IPA_ADDR_CHANGE_CODE_VLANID;
 	qeth_bridge_emit_host_event(card, anev_reg_unreg, code,
 		(struct net_if_token *)&l2entry->nit,
-- 
2.20.1



