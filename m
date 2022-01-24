Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B174999C7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377150AbiAXVhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:37:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447539AbiAXVK5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:10:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3219CC09D32A;
        Mon, 24 Jan 2022 12:09:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA7D1B8122C;
        Mon, 24 Jan 2022 20:09:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA89C340E5;
        Mon, 24 Jan 2022 20:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054944;
        bh=Asg+7LepYHNGSHDvbNOVUOCVw+w7ba8PdA/sQW8ZIuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Z1jHidpspH3FYrc3AOg7VfQ4IqayJ+8OOQVilSA63hRaZKVAi2YyBjkVNPgS/4+T
         met1ag8czJIWef85O6vP/mnkQbzSjmKcekIvnD9qlYP5sbGKT12TTkTuVlvErkC/4S
         ALFmsf7F3Lzm7mFv13cispONCBE1FKzamr8wENvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 554/563] net: mscc: ocelot: fix using match before it is set
Date:   Mon, 24 Jan 2022 19:45:19 +0100
Message-Id: <20220124184043.599259878@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
@@ -462,13 +462,6 @@ ocelot_flower_parse_key(struct ocelot *o
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
@@ -483,6 +476,14 @@ ocelot_flower_parse_key(struct ocelot *o
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


