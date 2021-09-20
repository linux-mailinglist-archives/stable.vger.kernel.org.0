Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B99D4121EC
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350925AbhITSLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:11:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1359291AbhITSJ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:09:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FDD463266;
        Mon, 20 Sep 2021 17:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158362;
        bh=tCPOK3YeWzyNo8fisCoCf+sroSO1ILpDgtf1LlYprfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YXdJ0NeWlt7Sibwr1fXo6LgFm+RloNHGStDtd+B4hA8lg/k6zgjKlZyVlYj5w5Xro
         r/t03Zndv8UrwG2jPkHsppKlAy9qfySy+lXVCUA4qoW4PP+tDckW24Xc0Se8Rz2ztQ
         rcZD7IY6AMpj/Tpy/NNAww2TSsVkK6ObBaYlt6Ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Evgeny Novikov <novikov@ispras.ru>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/260] USB: EHCI: ehci-mv: improve error handling in mv_ehci_enable()
Date:   Mon, 20 Sep 2021 18:41:48 +0200
Message-Id: <20210920163934.196632182@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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
index b6f196f5e252..b0e0f8ea98a9 100644
--- a/drivers/usb/host/ehci-mv.c
+++ b/drivers/usb/host/ehci-mv.c
@@ -41,26 +41,25 @@ struct ehci_hcd_mv {
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



