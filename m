Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0058419CCF
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237775AbhI0Rc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:32:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237253AbhI0Ra1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:30:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57FF261528;
        Mon, 27 Sep 2021 17:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632763103;
        bh=vQpOftK58HFrEMtqhS+vExiv6bC/EGA3MzKuenv2YGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMOKjG2EgwwLCVVcqnJHSK3wJidoq8n35Biq6OdOp13gefU62DBN6XhSlmTNu8T9y
         HIkvxMTU3RRBtdgmB/hAEVaDrOJwmiOaST9chV01iLxsWfwsf7C2Vh+IzkeyJwLqOF
         9mRmVwVQpPCMDMLs5Sd9G3SaXaH6KSoUa2n3k9PU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Pham <jackp@codeaurora.org>
Subject: [PATCH 5.14 162/162] usb: gadget: f_uac2: Populate SS descriptors wBytesPerInterval
Date:   Mon, 27 Sep 2021 19:03:28 +0200
Message-Id: <20210927170239.028165153@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Pham <jackp@codeaurora.org>

commit f0e8a206a2a53a919e1709c654cb65d519f7befb upstream.

For Isochronous endpoints, the SS companion descriptor's
wBytesPerInterval field is required to reserve bus time in order
to transmit the required payload during the service interval.
If left at 0, the UAC2 function is unable to transact data on its
playback or capture endpoints in SuperSpeed mode.

Since f_uac2 currently does not support any bursting this value can
be exactly equal to the calculated wMaxPacketSize.

Tested with Windows 10 as a host.

Fixes: f8cb3d556be3 ("usb: f_uac2: adds support for SS and SSP")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Link: https://lore.kernel.org/r/20210909174811.12534-3-jackp@codeaurora.org
[jackp: Backport to 5.14 with minor conflict resolution]
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uac2.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -951,6 +951,9 @@ afunc_bind(struct usb_configuration *cfg
 	agdev->out_ep_maxpsize = max_t(u16, agdev->out_ep_maxpsize,
 				le16_to_cpu(ss_epout_desc.wMaxPacketSize));
 
+	ss_epin_desc_comp.wBytesPerInterval = ss_epin_desc.wMaxPacketSize;
+	ss_epout_desc_comp.wBytesPerInterval = ss_epout_desc.wMaxPacketSize;
+
 	hs_epout_desc.bEndpointAddress = fs_epout_desc.bEndpointAddress;
 	hs_epin_fback_desc.bEndpointAddress = fs_epin_fback_desc.bEndpointAddress;
 	hs_epin_desc.bEndpointAddress = fs_epin_desc.bEndpointAddress;


