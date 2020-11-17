Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB0B2B62D7
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732258AbgKQNcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:32:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:41924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732257AbgKQNcQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:32:16 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69F4324199;
        Tue, 17 Nov 2020 13:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619935;
        bh=DNNQKkI1vc0H8G6xN+OmjykYYAjW7If7P1QpcFfkIy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s0BsI6BrQrnBs/lZHdgXwjHCfuO8x3wxfjpxDLYrmoLFUO7ZKccbQstCJ2wSx7XDN
         CksNRctVVXSBpzshOJxgCrARtHcTh+6UkFokQlCL/BOBmC5jTuHkX+wQ5CmmLdcgXS
         JbIy9Y8L8LXo9YGsY7KxXjSwGih0ruFbuVCVgzE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boris V <borisvk@bstnet.org>,
        Rajat Jain <rajatja@google.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 026/255] PCI: Always enable ACS even if no ACS Capability
Date:   Tue, 17 Nov 2020 14:02:46 +0100
Message-Id: <20201117122140.217155377@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rajat Jain <rajatja@google.com>

[ Upstream commit 462b58fb033996e999cc213ed0b430d4f22a28fe ]

Some devices support ACS functionality even though they don't have a
spec-compliant ACS Capability; pci_enable_acs() has a quirk mechanism to
handle them.

We want to enable ACS whenever possible, but 52fbf5bdeeef ("PCI: Cache ACS
capability offset in device") inadvertently broke this by calling
pci_enable_acs() only if we find an ACS Capability.

This resulted in ACS not being enabled for these non-compliant devices,
which means devices can't be separated into different IOMMU groups, which
in turn means we may not be able to pass those devices through to VMs, as
reported by Boris V:

  https://lore.kernel.org/r/74aeea93-8a46-5f5a-343c-790d4c655da3@bstnet.org

Fixes: 52fbf5bdeeef ("PCI: Cache ACS capability offset in device")
Link: https://lore.kernel.org/r/20201028231545.4116866-1-rajatja@google.com
Reported-by: Boris V <borisvk@bstnet.org>
Signed-off-by: Rajat Jain <rajatja@google.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index e39c5499770ff..b2fed944903e2 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3503,8 +3503,13 @@ void pci_acs_init(struct pci_dev *dev)
 {
 	dev->acs_cap = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ACS);
 
-	if (dev->acs_cap)
-		pci_enable_acs(dev);
+	/*
+	 * Attempt to enable ACS regardless of capability because some Root
+	 * Ports (e.g. those quirked with *_intel_pch_acs_*) do not have
+	 * the standard ACS capability but still support ACS via those
+	 * quirks.
+	 */
+	pci_enable_acs(dev);
 }
 
 /**
-- 
2.27.0



