Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCFCC499E41
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381845AbiAXWbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584632AbiAXWVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:21:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3588C0424F2;
        Mon, 24 Jan 2022 12:52:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6118FB80FA3;
        Mon, 24 Jan 2022 20:52:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FD2C340E5;
        Mon, 24 Jan 2022 20:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057537;
        bh=cMFAZwDQpgjABQ2Q/fX+54tfhOManCJbXO3VeKI8TMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2vvWIqRpubqotlfqcv3SJ/MD79oDOd85UGZc/k2PLm06TaP7qDi25ninbZrZnqsq+
         OsMNxCyMSsPXi2Ko/G+6bk5YUWN/vf1iSiHCczqtR8vvuxFh5C2YzvrzVkM9fhX3Wh
         ZbvyxrE+bYQ17Z7YJm7VO25nbbnqCZ3gN52uqQS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jussi Maki <joamaki@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, Moshe Tal <moshet@nvidia.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 845/846] bonding: Fix extraction of ports from the packet headers
Date:   Mon, 24 Jan 2022 19:46:02 +0100
Message-Id: <20220124184130.050223021@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Tal <moshet@nvidia.com>

commit 429e3d123d9a50cc9882402e40e0ac912d88cfcf upstream.

Wrong hash sends single stream to multiple output interfaces.

The offset calculation was relative to skb->head, fix it to be relative
to skb->data.

Fixes: a815bde56b15 ("net, bonding: Refactor bond_xmit_hash for use with
xdp_buff")
Reviewed-by: Jussi Maki <joamaki@gmail.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Moshe Tal <moshet@nvidia.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3872,8 +3872,8 @@ u32 bond_xmit_hash(struct bonding *bond,
 	    skb->l4_hash)
 		return skb->hash;
 
-	return __bond_xmit_hash(bond, skb, skb->head, skb->protocol,
-				skb->mac_header, skb->network_header,
+	return __bond_xmit_hash(bond, skb, skb->data, skb->protocol,
+				skb_mac_offset(skb), skb_network_offset(skb),
 				skb_headlen(skb));
 }
 


