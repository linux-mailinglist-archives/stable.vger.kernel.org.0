Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1252E586AA4
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234689AbiHAMTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234277AbiHAMTG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:19:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F60541D22;
        Mon,  1 Aug 2022 04:59:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D56B9B810A2;
        Mon,  1 Aug 2022 11:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421B7C433C1;
        Mon,  1 Aug 2022 11:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355184;
        bh=kEWNh5s559gADhfV8Rv7aum1MxgKxuQ87EdsTHhgQLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkvuuynnDJ3A8W/WcB94/aGXi/0eazIW9CsVL9wd97pHHY4NNiR0luLd7ph99iV9z
         UTcfbgLUhzb7SA4HXir+aF7ot8bGUykX3X6HtjUkTBCuj3AszXcjLgWyjYrOcaKpNf
         /wVJFETRd0xzxehZJM2pCoE0TeOZM+cbXRy9yIw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 66/88] net: dsa: fix reference counting for LAG FDBs
Date:   Mon,  1 Aug 2022 13:47:20 +0200
Message-Id: <20220801114141.068425530@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
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

[ Upstream commit c7560d1203b7a1ea0b99a5c575547e95d564b2a8 ]

Due to an invalid conflict resolution on my side while working on 2
different series (LAG FDBs and FDB isolation), dsa_switch_do_lag_fdb_add()
does not store the database associated with a dsa_mac_addr structure.

So after adding an FDB entry associated with a LAG, dsa_mac_addr_find()
fails to find it while deleting it, because &a->db is zeroized memory
for all stored FDB entries of lag->fdbs, and dsa_switch_do_lag_fdb_del()
returns -ENOENT rather than deleting the entry.

Fixes: c26933639b54 ("net: dsa: request drivers to perform FDB isolation")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20220723012411.1125066-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/switch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index d8a80cf9742c..52f84ea349d2 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -363,6 +363,7 @@ static int dsa_switch_do_lag_fdb_add(struct dsa_switch *ds, struct dsa_lag *lag,
 
 	ether_addr_copy(a->addr, addr);
 	a->vid = vid;
+	a->db = db;
 	refcount_set(&a->refcount, 1);
 	list_add_tail(&a->list, &lag->fdbs);
 
-- 
2.35.1



