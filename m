Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9D43FDACE
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343588AbhIAMfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:35:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245174AbhIAMeD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:34:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AAAB610C9;
        Wed,  1 Sep 2021 12:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499545;
        bh=ExXHcUQcEnPzayFTARJ+KSvjZgY8S7DqwcUihJu/rwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJUTlXaZCGQn3PiR6RKL7HOU1vx7lv5gKEYsssyiHtBNnDFV/5z2pOl9bg504HOBs
         WEePG/8DKlHDoICEabx88K5fMz0KhXIUjhMLNWQF3OhnZJEg3pEjpuvmZwbsE8R0az
         DSBTnQcSBInmIfNQloqtO1yhHq0JbnfFsp0Th/ZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 41/48] net: dsa: mt7530: fix VLAN traffic leaks again
Date:   Wed,  1 Sep 2021 14:28:31 +0200
Message-Id: <20210901122254.743879558@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122253.388326997@linuxfoundation.org>
References: <20210901122253.388326997@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: DENG Qingfang <dqfext@gmail.com>

commit 7428022b50d0fbb4846dd0f00639ea09d36dff02 upstream.

When a port leaves a VLAN-aware bridge, the current code does not clear
other ports' matrix field bit. If the bridge is later set to VLAN-unaware
mode, traffic in the bridge may leak to that port.

Remove the VLAN filtering check in mt7530_port_bridge_leave.

Fixes: 474a2ddaa192 ("net: dsa: mt7530: fix VLAN traffic leaks")
Fixes: 83163f7dca56 ("net: dsa: mediatek: add VLAN support for MT7530")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mt7530.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -842,11 +842,8 @@ mt7530_port_bridge_leave(struct dsa_swit
 		/* Remove this port from the port matrix of the other ports
 		 * in the same bridge. If the port is disabled, port matrix
 		 * is kept and not being setup until the port becomes enabled.
-		 * And the other port's port matrix cannot be broken when the
-		 * other port is still a VLAN-aware port.
 		 */
-		if (dsa_is_user_port(ds, i) && i != port &&
-		   !dsa_port_is_vlan_filtering(&ds->ports[i])) {
+		if (dsa_is_user_port(ds, i) && i != port) {
 			if (dsa_to_port(ds, i)->bridge_dev != bridge)
 				continue;
 			if (priv->ports[i].enable)


