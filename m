Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA3E94AD7C2
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 12:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356077AbiBHLq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 06:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356083AbiBHLqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 06:46:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8C5C07D6C1
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 03:34:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01CA661576
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 11:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A73C004E1;
        Tue,  8 Feb 2022 11:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644320054;
        bh=NbwVhzx55KE3mhEKvqJWSThDl+yVTz/Gbd3JGn5dvEs=;
        h=Subject:To:From:Date:From;
        b=bQ05oEEcPKiFXa96xaux3ge/YxIFZFMps+sL/7AnQTwK+sleTmRbTXkxUKv9PGokB
         UOHOJDu3RUgKdOwAcKzJyQrN5wOR4KT5ALXS/RhZGpt9PmqQ6otWoABOYwOOYAafnh
         sxcI5ToqK3NtmXuWig4rtdQjW9athosEAMthfPHY=
Subject: patch "usb: dwc3: gadget: Prevent core from processing stale TRBs" added to usb-linus
To:     quic_ugoswami@quicinc.com, gregkh@linuxfoundation.org,
        quic_pkondeti@quicinc.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Feb 2022 12:34:11 +0100
Message-ID: <164432005172126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: gadget: Prevent core from processing stale TRBs

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 117b4e96c7f362eb6459543883fc07f77662472c Mon Sep 17 00:00:00 2001
From: Udipto Goswami <quic_ugoswami@quicinc.com>
Date: Mon, 7 Feb 2022 09:55:58 +0530
Subject: usb: dwc3: gadget: Prevent core from processing stale TRBs

With CPU re-ordering on write instructions, there might
be a chance that the HWO is set before the TRB is updated
with the new mapped buffer address.
And in the case where core is processing a list of TRBs
it is possible that it fetched the TRBs when the HWO is set
but before the buffer address is updated.
Prevent this by adding a memory barrier before the HWO
is updated to ensure that the core always process the
updated TRBs.

Fixes: f6bafc6a1c9d ("usb: dwc3: convert TRBs into bitshifts")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Signed-off-by: Udipto Goswami <quic_ugoswami@quicinc.com>
Link: https://lore.kernel.org/r/1644207958-18287-1-git-send-email-quic_ugoswami@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 520031ba38aa..183b90923f51 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1291,6 +1291,19 @@ static void __dwc3_prepare_one_trb(struct dwc3_ep *dep, struct dwc3_trb *trb,
 	if (usb_endpoint_xfer_bulk(dep->endpoint.desc) && dep->stream_capable)
 		trb->ctrl |= DWC3_TRB_CTRL_SID_SOFN(stream_id);
 
+	/*
+	 * As per data book 4.2.3.2TRB Control Bit Rules section
+	 *
+	 * The controller autonomously checks the HWO field of a TRB to determine if the
+	 * entire TRB is valid. Therefore, software must ensure that the rest of the TRB
+	 * is valid before setting the HWO field to '1'. In most systems, this means that
+	 * software must update the fourth DWORD of a TRB last.
+	 *
+	 * However there is a possibility of CPU re-ordering here which can cause
+	 * controller to observe the HWO bit set prematurely.
+	 * Add a write memory barrier to prevent CPU re-ordering.
+	 */
+	wmb();
 	trb->ctrl |= DWC3_TRB_CTRL_HWO;
 
 	dwc3_ep_inc_enq(dep);
-- 
2.35.1


