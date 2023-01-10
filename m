Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 219F1664913
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235257AbjAJSRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239160AbjAJSQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:16:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12E17167E2
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:15:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5FBDB81903
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13956C433D2;
        Tue, 10 Jan 2023 18:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374507;
        bh=nz96L2JG1bFpBLoFpcaf90jDFTRHdQpm1pRS6o4nttg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iRpWDDwYs0IlHgKaE0yf5l0aHRO5z4xaQBCnKl1+bpZo0d7FClAoHPlc1pqL3zggs
         +75ARaEPKCDPeZt9RB0Qsr2hSS6uB0tvFMbne8BXsd52/17WjEPxuomSK7zcvTPBM1
         caqUN0TOeFfuoi5Qx9Hs+KqPckepLYh/t4X6frvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Shawn Bohrer <sbohrer@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/159] veth: Fix race with AF_XDP exposing old or uninitialized descriptors
Date:   Tue, 10 Jan 2023 19:02:55 +0100
Message-Id: <20230110180019.178079861@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shawn Bohrer <sbohrer@cloudflare.com>

[ Upstream commit fa349e396e4886d742fd6501c599ec627ef1353b ]

When AF_XDP is used on on a veth interface the RX ring is updated in two
steps.  veth_xdp_rcv() removes packet descriptors from the FILL ring
fills them and places them in the RX ring updating the cached_prod
pointer.  Later xdp_do_flush() syncs the RX ring prod pointer with the
cached_prod pointer allowing user-space to see the recently filled in
descriptors.  The rings are intended to be SPSC, however the existing
order in veth_poll allows the xdp_do_flush() to run concurrently with
another CPU creating a race condition that allows user-space to see old
or uninitialized descriptors in the RX ring.  This bug has been observed
in production systems.

To summarize, we are expecting this ordering:

CPU 0 __xsk_rcv_zc()
CPU 0 __xsk_map_flush()
CPU 2 __xsk_rcv_zc()
CPU 2 __xsk_map_flush()

But we are seeing this order:

CPU 0 __xsk_rcv_zc()
CPU 2 __xsk_rcv_zc()
CPU 0 __xsk_map_flush()
CPU 2 __xsk_map_flush()

This occurs because we rely on NAPI to ensure that only one napi_poll
handler is running at a time for the given veth receive queue.
napi_schedule_prep() will prevent multiple instances from getting
scheduled. However calling napi_complete_done() signals that this
napi_poll is complete and allows subsequent calls to
napi_schedule_prep() and __napi_schedule() to succeed in scheduling a
concurrent napi_poll before the xdp_do_flush() has been called.  For the
veth driver a concurrent call to napi_schedule_prep() and
__napi_schedule() can occur on a different CPU because the veth xmit
path can additionally schedule a napi_poll creating the race.

The fix as suggested by Magnus Karlsson, is to simply move the
xdp_do_flush() call before napi_complete_done().  This syncs the
producer ring pointers before another instance of napi_poll can be
scheduled on another CPU.  It will also slightly improve performance by
moving the flush closer to when the descriptors were placed in the
RX ring.

Fixes: d1396004dd86 ("veth: Add XDP TX and REDIRECT")
Suggested-by: Magnus Karlsson <magnus.karlsson@gmail.com>
Signed-off-by: Shawn Bohrer <sbohrer@cloudflare.com>
Link: https://lore.kernel.org/r/20221220185903.1105011-1-sbohrer@cloudflare.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 09682ea3354e..bd385ccd0d18 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -974,6 +974,9 @@ static int veth_poll(struct napi_struct *napi, int budget)
 	xdp_set_return_frame_no_direct();
 	done = veth_xdp_rcv(rq, budget, &bq, &stats);
 
+	if (stats.xdp_redirect > 0)
+		xdp_do_flush();
+
 	if (done < budget && napi_complete_done(napi, done)) {
 		/* Write rx_notify_masked before reading ptr_ring */
 		smp_store_mb(rq->rx_notify_masked, false);
@@ -987,8 +990,6 @@ static int veth_poll(struct napi_struct *napi, int budget)
 
 	if (stats.xdp_tx > 0)
 		veth_xdp_flush(rq, &bq);
-	if (stats.xdp_redirect > 0)
-		xdp_do_flush();
 	xdp_clear_return_frame_no_direct();
 
 	return done;
-- 
2.35.1



