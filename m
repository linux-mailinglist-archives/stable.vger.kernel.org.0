Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24AC838A78B
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbhETKjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:39:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237348AbhETKhi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:37:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7482F61184;
        Thu, 20 May 2021 09:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504470;
        bh=kGG51gVk4oUe1HtB/oZPpqkTAh6QD9POEA+VOCSGNPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0+X7pfiQzMmhi5VbIfpAo8f9/t4Cuc91pbt9XK6jvOgBhiK8+hHJym6k2ofzBq2IA
         x0EkLuz71NU9KhcK24uxExeMOo1NuwG0SBC189FRWTVIOpFiYdXfFVAJ4MysLRFmtt
         mo9A+uFeYmfZi6LHSJtcP52uKZeHBIHZWQdzz7HU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 260/323] PCI: Release OF node in pci_scan_device()s error path
Date:   Thu, 20 May 2021 11:22:32 +0200
Message-Id: <20210520092129.119087446@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit c99e755a4a4c165cad6effb39faffd0f3377c02d ]

In pci_scan_device(), if pci_setup_device() fails for any reason, the code
will not release device's of_node by calling pci_release_of_node().  Fix
that by calling the release function.

Fixes: 98d9f30c820d ("pci/of: Match PCI devices to OF nodes dynamically")
Link: https://lore.kernel.org/r/20210124232826.1879-1-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 55ece07e584a..e716d8bba227 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2014,6 +2014,7 @@ static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
 	pci_set_of_node(dev);
 
 	if (pci_setup_device(dev)) {
+		pci_release_of_node(dev);
 		pci_bus_put(dev->bus);
 		kfree(dev);
 		return NULL;
-- 
2.30.2



