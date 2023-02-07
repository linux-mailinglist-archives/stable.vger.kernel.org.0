Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B7E68D78B
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbjBGNBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231980AbjBGNBH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:01:07 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1ED39CED
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:00:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F1099CE1D97
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7EA6C433EF;
        Tue,  7 Feb 2023 13:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774821;
        bh=32eq295W0lUaJKHGfeSG9AGcYYtLXtHhwpT7Tl0SW5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/03foKSkwgpM2Xo1qo2T6BFmnArXV4cglQMtlT6zPMIOusfwz/NgzPLoaVFZxGLD
         3Nbn5wC8oKovuPboD+8lht70XxnGOd5oduNhdF8nG+Vi5D2jhznhc0ZlLwfdQRhXa5
         fwOAJMygHmsxrxhg/AfmLgbp7wDn0f0n0Get4U0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/208] dpaa2-eth: execute xdp_do_flush() before napi_complete_done()
Date:   Tue,  7 Feb 2023 13:54:58 +0100
Message-Id: <20230207125636.288491094@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit a3191c4d86c5d3bd35b00dfde6910b88391436a0 ]

Make sure that xdp_do_flush() is always executed before
napi_complete_done(). This is important for two reasons. First, a
redirect to an XSKMAP assumes that a call to xdp_do_redirect() from
napi context X on CPU Y will be followed by a xdp_do_flush() from the
same napi context and CPU. This is not guaranteed if the
napi_complete_done() is executed before xdp_do_flush(), as it tells
the napi logic that it is fine to schedule napi context X on another
CPU. Details from a production system triggering this bug using the
veth driver can be found following the first link below.

The second reason is that the XDP_REDIRECT logic in itself relies on
being inside a single NAPI instance through to the xdp_do_flush() call
for RCU protection of all in-kernel data structures. Details can be
found in the second link below.

Fixes: d678be1dc1ec ("dpaa2-eth: add XDP_REDIRECT support")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/20221220185903.1105011-1-sbohrer@cloudflare.com
Link: https://lore.kernel.org/all/20210624160609.292325-1-toke@redhat.com/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 8d029addddad..6383d9805dac 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1868,10 +1868,15 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
 		if (rx_cleaned >= budget ||
 		    txconf_cleaned >= DPAA2_ETH_TXCONF_PER_NAPI) {
 			work_done = budget;
+			if (ch->xdp.res & XDP_REDIRECT)
+				xdp_do_flush();
 			goto out;
 		}
 	} while (store_cleaned);
 
+	if (ch->xdp.res & XDP_REDIRECT)
+		xdp_do_flush();
+
 	/* Update NET DIM with the values for this CDAN */
 	dpaa2_io_update_net_dim(ch->dpio, ch->stats.frames_per_cdan,
 				ch->stats.bytes_per_cdan);
@@ -1902,9 +1907,7 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
 		txc_fq->dq_bytes = 0;
 	}
 
-	if (ch->xdp.res & XDP_REDIRECT)
-		xdp_do_flush_map();
-	else if (rx_cleaned && ch->xdp.res & XDP_TX)
+	if (rx_cleaned && ch->xdp.res & XDP_TX)
 		dpaa2_eth_xdp_tx_flush(priv, ch, &priv->fq[flowid]);
 
 	return work_done;
-- 
2.39.0



