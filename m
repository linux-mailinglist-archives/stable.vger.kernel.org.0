Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8301645FEA6
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 13:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354449AbhK0Myv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Nov 2021 07:54:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240181AbhK0Mwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Nov 2021 07:52:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9BDC06174A
        for <stable@vger.kernel.org>; Sat, 27 Nov 2021 04:48:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83463B81B47
        for <stable@vger.kernel.org>; Sat, 27 Nov 2021 12:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FFBBC53FC7;
        Sat, 27 Nov 2021 12:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638017337;
        bh=Q3GXCU4DJDXzz1euKKEU+hpi7B7HfFVErv3i3bpVwO4=;
        h=Subject:To:Cc:From:Date:From;
        b=ae6YHXeVdyTFcmMjbzRz7hKRDEi8CkD7NTjDPJqhigBJkorTR6stTxhj9mZ4oclD1
         LA9rp6R3AUG4eiwlcaPwxLY842uN3NtiCweRrF9MhB3K3kgtDOTe++TvOgj/Fbjp76
         pq/xOMC2h4YR0QWno3zXuycGDSFBUvWf7fvNXp/4=
Subject: FAILED: patch "[PATCH] usb: dwc3: gadget: Fix null pointer exception" failed to apply to 5.4-stable tree
To:     albertccwang@google.com, gregkh@linuxfoundation.org,
        quic_jackp@quicinc.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 27 Nov 2021 13:48:54 +0100
Message-ID: <163801733476118@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 26288448120b28af1dfd85a6fa6b6d55a16c7f2f Mon Sep 17 00:00:00 2001
From: Albert Wang <albertccwang@google.com>
Date: Tue, 9 Nov 2021 17:26:42 +0800
Subject: [PATCH] usb: dwc3: gadget: Fix null pointer exception

In the endpoint interrupt functions
dwc3_gadget_endpoint_transfer_in_progress() and
dwc3_gadget_endpoint_trbs_complete() will dereference the endpoint
descriptor. But it could be cleared in __dwc3_gadget_ep_disable()
when accessory disconnected. So we need to check whether it is null
or not before dereferencing it.

Fixes: f09ddcfcb8c5 ("usb: dwc3: gadget: Prevent EP queuing while stopping transfers")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Jack Pham <quic_jackp@quicinc.com>
Signed-off-by: Albert Wang <albertccwang@google.com>
Link: https://lore.kernel.org/r/20211109092642.3507692-1-albertccwang@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index daa8f8548a2e..7e3db00e9759 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3263,6 +3263,9 @@ static bool dwc3_gadget_endpoint_trbs_complete(struct dwc3_ep *dep,
 	struct dwc3		*dwc = dep->dwc;
 	bool			no_started_trb = true;
 
+	if (!dep->endpoint.desc)
+		return no_started_trb;
+
 	dwc3_gadget_ep_cleanup_completed_requests(dep, event, status);
 
 	if (dep->flags & DWC3_EP_END_TRANSFER_PENDING)
@@ -3310,6 +3313,9 @@ static void dwc3_gadget_endpoint_transfer_in_progress(struct dwc3_ep *dep,
 {
 	int status = 0;
 
+	if (!dep->endpoint.desc)
+		return;
+
 	if (usb_endpoint_xfer_isoc(dep->endpoint.desc))
 		dwc3_gadget_endpoint_frame_from_event(dep, event);
 

