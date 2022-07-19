Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A6D579DBF
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242024AbiGSMyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242105AbiGSMyE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:54:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA21593C22;
        Tue, 19 Jul 2022 05:21:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6772D6177D;
        Tue, 19 Jul 2022 12:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4849BC341CB;
        Tue, 19 Jul 2022 12:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233277;
        bh=YQc9oplaK/VMkpFIyKkSrYAnt6CG5R32uBWER36KpF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IawyQo/kaXqElIfcYmrQWRCXpXqpsEZyegiTgp7W7/Tf0dXRDvr8p2lUspwa3OyrO
         ncse7+zNEBcK/VTXJLwNFFXU8OYd4KTXWeJ1nmlSZmu63DCNZovk7NamwR1r0SmPR4
         eT8MpdHWg8zxghxSFt0KFd72rFyUTYYojNot1DJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 068/231] net: ocelot: fix wrong time_after usage
Date:   Tue, 19 Jul 2022 13:52:33 +0200
Message-Id: <20220719114719.977077572@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit f46fd3d7c3bd5d7bd5bb664135cf32ca9e97190b ]

Accidentally noticed, that this driver is the only user of
while (time_after(jiffies...)).

It looks like typo, because likely this while loop will finish after 1st
iteration, because time_after() returns true when 1st argument _is after_
2nd one.

There is one possible problem with this poll loop: the scheduler could put
the thread to sleep, and it does not get woken up for
OCELOT_FDMA_CH_SAFE_TIMEOUT_US. During that time, the hardware has done
its thing, but you exit the while loop and return -ETIMEDOUT.

Fix it by using sane poll API that avoids all problems described above

Fixes: 753a026cfec1 ("net: ocelot: add FDMA support")
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20220706132845.27968-1-paskripkin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_fdma.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_fdma.c b/drivers/net/ethernet/mscc/ocelot_fdma.c
index dffa597bffe6..6a8f84f325a3 100644
--- a/drivers/net/ethernet/mscc/ocelot_fdma.c
+++ b/drivers/net/ethernet/mscc/ocelot_fdma.c
@@ -94,19 +94,18 @@ static void ocelot_fdma_activate_chan(struct ocelot *ocelot, dma_addr_t dma,
 	ocelot_fdma_writel(ocelot, MSCC_FDMA_CH_ACTIVATE, BIT(chan));
 }
 
+static u32 ocelot_fdma_read_ch_safe(struct ocelot *ocelot)
+{
+	return ocelot_fdma_readl(ocelot, MSCC_FDMA_CH_SAFE);
+}
+
 static int ocelot_fdma_wait_chan_safe(struct ocelot *ocelot, int chan)
 {
-	unsigned long timeout;
 	u32 safe;
 
-	timeout = jiffies + usecs_to_jiffies(OCELOT_FDMA_CH_SAFE_TIMEOUT_US);
-	do {
-		safe = ocelot_fdma_readl(ocelot, MSCC_FDMA_CH_SAFE);
-		if (safe & BIT(chan))
-			return 0;
-	} while (time_after(jiffies, timeout));
-
-	return -ETIMEDOUT;
+	return readx_poll_timeout_atomic(ocelot_fdma_read_ch_safe, ocelot, safe,
+					 safe & BIT(chan), 0,
+					 OCELOT_FDMA_CH_SAFE_TIMEOUT_US);
 }
 
 static void ocelot_fdma_dcb_set_data(struct ocelot_fdma_dcb *dcb,
-- 
2.35.1



