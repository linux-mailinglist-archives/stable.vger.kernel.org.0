Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55E0461E31
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379248AbhK2Sdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:33:44 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:49666 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378026AbhK2Sbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:31:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A6AA9CE13D8;
        Mon, 29 Nov 2021 18:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDA6C53FAD;
        Mon, 29 Nov 2021 18:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210500;
        bh=HgsSHxKV45OJznNptJRLxGXxWD792k5Ayco2p4oX+bU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dOvdJdrzJFLQjAPw+1VGDWcFVOtHJoSt1musZ/fOsRTCyvueIzkzRDTEOx6BwTHUM
         I7zoGOCdZhdu6dAcccuDT1dXSfVZtvhKwqSStx5biOPotnTh5csOXjHBzKRMGowr5u
         ROSTFVVZzIwyCvIPuaLKU7flNWs6kkJg6m+bXnJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Pham <quic_jackp@quicinc.com>,
        Albert Wang <albertccwang@google.com>
Subject: [PATCH 5.10 009/121] usb: dwc3: gadget: Fix null pointer exception
Date:   Mon, 29 Nov 2021 19:17:20 +0100
Message-Id: <20211129181711.962700580@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Albert Wang <albertccwang@google.com>

commit 26288448120b28af1dfd85a6fa6b6d55a16c7f2f upstream.

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
---
 drivers/usb/dwc3/gadget.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2918,6 +2918,9 @@ static bool dwc3_gadget_endpoint_trbs_co
 	struct dwc3		*dwc = dep->dwc;
 	bool			no_started_trb = true;
 
+	if (!dep->endpoint.desc)
+		return no_started_trb;
+
 	dwc3_gadget_ep_cleanup_completed_requests(dep, event, status);
 
 	if (dep->flags & DWC3_EP_END_TRANSFER_PENDING)
@@ -2965,6 +2968,9 @@ static void dwc3_gadget_endpoint_transfe
 {
 	int status = 0;
 
+	if (!dep->endpoint.desc)
+		return;
+
 	if (usb_endpoint_xfer_isoc(dep->endpoint.desc))
 		dwc3_gadget_endpoint_frame_from_event(dep, event);
 


