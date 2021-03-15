Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCAD433B6AE
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbhCON63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232209AbhCON54 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E93D964F04;
        Mon, 15 Mar 2021 13:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816676;
        bh=p2Qq4GYPioMsa0XKgXrE0A9OR9T7H/RwnkiV9NVLwRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cbf/kPNk025miiqI8iyaa0drecSCQ69DHD12y7O4LrP5tP8qK67fn2hjiU3kHZZeh
         3yjsSaMF2h9Gno32uGyuwZWn0ZLE/F0O9z2JE20Rsp5vFY0grh5ax5LGLl1HT6JLK+
         b/Qgb9l0jFsf5O8cjroLPGaPADULt/vKtT4xQbJ4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 049/290] net: mscc: ocelot: properly reject destination IP keys in VCAP IS1
Date:   Mon, 15 Mar 2021 14:52:22 +0100
Message-Id: <20210315135543.583584863@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
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
 


