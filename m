Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3EB5493AB
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377472AbiFMNcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378047AbiFMNas (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:30:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF646EC65;
        Mon, 13 Jun 2022 04:25:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C3553CE1171;
        Mon, 13 Jun 2022 11:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D269DC3411C;
        Mon, 13 Jun 2022 11:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119526;
        bh=1xszyAWmAXrHPNwGf/ECL0SC2iB4AxurzvpCenhi4aY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dmpEywhhtE6KCqpqYzURtPgOEBeqRaCe7FXCLWFJdSSagr6k82PZv1XgqG5Da/fFF
         3Xmxn43s/3o1WIpssZU+jrXK3f+Va8HClsWBfLKdGDFV27RQbP9aeMKQ1wHigFxiW7
         Pn7wk7iYHR3u50lCvqDuWT7BDSMYKTe8aMSSpFkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wesley Cheng <quic_wcheng@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 025/339] usb: dwc3: gadget: Replace list_for_each_entry_safe() if using giveback
Date:   Mon, 13 Jun 2022 12:07:30 +0200
Message-Id: <20220613094927.273339008@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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

From: Wesley Cheng <quic_wcheng@quicinc.com>

[ Upstream commit bf594d1d0c1d7b895954018043536ffd327844f9 ]

The list_for_each_entry_safe() macro saves the current item (n) and
the item after (n+1), so that n can be safely removed without
corrupting the list.  However, when traversing the list and removing
items using gadget giveback, the DWC3 lock is briefly released,
allowing other routines to execute.  There is a situation where, while
items are being removed from the cancelled_list using
dwc3_gadget_ep_cleanup_cancelled_requests(), the pullup disable
routine is running in parallel (due to UDC unbind).  As the cleanup
routine removes n, and the pullup disable removes n+1, once the
cleanup retakes the DWC3 lock, it references a request who was already
removed/handled.  With list debug enabled, this leads to a panic.
Ensure all instances of the macro are replaced where gadget giveback
is used.

Example call stack:

Thread#1:
__dwc3_gadget_ep_set_halt() - CLEAR HALT
  -> dwc3_gadget_ep_cleanup_cancelled_requests()
    ->list_for_each_entry_safe()
    ->dwc3_gadget_giveback(n)
      ->dwc3_gadget_del_and_unmap_request()- n deleted[cancelled_list]
      ->spin_unlock
      ->Thread#2 executes
      ...
    ->dwc3_gadget_giveback(n+1)
      ->Already removed!

Thread#2:
dwc3_gadget_pullup()
  ->waiting for dwc3 spin_lock
  ...
  ->Thread#1 released lock
  ->dwc3_stop_active_transfers()
    ->dwc3_remove_requests()
      ->fetches n+1 item from cancelled_list (n removed by Thread#1)
      ->dwc3_gadget_giveback()
        ->dwc3_gadget_del_and_unmap_request()- n+1 deleted[cancelled_list]
        ->spin_unlock

Fixes: d4f1afe5e896 ("usb: dwc3: gadget: move requests to cancelled_list")
Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Link: https://lore.kernel.org/r/20220414183521.23451-1-quic_wcheng@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 026fc360cc50..6936d8ce8981 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2001,10 +2001,10 @@ static void dwc3_gadget_ep_skip_trbs(struct dwc3_ep *dep, struct dwc3_request *r
 static void dwc3_gadget_ep_cleanup_cancelled_requests(struct dwc3_ep *dep)
 {
 	struct dwc3_request		*req;
-	struct dwc3_request		*tmp;
 	struct dwc3			*dwc = dep->dwc;
 
-	list_for_each_entry_safe(req, tmp, &dep->cancelled_list, list) {
+	while (!list_empty(&dep->cancelled_list)) {
+		req = next_request(&dep->cancelled_list);
 		dwc3_gadget_ep_skip_trbs(dep, req);
 		switch (req->status) {
 		case DWC3_REQUEST_STATUS_DISCONNECTED:
@@ -2021,6 +2021,12 @@ static void dwc3_gadget_ep_cleanup_cancelled_requests(struct dwc3_ep *dep)
 			dwc3_gadget_giveback(dep, req, -ECONNRESET);
 			break;
 		}
+		/*
+		 * The endpoint is disabled, let the dwc3_remove_requests()
+		 * handle the cleanup.
+		 */
+		if (!dep->endpoint.desc)
+			break;
 	}
 }
 
@@ -3333,15 +3339,21 @@ static void dwc3_gadget_ep_cleanup_completed_requests(struct dwc3_ep *dep,
 		const struct dwc3_event_depevt *event, int status)
 {
 	struct dwc3_request	*req;
-	struct dwc3_request	*tmp;
 
-	list_for_each_entry_safe(req, tmp, &dep->started_list, list) {
+	while (!list_empty(&dep->started_list)) {
 		int ret;
 
+		req = next_request(&dep->started_list);
 		ret = dwc3_gadget_ep_cleanup_completed_request(dep, event,
 				req, status);
 		if (ret)
 			break;
+		/*
+		 * The endpoint is disabled, let the dwc3_remove_requests()
+		 * handle the cleanup.
+		 */
+		if (!dep->endpoint.desc)
+			break;
 	}
 }
 
-- 
2.35.1



