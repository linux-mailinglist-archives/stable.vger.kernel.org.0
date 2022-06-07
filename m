Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79BC05410AA
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353100AbiFGT2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356726AbiFGT2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:28:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6A71A0ACA;
        Tue,  7 Jun 2022 11:10:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE92AB82340;
        Tue,  7 Jun 2022 18:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C94C385A2;
        Tue,  7 Jun 2022 18:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625433;
        bh=Tc0Q39oyVnRW3866dz4/fiiECwqbaxKvAXBOFHJf6O0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pUF+VOmUHeL9C/KTEpcHbay2R+Ap1/O1ahLuAx2st41mnwvMy1NEn+mPEzTL4gS2+
         IPZ5LAHRlf4SstS1EAIHzs4K5xbBP8pARDN0fS6nvU3MRZ51nVqzyn4oZXQt/1nXfp
         bod9j0Uc0pho3qB6Fg+z8hpaoX7Rs49pNVTPBt14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Albert Wang <albertccwang@google.com>
Subject: [PATCH 5.17 018/772] usb: dwc3: gadget: Move null pinter check to proper place
Date:   Tue,  7 Jun 2022 18:53:30 +0200
Message-Id: <20220607164949.544429132@linuxfoundation.org>
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

From: Albert Wang <albertccwang@google.com>

commit 3c5880745b4439ac64eccdb040e37fc1cc4c5406 upstream.

When dwc3_gadget_ep_cleanup_completed_requests() called to
dwc3_gadget_giveback() where the dwc3 lock is released, other thread is
able to execute. In this situation, usb_ep_disable() gets the chance to
clear endpoint descriptor pointer which leds to the null pointer
dereference problem. So needs to move the null pointer check to a proper
place.

Example call stack:

Thread#1:
dwc3_thread_interrupt()
  spin_lock
  -> dwc3_process_event_buf()
   -> dwc3_process_event_entry()
    -> dwc3_endpoint_interrupt()
     -> dwc3_gadget_endpoint_trbs_complete()
      -> dwc3_gadget_ep_cleanup_completed_requests()
       ...
       -> dwc3_giveback()
          spin_unlock
          Thread#2 executes

Thread#2:
configfs_composite_disconnect()
  -> __composite_disconnect()
   -> ffs_func_disable()
    -> ffs_func_set_alt()
     -> ffs_func_eps_disable()
      -> usb_ep_disable()
         wait for dwc3 spin_lock
         Thread#1 released lock
         clear endpoint.desc

Fixes: 26288448120b ("usb: dwc3: gadget: Fix null pointer exception")
Cc: stable <stable@kernel.org>
Signed-off-by: Albert Wang <albertccwang@google.com>
Link: https://lore.kernel.org/r/20220518061315.3359198-1-albertccwang@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3335,14 +3335,14 @@ static bool dwc3_gadget_endpoint_trbs_co
 	struct dwc3		*dwc = dep->dwc;
 	bool			no_started_trb = true;
 
-	if (!dep->endpoint.desc)
-		return no_started_trb;
-
 	dwc3_gadget_ep_cleanup_completed_requests(dep, event, status);
 
 	if (dep->flags & DWC3_EP_END_TRANSFER_PENDING)
 		goto out;
 
+	if (!dep->endpoint.desc)
+		return no_started_trb;
+
 	if (usb_endpoint_xfer_isoc(dep->endpoint.desc) &&
 		list_empty(&dep->started_list) &&
 		(list_empty(&dep->pending_list) || status == -EXDEV))


