Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F0449A40C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371213AbiAYAHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2365244AbiAXXud (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:50:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B83C0BD137;
        Mon, 24 Jan 2022 13:44:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE7A0B811FB;
        Mon, 24 Jan 2022 21:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B27C340E4;
        Mon, 24 Jan 2022 21:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060656;
        bh=8BwMz/lVkIQoaU4oqrABV29zgT16dVE3kgd8cvvmA8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xvkQmoT70hcF7BfRT41jJeE8VCKsgfYTnXcxMIQRFjFP9AOCN2KkgHurYY555YX03
         g26FiuVPkbEjjlc6eESdSPnwpQLk9PyyaiMKMcWrCz1z+HDeKq5SNKOD6f0iZcXHTu
         nfiakTZxMMXurPOJSTUTE7kEGmFDR+tGWdTV60Q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 1021/1039] net: mscc: ocelot: fix using match before it is set
Date:   Mon, 24 Jan 2022 19:46:50 +0100
Message-Id: <20220124184159.618850150@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

commit baa59504c1cd0cca7d41954a45ee0b3dc78e41a0 upstream.

Clang static analysis reports this issue
ocelot_flower.c:563:8: warning: 1st function call argument
  is an uninitialized value
    !is_zero_ether_addr(match.mask->dst)) {
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The variable match is used before it is set.  So move the
block.

Fixes: 75944fda1dfe ("net: mscc: ocelot: offload ingress skbedit and vlan actions to VCAP IS1")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mscc/ocelot_flower.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -521,13 +521,6 @@ ocelot_flower_parse_key(struct ocelot *o
 			return -EOPNOTSUPP;
 		}
 
-		if (filter->block_id == VCAP_IS1 &&
-		    !is_zero_ether_addr(match.mask->dst)) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Key type S1_NORMAL cannot match on destination MAC");
-			return -EOPNOTSUPP;
-		}
-
 		/* The hw support mac matches only for MAC_ETYPE key,
 		 * therefore if other matches(port, tcp flags, etc) are added
 		 * then just bail out
@@ -542,6 +535,14 @@ ocelot_flower_parse_key(struct ocelot *o
 			return -EOPNOTSUPP;
 
 		flow_rule_match_eth_addrs(rule, &match);
+
+		if (filter->block_id == VCAP_IS1 &&
+		    !is_zero_ether_addr(match.mask->dst)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Key type S1_NORMAL cannot match on destination MAC");
+			return -EOPNOTSUPP;
+		}
+
 		filter->key_type = OCELOT_VCAP_KEY_ETYPE;
 		ether_addr_copy(filter->key.etype.dmac.value,
 				match.key->dst);


