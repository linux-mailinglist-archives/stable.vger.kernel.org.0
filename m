Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD4627CB30
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbgI2MZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729597AbgI2Ldh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:33:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 816E923BDF;
        Tue, 29 Sep 2020 11:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378866;
        bh=aWLWRDXTPVtOl+4fi6ZSpPtT6elC4qoGlPuzJAweLow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2F717piLk2e0KJqlIFCchEiSBwNWTDNmPX2Wr3+G/PVPHvDBaWsJmZL/pxIIdrscn
         Jx2Y/WmNm0Vk5lHjIiXH06FFVCIZG9NM69sM1ARaS5IfFoTwcHzO5ZQLYH+T61g9hC
         MCd+q6wd0umwlSJr+VKs2g8iC4aNv92mtNdZg/to=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 167/245] USB: EHCI: ehci-mv: fix less than zero comparison of an unsigned int
Date:   Tue, 29 Sep 2020 13:00:18 +0200
Message-Id: <20200929105955.104463789@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
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
index 4edcd7536a01b..9d93e7441bbca 100644
--- a/drivers/usb/host/ehci-mv.c
+++ b/drivers/usb/host/ehci-mv.c
@@ -192,11 +192,10 @@ static int mv_ehci_probe(struct platform_device *pdev)
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



