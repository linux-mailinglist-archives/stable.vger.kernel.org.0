Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D004E26F21D
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbgIRC42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:56:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbgIRCHF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1868423976;
        Fri, 18 Sep 2020 02:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394805;
        bh=bIp/ihUqsJ5r/9HbKQr3t1tGG+Kr4sjrJEFKzdV181Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NOsLTJrgqT/U/UJUjVazxrVzsYtCp2r07mtAJL2yPCLpLmYuzpgdG8GJV+n308Bmq
         n27U46Iw04NGoZZzrFOCl/oAks2brawbRFoVGzd2cM7G1dlt4Jf83lK4uQavUi9Ts+
         esNkNAKKk7L6c9B1tyqaKYNEaN2sQ3FnZcx8zIZU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 274/330] USB: EHCI: ehci-mv: fix less than zero comparison of an unsigned int
Date:   Thu, 17 Sep 2020 22:00:14 -0400
Message-Id: <20200918020110.2063155-274-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

