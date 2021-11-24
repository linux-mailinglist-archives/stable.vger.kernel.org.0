Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E80745D0C5
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 00:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352470AbhKXXI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 18:08:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:51300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352469AbhKXXI2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 18:08:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 493CF60F36;
        Wed, 24 Nov 2021 23:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637795118;
        bh=vOjbdlTf/g0TKAy3nqk/YkjF2kNgB81vUccKJgJca4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tO4l01JKld9SYsNhxtG/4fFpYc2yB7TpIb+fqJMW/SLjJ0euvlKFx2lqlNryS337Z
         akB1dbKPRG1Zumkt40juWoBLUpeRhP+tKrCPzdYnUm3YswEQ0ssSk4a+0WCrydHtel
         RQ0up9rQQA4wiGUllasX5vmVu4FU5ybAS1nwcWYf7UbsQ9fMYnhpbdNSD3fg2HX4pY
         ectpfH9aYwaaZ9EKmpQ3KitVE26M7ivkH+u8sEY7Xkx2EuJKhSoS01DeAKXkfuBeNr
         mTI42QAIpmd8bBw1F0BkO1jwFGxiJvCFeoXweeqhTv5y4t9/2cy21VR0dNb0W2RHo2
         QDtkMGKiJKnBQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Bjorn Helgaas <helgaas@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.19 07/20] PCI: aardvark: Indicate error in 'val' when config read fails
Date:   Thu, 25 Nov 2021 00:04:47 +0100
Message-Id: <20211124230500.27109-8-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124230500.27109-1-kabel@kernel.org>
References: <20211124230500.27109-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit b1bd5714472cc72e14409f5659b154c765a76c65 upstream.

Most callers of config read do not check for return value. But most of the
ones that do, checks for error indication in 'val' variable.

This patch updates error handling in advk_pcie_rd_conf() function. If PIO
transfer fails then 'val' variable is set to 0xffffffff which indicates
failture.

Link: https://lore.kernel.org/r/20200528162604.GA323482@bjorn-Precision-5520
Link: https://lore.kernel.org/r/20200601130315.18895-1-pali@kernel.org
Reported-by: Bjorn Helgaas <helgaas@kernel.org>
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pci/controller/pci-aardvark.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index aaeb1c78076c..5837fff32f8e 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -596,8 +596,10 @@ static int advk_pcie_rd_conf(struct pci_bus *bus, u32 devfn,
 	advk_writel(pcie, 1, PIO_START);
 
 	ret = advk_pcie_wait_pio(pcie);
-	if (ret < 0)
+	if (ret < 0) {
+		*val = 0xffffffff;
 		return PCIBIOS_SET_FAILED;
+	}
 
 	/* Check PIO status and get the read result */
 	ret = advk_pcie_check_pio_status(pcie, val);
-- 
2.32.0

