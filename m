Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9C71FDD99
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731826AbgFRB1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:27:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731817AbgFRB1O (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:27:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 354F420B1F;
        Thu, 18 Jun 2020 01:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443634;
        bh=oOn5MZYvIf+AOlHExtHn2fgo34KzySZ2AJ7C0utEokw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5ezpX05J/sYGYWKEaLrq40SjWYhSWWRKkV+EbaOeF3jy6NAzKRXJ15BQMYxccek3
         kGjqj/Lp3q9g3UDd6URUQ5qN73sCBh+QeKuw584PR6inchY7buLGrF4tU6o/N8Idd5
         lr6sNxX2IE0W4m8ZOmJM3XCm5Y5BVFn1RhmK7QiY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 057/108] PCI: Fix pci_register_host_bridge() device_register() error handling
Date:   Wed, 17 Jun 2020 21:25:09 -0400
Message-Id: <20200618012600.608744-57-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012600.608744-1-sashal@kernel.org>
References: <20200618012600.608744-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit 1b54ae8327a4d630111c8d88ba7906483ec6010b ]

If device_register() has an error, we should bail out of
pci_register_host_bridge() rather than continuing on.

Fixes: 37d6a0a6f470 ("PCI: Add pci_register_host_bridge() interface")
Link: https://lore.kernel.org/r/20200513223859.11295-1-robh@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index e23bfd9845b1..61ec17dd47e5 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -792,9 +792,10 @@ static int pci_register_host_bridge(struct pci_host_bridge *bridge)
 		goto free;
 
 	err = device_register(&bridge->dev);
-	if (err)
+	if (err) {
 		put_device(&bridge->dev);
-
+		goto free;
+	}
 	bus->bridge = get_device(&bridge->dev);
 	device_enable_async_suspend(bus->bridge);
 	pci_set_bus_of_node(bus);
-- 
2.25.1

