Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB693E25B6
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243990AbhHFIWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:22:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244106AbhHFIUI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:20:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5204D61212;
        Fri,  6 Aug 2021 08:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237990;
        bh=J6uoLnHVZRVH/EQko5/ekow/TIAlnuGZDg5TfS16leE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=104d9NhGkx+Q0DW0mkGs2/q3uxaDD1aW/G/oBj0gXLWTJengxMBuH7inQMeHH8gGR
         kJvFXhCJbLLfLGQLKHXBgQIfwEUYafX/N4R2U6MQ0nlDzhNw9vCJR1AEBnI/ii9CYZ
         BoWNLcu9PpfkHMZGUVB39y7PH9bt2+k/b4pExidU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 10/35] net: dsa: sja1105: fix address learning getting disabled on the CPU port
Date:   Fri,  6 Aug 2021 10:16:53 +0200
Message-Id: <20210806081114.046174410@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.718626745@linuxfoundation.org>
References: <20210806081113.718626745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit b0b33b048dcfbd7da82c3cde4fab02751dfab4d6 ]

In May 2019 when commit 640f763f98c2 ("net: dsa: sja1105: Add support
for Spanning Tree Protocol") was introduced, the comment that "STP does
not get called for the CPU port" was true. This changed after commit
0394a63acfe2 ("net: dsa: enable and disable all ports") in August 2019
and went largely unnoticed, because the sja1105_bridge_stp_state_set()
method did nothing different compared to the static setup done by
sja1105_init_mac_settings().

With the ability to turn address learning off introduced by the blamed
commit, there is a new priv->learn_ena port mask in the driver. When
sja1105_bridge_stp_state_set() gets called and we are in
BR_STATE_LEARNING or later, address learning is enabled or not depending
on priv->learn_ena & BIT(port).

So what happens is that priv->learn_ena is not being set from anywhere
for the CPU port, and the static configuration done by
sja1105_init_mac_settings() is being overwritten.

To solve this, acknowledge that the static configuration of STP state is
no longer necessary because the STP state is being set by the DSA core
now, but what is necessary is to set priv->learn_ena for the CPU port.

Fixes: 4d9423549501 ("net: dsa: sja1105: offload bridge port flags to device")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index ebb6966eba8e..5b7947832b87 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -130,14 +130,12 @@ static int sja1105_init_mac_settings(struct sja1105_private *priv)
 
 	for (i = 0; i < ds->num_ports; i++) {
 		mac[i] = default_mac;
-		if (i == dsa_upstream_port(priv->ds, i)) {
-			/* STP doesn't get called for CPU port, so we need to
-			 * set the I/O parameters statically.
-			 */
-			mac[i].dyn_learn = true;
-			mac[i].ingress = true;
-			mac[i].egress = true;
-		}
+
+		/* Let sja1105_bridge_stp_state_set() keep address learning
+		 * enabled for the CPU port.
+		 */
+		if (dsa_is_cpu_port(ds, i))
+			priv->learn_ena |= BIT(i);
 	}
 
 	return 0;
-- 
2.30.2



