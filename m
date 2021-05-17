Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9198F3833E2
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241019AbhEQPDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:03:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:32850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241268AbhEQPBG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:01:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B28D261364;
        Mon, 17 May 2021 14:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261632;
        bh=RUVuHS+F/d/46/TBsNU+jXzy2X9vN5usIJ0/c1wl9MI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MytxeLpSSHIMJdThqaX+DTIMrwpKPGoqTKOSilxAr2or5d4od8QJAmhZzFybscMAB
         cYZ15DESk2Qck4bNXU8ouKeXUOHrwxGJOfeis/2zECV9jM+/gIyo1WJm4KuhAMPHTr
         MdvA/BGODjgAGHdOaxBQ/ZKldgFkpkyHNQ7H4vtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 120/329] PCI: Release OF node in pci_scan_device()s error path
Date:   Mon, 17 May 2021 16:00:31 +0200
Message-Id: <20210517140306.169765059@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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
index 953f15abc850..be51670572fa 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2353,6 +2353,7 @@ static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
 	pci_set_of_node(dev);
 
 	if (pci_setup_device(dev)) {
+		pci_release_of_node(dev);
 		pci_bus_put(dev->bus);
 		kfree(dev);
 		return NULL;
-- 
2.30.2



