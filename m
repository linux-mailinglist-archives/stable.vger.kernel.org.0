Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59491150B70
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729435AbgBCQ1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:27:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:38956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727588AbgBCQ1j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:27:39 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D743C2086A;
        Mon,  3 Feb 2020 16:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747258;
        bh=489OQ6z834AyrbF1w/mFpUqOVCmha7wDI6GBSA7byM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2HRGDWIg8VjgtPs/vAcPEA+fTcV5XhoVyTYMdoyjE5ODCM9Xt5J6H6UCf6qQyGLXr
         laaEbkO12CgxqobnbGGRVeWxgs+wOExmJtfCfVj8z061o3NNyF2MQ1KNG2OFgk0fSE
         6VPZDq8aDfA7gIQgHuojhkWke3Gc1fZ53iE3QdQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.14 01/89] orinoco_usb: fix interface sanity check
Date:   Mon,  3 Feb 2020 16:18:46 +0000
Message-Id: <20200203161917.048693696@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161916.847439465@linuxfoundation.org>
References: <20200203161916.847439465@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit b73e05aa543cf8db4f4927e36952360d71291d41 upstream.

Make sure to use the current alternate setting when verifying the
interface descriptors to avoid binding to an invalid interface.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: 9afac70a7305 ("orinoco: add orinoco_usb driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.35
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
@@ -1613,9 +1613,9 @@ static int ezusb_probe(struct usb_interf
 	/* set up the endpoint information */
 	/* check out the endpoints */
 
-	iface_desc = &interface->altsetting[0].desc;
+	iface_desc = &interface->cur_altsetting->desc;
 	for (i = 0; i < iface_desc->bNumEndpoints; ++i) {
-		ep = &interface->altsetting[0].endpoint[i].desc;
+		ep = &interface->cur_altsetting->endpoint[i].desc;
 
 		if (usb_endpoint_is_bulk_in(ep)) {
 			/* we found a bulk in endpoint */


