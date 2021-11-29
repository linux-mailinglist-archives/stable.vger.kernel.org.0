Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAD146242A
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbhK2WQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:16:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbhK2WQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:16:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B0EC127117;
        Mon, 29 Nov 2021 10:20:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02025B815BB;
        Mon, 29 Nov 2021 18:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27703C53FAD;
        Mon, 29 Nov 2021 18:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210027;
        bh=RdOOYOr4U+istaffW/9wRjlgmYrN9Wc8KkgSX8qOCRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EhxhHCwcwOD0fxqhewUieXGdAAAvGyE/j2SY3RRLUJ+Qyx3IISTAHKGEyk4HZogJe
         JiiGqHEbXPFBHPQEvVaqJQtLQriuG6/L3nPR4xFyEgYClmd3DCPEYMTsozlEVpACw8
         L+gKgBgfguANNLuvuq3KOn85YXFI6mEUwhH4gLq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Remi Pommarel <repk@triplefau.lt>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.19 18/69] PCI: aardvark: Wait for endpoint to be ready before training link
Date:   Mon, 29 Nov 2021 19:18:00 +0100
Message-Id: <20211129181704.259936734@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
References: <20211129181703.670197996@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Remi Pommarel <repk@triplefau.lt>

commit f4c7d053d7f77cd5c1a1ba7c7ce085ddba13d1d7 upstream.

When configuring pcie reset pin from gpio (e.g. initially set by
u-boot) to pcie function this pin goes low for a brief moment
asserting the PERST# signal. Thus connected device enters fundamental
reset process and link configuration can only begin after a minimal
100ms delay (see [1]).

Because the pin configuration comes from the "default" pinctrl it is
implicitly configured before the probe callback is called:

driver_probe_device()
  really_probe()
    ...
    pinctrl_bind_pins() /* Here pin goes from gpio to PCIE reset
                           function and PERST# is asserted */
    ...
    drv->probe()

[1] "PCI Express Base Specification", REV. 4.0
    PCI Express, February 19 2014, 6.6.1 Conventional Reset

Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-aardvark.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -318,6 +318,14 @@ static void advk_pcie_setup_hw(struct ad
 	reg |= PIO_CTRL_ADDR_WIN_DISABLE;
 	advk_writel(pcie, reg, PIO_CTRL);
 
+	/*
+	 * PERST# signal could have been asserted by pinctrl subsystem before
+	 * probe() callback has been called, making the endpoint going into
+	 * fundamental reset. As required by PCI Express spec a delay for at
+	 * least 100ms after such a reset before link training is needed.
+	 */
+	msleep(PCI_PM_D3COLD_WAIT);
+
 	/* Start link training */
 	reg = advk_readl(pcie, PCIE_CORE_LINK_CTRL_STAT_REG);
 	reg |= PCIE_CORE_LINK_TRAINING;


