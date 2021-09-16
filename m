Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7D440E6DB
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348928AbhIPR0C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:26:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348121AbhIPRX6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:23:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98C7661A4E;
        Thu, 16 Sep 2021 16:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810611;
        bh=wb0vY1I/LJsIEVsnaF93j3dbSb5rsRNBhEY+WdFPy2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yn9CjqTyOa3lNS0uf6cwAXwplGmUDP+uXxlvMGII9Gc5+6bgjJLB7XXsYkVEbaN65
         XdIkjwJTFboJejromgroRUSVZj8oDg6N8dumpzlUe0beOxpAAYpXfPI+a8PB5LRvEC
         iCGd9rpG+fwoPZGpMDb9Xw4Dm6JqBMbXhwt5TW3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Evgeny Novikov <novikov@ispras.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 197/432] USB: EHCI: ehci-mv: improve error handling in mv_ehci_enable()
Date:   Thu, 16 Sep 2021 17:59:06 +0200
Message-Id: <20210916155817.467117100@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit 61136a12cbed234374ec6f588af57c580b20b772 ]

mv_ehci_enable() did not disable and unprepare clocks in case of
failures of phy_init(). Besides, it did not take into account failures
of ehci_clock_enable() (in effect, failures of clk_prepare_enable()).
The patch fixes both issues and gets rid of redundant wrappers around
clk_prepare_enable() and clk_disable_unprepare() to simplify this a bit.

Found by Linux Driver Verification project (linuxtesting.org).

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Link: https://lore.kernel.org/r/20210708083056.21543-1-novikov@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/ehci-mv.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/host/ehci-mv.c b/drivers/usb/host/ehci-mv.c
index cffdc8d01b2a..8fd27249ad25 100644
--- a/drivers/usb/host/ehci-mv.c
+++ b/drivers/usb/host/ehci-mv.c
@@ -42,26 +42,25 @@ struct ehci_hcd_mv {
 	int (*set_vbus)(unsigned int vbus);
 };
 
-static void ehci_clock_enable(struct ehci_hcd_mv *ehci_mv)
+static int mv_ehci_enable(struct ehci_hcd_mv *ehci_mv)
 {
-	clk_prepare_enable(ehci_mv->clk);
-}
+	int retval;
 
-static void ehci_clock_disable(struct ehci_hcd_mv *ehci_mv)
-{
-	clk_disable_unprepare(ehci_mv->clk);
-}
+	retval = clk_prepare_enable(ehci_mv->clk);
+	if (retval)
+		return retval;
 
-static int mv_ehci_enable(struct ehci_hcd_mv *ehci_mv)
-{
-	ehci_clock_enable(ehci_mv);
-	return phy_init(ehci_mv->phy);
+	retval = phy_init(ehci_mv->phy);
+	if (retval)
+		clk_disable_unprepare(ehci_mv->clk);
+
+	return retval;
 }
 
 static void mv_ehci_disable(struct ehci_hcd_mv *ehci_mv)
 {
 	phy_exit(ehci_mv->phy);
-	ehci_clock_disable(ehci_mv);
+	clk_disable_unprepare(ehci_mv->clk);
 }
 
 static int mv_ehci_reset(struct usb_hcd *hcd)
-- 
2.30.2



