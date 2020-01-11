Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3C9137DFA
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728919AbgAKKDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:03:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:35262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728832AbgAKKDn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:03:43 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BF7E2082E;
        Sat, 11 Jan 2020 10:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737022;
        bh=rn+RqjIAdDdOswpcLXNztAWhWJuyC+dPZFWOqYFTTr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lYT5XPrjG7zW2zh3kqg5cccgNgoyg5Jw0v5BZjC69ZKmjPIKNC6SZOLQj8N6G1RDR
         6JRHzYRaodcZQ1pqa5Bk+JYdwqW20KZcYQs9o3ipOa06AgSSBDLGqgflpWOlIDt6HW
         aDW/VFn7APITWHAmPtK4lluyILCN9aPdnKY6wh5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 64/91] spi: spi-cavium-thunderx: Add missing pci_release_regions()
Date:   Sat, 11 Jan 2020 10:49:57 +0100
Message-Id: <20200111094908.774870716@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094844.748507863@linuxfoundation.org>
References: <20200111094844.748507863@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit a841e2853e1afecc2ee692b8cc5bff606bc84e4c ]

The driver forgets to call pci_release_regions() in probe failure
and remove.
Add the missed calls to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Link: https://lore.kernel.org/r/20191206075500.18525-1-hslester96@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cavium-thunderx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-cavium-thunderx.c b/drivers/spi/spi-cavium-thunderx.c
index 877937706240..828fbbebc3c4 100644
--- a/drivers/spi/spi-cavium-thunderx.c
+++ b/drivers/spi/spi-cavium-thunderx.c
@@ -81,6 +81,7 @@ static int thunderx_spi_probe(struct pci_dev *pdev,
 
 error:
 	clk_disable_unprepare(p->clk);
+	pci_release_regions(pdev);
 	spi_master_put(master);
 	return ret;
 }
@@ -95,6 +96,7 @@ static void thunderx_spi_remove(struct pci_dev *pdev)
 		return;
 
 	clk_disable_unprepare(p->clk);
+	pci_release_regions(pdev);
 	/* Put everything in a known state. */
 	writeq(0, p->register_base + OCTEON_SPI_CFG(p));
 }
-- 
2.20.1



