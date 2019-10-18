Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5787DDD217
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387783AbfJRWI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:08:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387759AbfJRWI0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:08:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD3442245C;
        Fri, 18 Oct 2019 22:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436505;
        bh=eB8OcREBndT+A5hyfQrTyGkWl3QxuRF+jZflQikaaIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0tqOiDE0sKqrvGZcosVqo3EHIat64BeZ7tRzUvQTeO3DJHixqyEdPovHsuzz0dXYK
         v6x0xpkNBC334pQC/fdduaA94ZpDVk7hsl81X0PJOJA/iivZmbjVXkfq+V/K357l2Q
         MqsQZER4Cq85vIlyuUMPnPqtbAAn1HdpW3eHoUbQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Sven Van Asbroeck <TheSven73@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sinan Kaya <okaya@kernel.org>,
        Frederick Lawler <fred@fredlawl.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 17/56] PCI/PME: Fix possible use-after-free on remove
Date:   Fri, 18 Oct 2019 18:07:14 -0400
Message-Id: <20191018220753.10002-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220753.10002-1-sashal@kernel.org>
References: <20191018220753.10002-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

[ Upstream commit 7cf58b79b3072029af127ae865ffc6f00f34b1f8 ]

In remove(), ensure that the PME work cannot run after kfree() is called.
Otherwise, this could result in a use-after-free.

This issue was detected with the help of Coccinelle.

Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Sinan Kaya <okaya@kernel.org>
Cc: Frederick Lawler <fred@fredlawl.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/pme.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/pcie/pme.c b/drivers/pci/pcie/pme.c
index c2e6e3d1073f8..5500660bbb104 100644
--- a/drivers/pci/pcie/pme.c
+++ b/drivers/pci/pcie/pme.c
@@ -441,6 +441,7 @@ static void pcie_pme_remove(struct pcie_device *srv)
 
 	pcie_pme_disable_interrupt(srv->port, data);
 	free_irq(srv->irq, srv);
+	cancel_work_sync(&data->work);
 	kfree(data);
 }
 
-- 
2.20.1

