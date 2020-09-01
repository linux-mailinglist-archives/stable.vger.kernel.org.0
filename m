Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35778259A7A
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730383AbgIAQuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:50:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729784AbgIAP0h (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:26:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2943C20684;
        Tue,  1 Sep 2020 15:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973996;
        bh=DG9OHfeW8F6tLrVgd2ohMmxBtikjb2q/Qyou/zTJanM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nCFzsBvPwrSo900z9U2+8Fl33Lw4G40ZmuvXccmf3QTSedcX0wE9PE0+5QZfFTV/W
         s+qQ3tPq7XfFwdbpd033yvQvDZuQIiFoFYJ867gh29w5tq69p0A7ggKLPjIWASl3cn
         /MAHTOSYebNU/Tr3JMkrHZX7ln8lTHDOgFbLUuJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ding Hui <dinghui@sangfor.com.cn>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 100/125] xhci: Always restore EP_SOFT_CLEAR_TOGGLE even if ep reset failed
Date:   Tue,  1 Sep 2020 17:10:55 +0200
Message-Id: <20200901150939.506712849@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150934.576210879@linuxfoundation.org>
References: <20200901150934.576210879@linuxfoundation.org>
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
@@ -3154,10 +3154,11 @@ static void xhci_endpoint_reset(struct u
 
 	wait_for_completion(cfg_cmd->completion);
 
-	ep->ep_state &= ~EP_SOFT_CLEAR_TOGGLE;
 	xhci_free_command(xhci, cfg_cmd);
 cleanup:
 	xhci_free_command(xhci, stop_cmd);
+	if (ep->ep_state & EP_SOFT_CLEAR_TOGGLE)
+		ep->ep_state &= ~EP_SOFT_CLEAR_TOGGLE;
 }
 
 static int xhci_check_streams_endpoint(struct xhci_hcd *xhci,


