Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83ED527C607
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730634AbgI2LlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:41:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730623AbgI2LlI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:41:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCDDA206E5;
        Tue, 29 Sep 2020 11:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379668;
        bh=bIp/ihUqsJ5r/9HbKQr3t1tGG+Kr4sjrJEFKzdV181Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCw55R/2K6O6uDOsYijwJMQ+NwAhFweWm2I4tsGKP9oii0HjU642oapsYqIHrZ+qx
         oiDfWO31MH1cUvdpxXPZAjbJQrPimAw3gu7JBw0aRxsbzHG83J5tODKZeI8xL1medo
         fP1/vOAvsTfVrT51OB8f6DNZuRRTbDB5OOmTU71s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 266/388] USB: EHCI: ehci-mv: fix less than zero comparison of an unsigned int
Date:   Tue, 29 Sep 2020 12:59:57 +0200
Message-Id: <20200929110023.340217190@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit a7f40c233a6b0540d28743267560df9cfb571ca9 ]

The comparison of hcd->irq to less than zero for an error check will
never be true because hcd->irq is an unsigned int.  Fix this by
assigning the int retval to the return of platform_get_irq and checking
this for the -ve error condition and assigning hcd->irq to retval.

Addresses-Coverity: ("Unsigned compared against 0")
Fixes: c856b4b0fdb5 ("USB: EHCI: ehci-mv: fix error handling in mv_ehci_probe()")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20200515165453.104028-1-colin.king@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ehci-mv.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/ehci-mv.c b/drivers/usb/host/ehci-mv.c
index 15b2e8910e9b7..b6f196f5e252e 100644
--- a/drivers/usb/host/ehci-mv.c
+++ b/drivers/usb/host/ehci-mv.c
@@ -156,11 +156,10 @@ static int mv_ehci_probe(struct platform_device *pdev)
 	hcd->rsrc_len = resource_size(r);
 	hcd->regs = ehci_mv->op_regs;
 
-	hcd->irq = platform_get_irq(pdev, 0);
-	if (hcd->irq < 0) {
-		retval = hcd->irq;
+	retval = platform_get_irq(pdev, 0);
+	if (retval < 0)
 		goto err_disable_clk;
-	}
+	hcd->irq = retval;
 
 	ehci = hcd_to_ehci(hcd);
 	ehci->caps = (struct ehci_caps *) ehci_mv->cap_regs;
-- 
2.25.1



