Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454D42595EC
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729406AbgIAP5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:57:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731778AbgIAPoU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:44:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E9812064B;
        Tue,  1 Sep 2020 15:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975059;
        bh=aXpEuyQ/p1Qd1rdpw+8abJdNj/g6K6GnX7Nll9ucIto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YtJO2cVjlVZNG9KTiJy0drSkfREv2WscHCAme4zaTY947AG50iFNxyW9rb0ez8gSQ
         ou8KWVOBB5er1p/bCsA0/xhn+gFbN9z2pexAeXtvCZxen4OLlLWx+ZWtl2eizKrnlO
         JVTFxK0mk+M7d37cBdIO9yy5P9SJX78/92GRKA8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Jun <jun.li@nxp.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.8 194/255] usb: host: xhci: fix ep context print mismatch in debugfs
Date:   Tue,  1 Sep 2020 17:10:50 +0200
Message-Id: <20200901151009.981931776@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Jun <jun.li@nxp.com>

commit 0077b1b2c8d9ad5f7a08b62fb8524cdb9938388f upstream.

dci is 0 based and xhci_get_ep_ctx() will do ep index increment to get
the ep context.

[rename dci to ep_index -Mathias]
Cc: stable <stable@vger.kernel.org> # v4.15+
Fixes: 02b6fdc2a153 ("usb: xhci: Add debugfs interface for xHCI driver")
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200821091549.20556-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-debugfs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/xhci-debugfs.c
+++ b/drivers/usb/host/xhci-debugfs.c
@@ -273,7 +273,7 @@ static int xhci_slot_context_show(struct
 
 static int xhci_endpoint_context_show(struct seq_file *s, void *unused)
 {
-	int			dci;
+	int			ep_index;
 	dma_addr_t		dma;
 	struct xhci_hcd		*xhci;
 	struct xhci_ep_ctx	*ep_ctx;
@@ -282,9 +282,9 @@ static int xhci_endpoint_context_show(st
 
 	xhci = hcd_to_xhci(bus_to_hcd(dev->udev->bus));
 
-	for (dci = 1; dci < 32; dci++) {
-		ep_ctx = xhci_get_ep_ctx(xhci, dev->out_ctx, dci);
-		dma = dev->out_ctx->dma + dci * CTX_SIZE(xhci->hcc_params);
+	for (ep_index = 0; ep_index < 31; ep_index++) {
+		ep_ctx = xhci_get_ep_ctx(xhci, dev->out_ctx, ep_index);
+		dma = dev->out_ctx->dma + (ep_index + 1) * CTX_SIZE(xhci->hcc_params);
 		seq_printf(s, "%pad: %s\n", &dma,
 			   xhci_decode_ep_context(le32_to_cpu(ep_ctx->ep_info),
 						  le32_to_cpu(ep_ctx->ep_info2),


