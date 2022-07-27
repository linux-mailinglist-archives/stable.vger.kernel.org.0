Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58D658307F
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242618AbiG0Riy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242638AbiG0RiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:38:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B9D87233;
        Wed, 27 Jul 2022 09:50:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4716561700;
        Wed, 27 Jul 2022 16:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BF5C433D6;
        Wed, 27 Jul 2022 16:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940628;
        bh=ZuA+typshrCmrsRBPWqRteM1Ok9S+840Vcu8naMnhHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aeCA4e2KrTGqMp2F2A+KY11XdaM1SZrJ77zLW4pEruPMCDD39sB1Ogw3ItqcDkWfl
         4C6fScv/MwvKlFGUmM1DmgCO8a3j3lKxpK29zUUvDySx12lxsHZTiOa9WZzzNCFhBQ
         qF/OJUNaE6d8ucg5UKCb+CnFere9Ebwx+wuN4IxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucian Banu <Lucian.Banu@westermo.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 091/158] net: dsa: fix dsa_port_vlan_filtering when global
Date:   Wed, 27 Jul 2022 18:12:35 +0200
Message-Id: <20220727161025.117414644@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 4db2a5ef4ccbe6d138828284cfab241b434b5d95 ]

The blamed refactoring commit changed a "port" iterator with "other_dp",
but still looked at the slave_dev of the dp outside the loop, instead of
other_dp->slave from the loop.

As a result, dsa_port_vlan_filtering() would not call
dsa_slave_manage_vlan_filtering() except for the port in cause, and not
for all switch ports as expected.

Fixes: d0004a020bb5 ("net: dsa: remove the "dsa_to_port in a loop" antipattern from the core")
Reported-by: Lucian Banu <Lucian.Banu@westermo.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/port.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index bdccb613285d..4b72513cc9e4 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -752,7 +752,7 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 		ds->vlan_filtering = vlan_filtering;
 
 		dsa_switch_for_each_user_port(other_dp, ds) {
-			struct net_device *slave = dp->slave;
+			struct net_device *slave = other_dp->slave;
 
 			/* We might be called in the unbind path, so not
 			 * all slave devices might still be registered.
-- 
2.35.1



