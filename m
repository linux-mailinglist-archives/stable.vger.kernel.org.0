Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E5733B6BD
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbhCON6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232241AbhCON6A (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2043C64F01;
        Mon, 15 Mar 2021 13:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816680;
        bh=p2Qq4GYPioMsa0XKgXrE0A9OR9T7H/RwnkiV9NVLwRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOsfEpCermotee2PbXAyuYHCuyiGX8HkBscMlp10o48Zg14vLk3Vqx4U7Ybt7A05r
         hDAxCyA+MiHzzWxksRkEP0dhC72eIA8p9IkXYURY1P9B4mkruAXPjuWjThJlRqXW+P
         dfqp8uHbObeWvTtJON5sHWd2agyWGbHuDJRT1pHc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 060/306] net: mscc: ocelot: properly reject destination IP keys in VCAP IS1
Date:   Mon, 15 Mar 2021 14:52:03 +0100
Message-Id: <20210315135509.678873406@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit f1becbed411c6fa29d7ce3def3a1dcd4f63f2d74 upstream.

An attempt is made to warn the user about the fact that VCAP IS1 cannot
offload keys matching on destination IP (at least given the current half
key format), but sadly that warning fails miserably in practice, due to
the fact that it operates on an uninitialized "match" variable. We must
first decode the keys from the flow rule.

Fixes: 75944fda1dfe ("net: mscc: ocelot: offload ingress skbedit and vlan actions to VCAP IS1")
Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mscc/ocelot_flower.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -540,13 +540,14 @@ ocelot_flower_parse_key(struct ocelot *o
 			return -EOPNOTSUPP;
 		}
 
+		flow_rule_match_ipv4_addrs(rule, &match);
+
 		if (filter->block_id == VCAP_IS1 && *(u32 *)&match.mask->dst) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Key type S1_NORMAL cannot match on destination IP");
 			return -EOPNOTSUPP;
 		}
 
-		flow_rule_match_ipv4_addrs(rule, &match);
 		tmp = &filter->key.ipv4.sip.value.addr[0];
 		memcpy(tmp, &match.key->src, 4);
 


