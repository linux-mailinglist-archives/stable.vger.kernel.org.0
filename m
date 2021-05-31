Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E30395E74
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbhEaN64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:58:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:32912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232754AbhEaN4v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:56:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C86D6613F6;
        Mon, 31 May 2021 13:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468092;
        bh=nSzoqu+NssTticyvB1cXi2h4UsL4r0RVT9Va9UZIwcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A7iq2VmTbfRB7YEvU8D8yAKeXR6Fb9RHF9XJiAjdsCpvM6NsuiOQS9P+OzXKRU77U
         nLhFhYN+r9bUSHJZymmlTITnSADkz8HmOXOIXACh8qhwX3BqylsqqErCpAxv05gYpX
         1r73rFg2QwG80E8uKQq9ieO7J8STEXh0re4dyCWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 112/252] net: dsa: mt7530: fix VLAN traffic leaks
Date:   Mon, 31 May 2021 15:12:57 +0200
Message-Id: <20210531130701.777457173@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
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
@@ -1128,14 +1128,6 @@ mt7530_port_set_vlan_aware(struct dsa_sw
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


