Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFF8529142
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346590AbiEPTyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347958AbiEPTwf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:52:35 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48BF45052;
        Mon, 16 May 2022 12:48:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5EC22CE179E;
        Mon, 16 May 2022 19:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546EFC34100;
        Mon, 16 May 2022 19:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730483;
        bh=l5l6ScM/whefvarB+02GhvofGH2tor3+qjvLVBObmUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pGTiLgS1WUCy7GUUUS1XP4+bUxA36YRwtCrloAe2Mlr3gO4WlA7b1IyTWCc/+7ODb
         X9LXbB+KERelGP7ZnipLjiTYuo7WMbZDkJ8xMNI111Q+FvxN0CzS3kiC5ONEA8xi6I
         ktfydR7C8M7dzy3GFj244gVpNAq4BpwVpR8LJDWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/102] net: mscc: ocelot: fix last VCAP IS1/IS2 filter persisting in hardware when deleted
Date:   Mon, 16 May 2022 21:35:40 +0200
Message-Id: <20220516193624.176861912@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
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
index 99d7376a70a7..f5f513d87642 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -1192,7 +1192,11 @@ int ocelot_vcap_filter_del(struct ocelot *ocelot,
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



