Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D213C45D069
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 23:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352204AbhKXWxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 17:53:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:47200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352183AbhKXWxK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 17:53:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40BBC610A7;
        Wed, 24 Nov 2021 22:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637794200;
        bh=ZSzLTdk2b9z3k/fyHHyillUsNiBheOHzvRJy2RdFy7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UmSc8b3MJ2nZKTeCU7vAUGCws0PLmIz8Bo0swaorsi9Y2wLJisAkdUDCdTUSdiOgH
         Y0wMxRwwHgSJdcfT9D6oB7BqGimkuAGJd+aj2E/QRNIsf+EWKDdnOdhS3ktoAGvnBE
         2pbcl7NKRJ6gHMHW1ZdXUluVgTANzcd3hqryi4OtDFfrE7V2gK30UfaRvn3H/UIXZF
         EWL+FZYdr1rBVLE5ce2pAP2SYY2FaBjrHImj8J5+LRgf4aEcrM8M0UHSnlCbpVFrgb
         CSH4IQi2mDi9JDbzMjIiQZGO7K5az6LD7PmrOn7EJjleKUtAJZzLJF3KTmyhijVnTc
         sm2cEvaDemfFA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Bjorn Helgaas <helgaas@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.14 08/24] PCI: aardvark: Indicate error in 'val' when config read fails
Date:   Wed, 24 Nov 2021 23:49:17 +0100
Message-Id: <20211124224933.24275-9-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124224933.24275-1-kabel@kernel.org>
References: <20211124224933.24275-1-kabel@kernel.org>
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
 drivers/pci/host/pci-aardvark.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/host/pci-aardvark.c b/drivers/pci/host/pci-aardvark.c
index 3ad6b6245f94..ae67e5c3fe70 100644
--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -631,8 +631,10 @@ static int advk_pcie_rd_conf(struct pci_bus *bus, u32 devfn,
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

