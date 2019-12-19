Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8D912698D
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbfLSSiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:38:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:56870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728089AbfLSSiw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:38:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EFE720716;
        Thu, 19 Dec 2019 18:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780732;
        bh=qaDyqVmjdKTMbZk3YqGlBIORfmrEGDNxuegX7DPmrrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eauXXfDNIK1xhHidqlUpQVKutaEvrA5QktZEwHBoEEtOlUeUragYSqJYU4nfcwThN
         qt1eTY6TETXWCZsX+KA/JPnzo5A8x2HFqWWUj5lup768TwdEMeLcgAAv9lKZ06Vk2O
         HXsonZNjl9zWYBbzcSC4ZWURU3WjzlwTz8xlSHhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 094/162] USB: adutux: fix interface sanity check
Date:   Thu, 19 Dec 2019 19:33:22 +0100
Message-Id: <20191219183213.512590332@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 3c11c4bed02b202e278c0f5c319ae435d7fb9815 upstream.

Make sure to use the current alternate setting when verifying the
interface descriptors to avoid binding to an invalid interface.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: 03270634e242 ("USB: Add ADU support for Ontrak ADU devices")
Cc: stable <stable@vger.kernel.org>     # 2.6.19
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191210112601.3561-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/adutux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -686,7 +686,7 @@ static int adu_probe(struct usb_interfac
 	init_waitqueue_head(&dev->read_wait);
 	init_waitqueue_head(&dev->write_wait);
 
-	iface_desc = &interface->altsetting[0];
+	iface_desc = &interface->cur_altsetting[0];
 
 	/* set up the endpoint information */
 	for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {


