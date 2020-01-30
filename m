Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E500D14E1C0
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731339AbgA3SrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:47:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:57686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731334AbgA3SrN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:47:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E1B520674;
        Thu, 30 Jan 2020 18:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580410032;
        bh=5GLCGFPWXSPgb+QCYBQDMq3UO+YPO/33Vq6/9JRtKNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E6h0ZK3JaHdI0BQYrHyBwJHDqFOu2z3qWXZ2hN1m1FxYE7dF2advDetQpjN6b9ySI
         teXsHvta/9Iee4QsG/Bzm1DNgsfmoMAPG59Zlf/OvI/zAtLnBgqQ/0YjdNquQpfwY/
         9nqdfBS2/1Gqw3rieXiOlDqzgp5RRz0ng2kxazEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arend van Spriel <arend@broadcom.com>,
        Johan Hovold <johan@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.19 20/55] brcmfmac: fix interface sanity check
Date:   Thu, 30 Jan 2020 19:39:01 +0100
Message-Id: <20200130183612.476659754@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.563083888@linuxfoundation.org>
References: <20200130183608.563083888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 3428fbcd6e6c0850b1a8b2a12082b7b2aabb3da3 upstream.

Make sure to use the current alternate setting when verifying the
interface descriptors to avoid binding to an invalid interface.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: 71bb244ba2fd ("brcm80211: fmac: add USB support for bcm43235/6/8 chipsets")
Cc: stable <stable@vger.kernel.org>     # 3.4
Cc: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -1357,7 +1357,7 @@ brcmf_usb_probe(struct usb_interface *in
 		goto fail;
 	}
 
-	desc = &intf->altsetting[0].desc;
+	desc = &intf->cur_altsetting->desc;
 	if ((desc->bInterfaceClass != USB_CLASS_VENDOR_SPEC) ||
 	    (desc->bInterfaceSubClass != 2) ||
 	    (desc->bInterfaceProtocol != 0xff)) {
@@ -1370,7 +1370,7 @@ brcmf_usb_probe(struct usb_interface *in
 
 	num_of_eps = desc->bNumEndpoints;
 	for (ep = 0; ep < num_of_eps; ep++) {
-		endpoint = &intf->altsetting[0].endpoint[ep].desc;
+		endpoint = &intf->cur_altsetting->endpoint[ep].desc;
 		endpoint_num = usb_endpoint_num(endpoint);
 		if (!usb_endpoint_xfer_bulk(endpoint))
 			continue;


