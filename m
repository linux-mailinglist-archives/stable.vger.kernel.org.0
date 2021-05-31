Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF934396036
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbhEaOX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:23:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233628AbhEaOV1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:21:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDDC5619BF;
        Mon, 31 May 2021 13:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468669;
        bh=GUODRiWqg3MYqh5/IXV3dxuuz9MocSFhxMZE7BRIUzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ls6bxQQAELxclarN6Ae2G/Ojv/rIKv51g5fyKpDSYq3XM+6FurVA+S/OJMKBMPrtZ
         Ug2CVX6nYXwWmLqEmfXVQJIuMneB4n05c7Mni4f8yi3b6pty4lqk2KNyAe4Xc7aARg
         Uvb275JdBBRUFM8ZMgJop5BnA0qlinRJZYOUcdfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 079/177] net: dsa: mt7530: fix VLAN traffic leaks
Date:   Mon, 31 May 2021 15:13:56 +0200
Message-Id: <20210531130650.634211903@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: DENG Qingfang <dqfext@gmail.com>

commit 474a2ddaa192777522a7499784f1d60691cd831a upstream.

PCR_MATRIX field was set to all 1's when VLAN filtering is enabled, but
was not reset when it is disabled, which may cause traffic leaks:

	ip link add br0 type bridge vlan_filtering 1
	ip link add br1 type bridge vlan_filtering 1
	ip link set swp0 master br0
	ip link set swp1 master br1
	ip link set br0 type bridge vlan_filtering 0
	ip link set br1 type bridge vlan_filtering 0
	# traffic in br0 and br1 will start leaking to each other

As port_bridge_{add,del} have set up PCR_MATRIX properly, remove the
PCR_MATRIX write from mt7530_port_set_vlan_aware.

Fixes: 83163f7dca56 ("net: dsa: mediatek: add VLAN support for MT7530")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mt7530.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -809,14 +809,6 @@ mt7530_port_set_vlan_aware(struct dsa_sw
 {
 	struct mt7530_priv *priv = ds->priv;
 
-	/* The real fabric path would be decided on the membership in the
-	 * entry of VLAN table. PCR_MATRIX set up here with ALL_MEMBERS
-	 * means potential VLAN can be consisting of certain subset of all
-	 * ports.
-	 */
-	mt7530_rmw(priv, MT7530_PCR_P(port),
-		   PCR_MATRIX_MASK, PCR_MATRIX(MT7530_ALL_MEMBERS));
-
 	/* Trapped into security mode allows packet forwarding through VLAN
 	 * table lookup. CPU port is set to fallback mode to let untagged
 	 * frames pass through.


