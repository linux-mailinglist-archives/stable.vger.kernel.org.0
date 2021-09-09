Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94AE5404E05
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239704AbhIIMH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:07:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350160AbhIIMFn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:05:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7431E61880;
        Thu,  9 Sep 2021 11:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188041;
        bh=wb0vY1I/LJsIEVsnaF93j3dbSb5rsRNBhEY+WdFPy2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKhnbhJt8+GnKMHCzwxpYxhmdA44h1shB44wfh9BvVZrqDJYudvxWa9g//J4eNUjL
         obJjk77bRAWpDKwxZcqqQ4wOqN4At8lPIAEV6vEZo/bWQmxjbHGaskLHM36tTXVFy9
         6GsHmoCC/PCu/JjXlrm67i6PVaW2nitKMrCSnVW4xeiK0Dk9LaIZKE3Z5YmfptGh+i
         +GbCdxO7yJFAO7vommeSQm5oWrjdOrLw7NcX8hyQ4noKYVJiVW3XHQejRiP2J2uWzW
         i/GDDWslUOZrT1wW/5c77sONNkZwKE3Rcp7kSFdI37gG8ksQ83J+s2julesMfuN8oJ
         QvRt30tgH3Tcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 035/219] USB: EHCI: ehci-mv: improve error handling in mv_ehci_enable()
Date:   Thu,  9 Sep 2021 07:43:31 -0400
Message-Id: <20210909114635.143983-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

