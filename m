Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB47A4B4B05
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345942AbiBNKN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:13:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345780AbiBNKNO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:13:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8D8657AA;
        Mon, 14 Feb 2022 01:52:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 777F9B80D83;
        Mon, 14 Feb 2022 09:52:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645AAC340F0;
        Mon, 14 Feb 2022 09:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832321;
        bh=73jkwc8d5G1IRqqum6n5Rw5oNUa2CIyevo3N8bAMXJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HQEvsopK7dmpTtsGkkRwci0bAIUm3lMuciWHdbdqj2q0W6SZkod52hBVwX3lOpuUf
         iKj0M1C4sSLbuvsZOKhZvC0J7gdAi4egOtqJw0WSQN3a1r3/56FNgnV8HDMW1rsuU/
         osGoAcqQ4068bySAPqQD14LJPsXA48XcunBlv09A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Colin Foster <colin.foster@in-advantage.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 132/172] net: mscc: ocelot: fix mutex lock error during ethtool stats read
Date:   Mon, 14 Feb 2022 10:26:30 +0100
Message-Id: <20220214092510.971159445@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Foster <colin.foster@in-advantage.com>

[ Upstream commit 7fbf6795d127a3b1bb39b0e42579904cf6db1624 ]

An ongoing workqueue populates the stats buffer. At the same time, a user
might query the statistics. While writing to the buffer is mutex-locked,
reading from the buffer wasn't. This could lead to buggy reads by ethtool.

This patch fixes the former blamed commit, but the bug was introduced in
the latter.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Fixes: 1e1caa9735f90 ("ocelot: Clean up stats update deferred work")
Fixes: a556c76adc052 ("net: mscc: Add initial Ocelot switch support")
Reported-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/all/20220210150451.416845-2-colin.foster@in-advantage.com/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index be2dd69bfee8b..6aad0953e8fe5 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1215,12 +1215,11 @@ void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
 }
 EXPORT_SYMBOL(ocelot_get_strings);
 
+/* Caller must hold &ocelot->stats_lock */
 static void ocelot_update_stats(struct ocelot *ocelot)
 {
 	int i, j;
 
-	mutex_lock(&ocelot->stats_lock);
-
 	for (i = 0; i < ocelot->num_phys_ports; i++) {
 		/* Configure the port to read the stats from */
 		ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(i), SYS_STAT_CFG);
@@ -1239,8 +1238,6 @@ static void ocelot_update_stats(struct ocelot *ocelot)
 					      ~(u64)U32_MAX) + val;
 		}
 	}
-
-	mutex_unlock(&ocelot->stats_lock);
 }
 
 static void ocelot_check_stats_work(struct work_struct *work)
@@ -1249,7 +1246,9 @@ static void ocelot_check_stats_work(struct work_struct *work)
 	struct ocelot *ocelot = container_of(del_work, struct ocelot,
 					     stats_work);
 
+	mutex_lock(&ocelot->stats_lock);
 	ocelot_update_stats(ocelot);
+	mutex_unlock(&ocelot->stats_lock);
 
 	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
 			   OCELOT_STATS_CHECK_DELAY);
@@ -1259,12 +1258,16 @@ void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
 {
 	int i;
 
+	mutex_lock(&ocelot->stats_lock);
+
 	/* check and update now */
 	ocelot_update_stats(ocelot);
 
 	/* Copy all counters */
 	for (i = 0; i < ocelot->num_stats; i++)
 		*data++ = ocelot->stats[port * ocelot->num_stats + i];
+
+	mutex_unlock(&ocelot->stats_lock);
 }
 EXPORT_SYMBOL(ocelot_get_ethtool_stats);
 
-- 
2.34.1



