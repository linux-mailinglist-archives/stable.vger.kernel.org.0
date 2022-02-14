Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD334B4835
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235276AbiBNJws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:52:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344151AbiBNJvd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:51:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C6377A8E;
        Mon, 14 Feb 2022 01:42:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8ED34611F9;
        Mon, 14 Feb 2022 09:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732FAC340E9;
        Mon, 14 Feb 2022 09:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831752;
        bh=0v9TIcwA/Vbn20Rlsqb/6ZLsZbXcSZQqHmpK8wJkvJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LdKsReFVJl3zuN3WsUOdsh93KzRD2M+NUOMqGHvKZ430WRRa4bpcrqV5iPK4jMFqf
         S5wEepyZ1sTQXsUiFbkqY8UdSdJTFxCYdkNibUBUxw2sslTtFdlXjtg93kaavRwWFD
         J5H9T+Q1y1UmOad+j2likw/nJ9L11pS8mba7w4Pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Colin Foster <colin.foster@in-advantage.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/116] net: mscc: ocelot: fix mutex lock error during ethtool stats read
Date:   Mon, 14 Feb 2022 10:26:24 +0100
Message-Id: <20220214092501.704177712@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
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
index 52401915828a1..a06466ecca12a 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -848,12 +848,11 @@ void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
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
@@ -872,8 +871,6 @@ static void ocelot_update_stats(struct ocelot *ocelot)
 					      ~(u64)U32_MAX) + val;
 		}
 	}
-
-	mutex_unlock(&ocelot->stats_lock);
 }
 
 static void ocelot_check_stats_work(struct work_struct *work)
@@ -882,7 +879,9 @@ static void ocelot_check_stats_work(struct work_struct *work)
 	struct ocelot *ocelot = container_of(del_work, struct ocelot,
 					     stats_work);
 
+	mutex_lock(&ocelot->stats_lock);
 	ocelot_update_stats(ocelot);
+	mutex_unlock(&ocelot->stats_lock);
 
 	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
 			   OCELOT_STATS_CHECK_DELAY);
@@ -892,12 +891,16 @@ void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
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



