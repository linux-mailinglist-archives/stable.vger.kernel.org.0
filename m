Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6356810F6
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237139AbjA3OIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237138AbjA3OIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:08:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F74435257
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:08:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BE9161025
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2C5C433EF;
        Mon, 30 Jan 2023 14:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087731;
        bh=i9AgXzbzlRfbOlOxsCvvLO1PSA69dmBWGkHJbequ90o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1mfH7I2/3RjrLVyFDSk6c9PHGKwo5MU+bdZGRIxDXRPdfhWkQHq+kaaxrOmkNmjh8
         vbW8MNz8zMXTI+71h8w9yqCzgXVuiwEUKfgdbEqYJH4biDzBiYe5fbARd1QGTGOpP9
         pfRBXEIQdYOHNU15f+TOUHRE53SGV5mj3cuZ6dR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 298/313] Partially revert "perf/arm-cmn: Optimise DTC counter accesses"
Date:   Mon, 30 Jan 2023 14:52:13 +0100
Message-Id: <20230130134350.618901914@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit a428eb4b99ab80454f06ad256b25e930fe8a4954 ]

It turns out the optimisation implemented by commit 4f2c3872dde5 is
totally broken, since all the places that consume hw->dtcs_used for
events other than cycle count are still not expecting it to be sparsely
populated, and fail to read all the relevant DTC counters correctly if
so.

If implemented correctly, the optimisation potentially saves up to 3
register reads per event update, which is reasonably significant for
events targeting a single node, but still not worth a massive amount of
additional code complexity overall. Getting it right within the current
design looks a fair bit more involved than it was ever intended to be,
so let's just make a functional revert which restores the old behaviour
while still backporting easily.

Fixes: 4f2c3872dde5 ("perf/arm-cmn: Optimise DTC counter accesses")
Reported-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/b41bb4ed7283c3d8400ce5cf5e6ec94915e6750f.1674498637.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-cmn.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index b80a9b74662b..1deb61b22bc7 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -1576,7 +1576,6 @@ static int arm_cmn_event_init(struct perf_event *event)
 			hw->dn++;
 			continue;
 		}
-		hw->dtcs_used |= arm_cmn_node_to_xp(cmn, dn)->dtc;
 		hw->num_dns++;
 		if (bynodeid)
 			break;
@@ -1589,6 +1588,12 @@ static int arm_cmn_event_init(struct perf_event *event)
 			nodeid, nid.x, nid.y, nid.port, nid.dev, type);
 		return -EINVAL;
 	}
+	/*
+	 * Keep assuming non-cycles events count in all DTC domains; turns out
+	 * it's hard to make a worthwhile optimisation around this, short of
+	 * going all-in with domain-local counter allocation as well.
+	 */
+	hw->dtcs_used = (1U << cmn->num_dtcs) - 1;
 
 	return arm_cmn_validate_group(cmn, event);
 }
-- 
2.39.0



