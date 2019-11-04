Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E51DEEFEC
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730824AbfKDVwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:52:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:46376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730796AbfKDVwo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:52:44 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7350B217F5;
        Mon,  4 Nov 2019 21:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904364;
        bh=eB8OcREBndT+A5hyfQrTyGkWl3QxuRF+jZflQikaaIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v1QRgc2XDSMATgUVC/XwdHbHwMuX1O5BuGUuLA6v0oOhoLYXit7AIZpZCqhccYYWq
         we6mZaR4GOOAWkLBdXnIz0WGQobQW3ysO83wz69V5igXgLJ9c50lRI1RmurdUIjmuY
         VZ8EYJa34c46zZf3Bbg5YqIy/PR6TUdLW/BDtFQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Van Asbroeck <TheSven73@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sinan Kaya <okaya@kernel.org>,
        Frederick Lawler <fred@fredlawl.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 22/95] PCI/PME: Fix possible use-after-free on remove
Date:   Mon,  4 Nov 2019 22:44:20 +0100
Message-Id: <20191104212052.393906364@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



