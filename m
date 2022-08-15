Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86CEF593C4E
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346963AbiHOUXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347285AbiHOUWL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:22:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760C22C117;
        Mon, 15 Aug 2022 12:02:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10EE461211;
        Mon, 15 Aug 2022 19:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF85C433D6;
        Mon, 15 Aug 2022 19:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590119;
        bh=NENwG24tRUGPMj966BjJSCeyj20BLt/3D87ptVQFGCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z4HI2yUA8G/TaQylka42NWRHIlc1EUsRYW1qQ2w7COlBsuW0me5Gv50hFEv+vblDD
         vwN0AgUMjK1mp5J9tOJCiv7t8C6Fggb3f2MsQZ05NOCI1yrmLPCxG9uqHeo45wzhJM
         dsuhEOzaGhHZ1qH0yXulRaskbcabHozXpEjRlrvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.18 0130/1095] netfilter: nf_tables: do not allow SET_ID to refer to another table
Date:   Mon, 15 Aug 2022 19:52:09 +0200
Message-Id: <20220815180434.957432855@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

commit 470ee20e069a6d05ae549f7d0ef2bdbcee6a81b2 upstream.

When doing lookups for sets on the same batch by using its ID, a set from a
different table can be used.

Then, when the table is removed, a reference to the set may be kept after
the set is freed, leading to a potential use-after-free.

When looking for sets by ID, use the table that was used for the lookup by
name, and only return sets belonging to that same table.

This fixes CVE-2022-2586, also reported as ZDI-CAN-17470.

Reported-by: Team Orca of Sea Security (@seasecresponse)
Fixes: 958bee14d071 ("netfilter: nf_tables: use new transaction infrastructure to handle sets")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3840,6 +3840,7 @@ static struct nft_set *nft_set_lookup_by
 }
 
 static struct nft_set *nft_set_lookup_byid(const struct net *net,
+					   const struct nft_table *table,
 					   const struct nlattr *nla, u8 genmask)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
@@ -3851,6 +3852,7 @@ static struct nft_set *nft_set_lookup_by
 			struct nft_set *set = nft_trans_set(trans);
 
 			if (id == nft_trans_set_id(trans) &&
+			    set->table == table &&
 			    nft_active_genmask(set, genmask))
 				return set;
 		}
@@ -3871,7 +3873,7 @@ struct nft_set *nft_set_lookup_global(co
 		if (!nla_set_id)
 			return set;
 
-		set = nft_set_lookup_byid(net, nla_set_id, genmask);
+		set = nft_set_lookup_byid(net, table, nla_set_id, genmask);
 	}
 	return set;
 }


