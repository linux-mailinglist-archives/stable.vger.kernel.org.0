Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67150157A79
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbgBJNXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:23:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:58560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728692AbgBJMhQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:16 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0C0620838;
        Mon, 10 Feb 2020 12:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338236;
        bh=ERMBUPI2b+Utm9Kh81/B4lVCmtApptrrQn2lLHq7HNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZZ8GqR0sKMGKaB27ZyivhJSTM8KhC7Co8qkmtmyRmvy5nqPk5MO9JkxpGeCDNfMJ
         6zKsq7MRE0GSIRiGoDy3uN12/zt4fqDS3Cp66Y0lH8vhNA0FNSxdyiMUYJx/RaYu/W
         qZdRLE7rl6hD06ZMThgWuEpcJayPUqVF2/2s9Vgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yurii Monakov <monakov.y@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 5.4 082/309] PCI: keystone: Fix outbound region mapping
Date:   Mon, 10 Feb 2020 04:30:38 -0800
Message-Id: <20200210122413.725235676@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yurii Monakov <monakov.y@gmail.com>

commit 2d0c3fbe43fa0e6fcb7a6c755c5f4cd702c0d2f4 upstream.

The Keystone outbound Address Translation Unit (ATU) maps PCI MMIO space in
8 MB windows.  When programming the ATU windows, we previously incremented
the starting address by 8, not 8 MB, so all the windows were mapped to the
first 8 MB.  Therefore, only 8 MB of MMIO space was accessible.

Update the loop so it increments the starting address by 8 MB, not 8, so
more MMIO space is accessible.

Fixes: e75043ad9792 ("PCI: keystone: Cleanup outbound window configuration")
Link: https://lore.kernel.org/r/20191004154811.GA31397@monakov-y.office.kontur-niirs.ru
Signed-off-by: Yurii Monakov <monakov.y@gmail.com>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Andrew Murray <andrew.murray@arm.com>
Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
Cc: stable@vger.kernel.org	# v4.20+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/controller/dwc/pci-keystone.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -422,7 +422,7 @@ static void ks_pcie_setup_rc_app_regs(st
 				   lower_32_bits(start) | OB_ENABLEN);
 		ks_pcie_app_writel(ks_pcie, OB_OFFSET_HI(i),
 				   upper_32_bits(start));
-		start += OB_WIN_SIZE;
+		start += OB_WIN_SIZE * SZ_1M;
 	}
 
 	val = ks_pcie_app_readl(ks_pcie, CMD_STATUS);


