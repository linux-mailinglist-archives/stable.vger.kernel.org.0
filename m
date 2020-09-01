Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907752593FD
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbgIAPdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:33:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731147AbgIAPdt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:33:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DE6C20E65;
        Tue,  1 Sep 2020 15:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974428;
        bh=XZofRMEuhipyLINL8hAHelkVwYgHCkVlOIbGVYdKOns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i00tafQZhVAfqXlBHgbwWdMADjSMnGAhnFrqYe8Q7SQDNNH3k1OEd3d43DeT+IfM/
         i/F1q6WirAj0v6wVlxJm1Ag+YVJeE/giPY3MWumG8y6ypAKakg/PToM9oDrqiMzA7P
         +fejyNACFB/UiLEHhrPD4TfVA/fsKWLU1nl218Mg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ding Hui <dinghui@sangfor.com.cn>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.4 173/214] xhci: Always restore EP_SOFT_CLEAR_TOGGLE even if ep reset failed
Date:   Tue,  1 Sep 2020 17:10:53 +0200
Message-Id: <20200901151001.266477923@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ding Hui <dinghui@sangfor.com.cn>

commit f1ec7ae6c9f8c016db320e204cb519a1da1581b8 upstream.

Some device drivers call libusb_clear_halt when target ep queue
is not empty. (eg. spice client connected to qemu for usb redir)

Before commit f5249461b504 ("xhci: Clear the host side toggle
manually when endpoint is soft reset"), that works well.
But now, we got the error log:

    EP not empty, refuse reset

xhci_endpoint_reset failed and left ep_state's EP_SOFT_CLEAR_TOGGLE
bit still set

So all the subsequent urb sumbits to the ep will fail with the
warn log:

    Can't enqueue URB while manually clearing toggle

We need to clear ep_state EP_SOFT_CLEAR_TOGGLE bit after
xhci_endpoint_reset, even if it failed.

Fixes: f5249461b504 ("xhci: Clear the host side toggle manually when endpoint is soft reset")
Cc: stable <stable@vger.kernel.org> # v4.17+
Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200821091549.20556-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3236,10 +3236,11 @@ static void xhci_endpoint_reset(struct u
 
 	wait_for_completion(cfg_cmd->completion);
 
-	ep->ep_state &= ~EP_SOFT_CLEAR_TOGGLE;
 	xhci_free_command(xhci, cfg_cmd);
 cleanup:
 	xhci_free_command(xhci, stop_cmd);
+	if (ep->ep_state & EP_SOFT_CLEAR_TOGGLE)
+		ep->ep_state &= ~EP_SOFT_CLEAR_TOGGLE;
 }
 
 static int xhci_check_streams_endpoint(struct xhci_hcd *xhci,


