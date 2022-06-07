Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321575414E8
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359192AbiFGUXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359397AbiFGUWf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:22:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223201447BC;
        Tue,  7 Jun 2022 11:31:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D886EB8233E;
        Tue,  7 Jun 2022 18:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1C7C385A5;
        Tue,  7 Jun 2022 18:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626701;
        bh=w66/fpf539QF9uiRHRwfGui+3/SRGUq0EVIxmAcZvI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T2AGODSyyhCl4yC4/QcDZwumyAycH7bo1OvwKb95BEc3EQK5HwdEP4oczzgeknB2M
         h0cPY/UgHCtGgS5z4r6T+NBnj1b4Pbt6siwoBD5Voo6JGocaHzoyC+WqkiINEcLPAq
         CCXwVGb1zUqbikQnPyqEs6kVh7+DVo8Rq3T2sDy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 433/772] amt: fix gateway mode stuck
Date:   Tue,  7 Jun 2022 19:00:25 +0200
Message-Id: <20220607165001.763306841@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 937956ba404e70a765ca5aa39d3d7564d86a8872 ]

If a gateway can not receive any response to requests from a relay,
gateway resets status from SENT_REQUEST to INIT and variable about a
relay as well. And then it should start the full establish step
from sending a discovery message and receiving advertisement message.
But, after failure in amt_req_work() it continues sending a request
message step with flushed(invalid) relay information and sets SENT_REQUEST.
So, a gateway can't be established with a relay.
In order to avoid this situation, it stops sending the request message
step if it fails.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index f1a36d7e2151..96a2f6a505c3 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -943,7 +943,7 @@ static void amt_req_work(struct work_struct *work)
 	if (amt->status < AMT_STATUS_RECEIVED_ADVERTISEMENT)
 		goto out;
 
-	if (amt->req_cnt++ > AMT_MAX_REQ_COUNT) {
+	if (amt->req_cnt > AMT_MAX_REQ_COUNT) {
 		netdev_dbg(amt->dev, "Gateway is not ready");
 		amt->qi = AMT_INIT_REQ_TIMEOUT;
 		amt->ready4 = false;
@@ -951,13 +951,15 @@ static void amt_req_work(struct work_struct *work)
 		amt->remote_ip = 0;
 		__amt_update_gw_status(amt, AMT_STATUS_INIT, false);
 		amt->req_cnt = 0;
+		goto out;
 	}
 	spin_unlock_bh(&amt->lock);
 
 	amt_send_request(amt, false);
 	amt_send_request(amt, true);
-	amt_update_gw_status(amt, AMT_STATUS_SENT_REQUEST, true);
 	spin_lock_bh(&amt->lock);
+	__amt_update_gw_status(amt, AMT_STATUS_SENT_REQUEST, true);
+	amt->req_cnt++;
 out:
 	exp = min_t(u32, (1 * (1 << amt->req_cnt)), AMT_MAX_REQ_TIMEOUT);
 	mod_delayed_work(amt_wq, &amt->req_wq, msecs_to_jiffies(exp * 1000));
-- 
2.35.1



