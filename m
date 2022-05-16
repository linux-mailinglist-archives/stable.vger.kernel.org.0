Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE46528F38
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236483AbiEPTxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346624AbiEPTvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:51:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07F9201AE;
        Mon, 16 May 2022 12:45:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35DDD61596;
        Mon, 16 May 2022 19:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DF8C385AA;
        Mon, 16 May 2022 19:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730338;
        bh=VyUjrvGnK/KhkGLPpry69WpvVUt5+9+gb0wJpvfgPP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MPjSpPA7GXZ+EPfVE9pJ5aEllC9EdS9XAgI+9fznVbjsAPav5Dht5uO8NqI+Kmh7j
         6+xcVIFyfdteCYO9RvsnF4pcX65ti284y3XENoT/svf1NBPvzTKlnoSj7/qCPsTmBl
         8skyPZVTDXxjl2gaE7VlueR8RqpPLPeCO2J+vmqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 06/66] net: mscc: ocelot: fix last VCAP IS1/IS2 filter persisting in hardware when deleted
Date:   Mon, 16 May 2022 21:36:06 +0200
Message-Id: <20220516193619.592463245@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193619.400083785@linuxfoundation.org>
References: <20220516193619.400083785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 16bbebd35629c93a8c68c6d8d28557e100bcee73 ]

ocelot_vcap_filter_del() works by moving the next filters over the
current one, and then deleting the last filter by calling vcap_entry_set()
with a del_filter which was specially created by memsetting its memory
to zeroes. vcap_entry_set() then programs this to the TCAM and action
RAM via the cache registers.

The problem is that vcap_entry_set() is a dispatch function which looks
at del_filter->block_id. But since del_filter is zeroized memory, the
block_id is 0, or otherwise said, VCAP_ES0. So practically, what we do
is delete the entry at the same TCAM index from VCAP ES0 instead of IS1
or IS2.

The code was not always like this. vcap_entry_set() used to simply be
is2_entry_set(), and then, the logic used to work.

Restore the functionality by populating the block_id of the del_filter
based on the VCAP block of the filter that we're deleting. This makes
vcap_entry_set() know what to do.

Fixes: 1397a2eb52e2 ("net: mscc: ocelot: create TCAM skeleton from tc filter chains")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index d8c778ee6f1b..e47098900a69 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -1181,7 +1181,11 @@ int ocelot_vcap_filter_del(struct ocelot *ocelot,
 	struct ocelot_vcap_filter del_filter;
 	int i, index;
 
+	/* Need to inherit the block_id so that vcap_entry_set()
+	 * does not get confused and knows where to install it.
+	 */
 	memset(&del_filter, 0, sizeof(del_filter));
+	del_filter.block_id = filter->block_id;
 
 	/* Gets index of the filter */
 	index = ocelot_vcap_block_get_filter_index(block, filter);
-- 
2.35.1



