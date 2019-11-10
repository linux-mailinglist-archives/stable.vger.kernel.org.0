Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEFAEF66E2
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfKJCkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:40:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:33858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbfKJCkg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:40:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 729F021882;
        Sun, 10 Nov 2019 02:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353636;
        bh=rOUJTLLDLcIrzkoJgb4s/aQqCIxC8gU62BXczugNZz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OR9kiKAiNcut7fdY0xEXLRSQK9gakDBA9WKIGAungn7Xf+4j5OVIqzDwdzwLeDgkY
         lvWgOhmx9Pl7vHXtRlgC7nIKz2QNVecZ4R/rEID7UgwSOWqMU1mPri8Qu6/+5CPEGH
         LJmpryqkVo4e+qJ6vRb4kpnb9THpvS7P09qm2rTI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Meelis Roos <mroos@linux.ee>, Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 019/191] ipmi_si_pci: fix NULL device in ipmi_si error message
Date:   Sat,  9 Nov 2019 21:37:21 -0500
Message-Id: <20191110024013.29782-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>

[ Upstream commit 01508d9ebf4fc863f2fc4561c390bf4b7c3301a6 ]

I noticed that 4.17.0 logs the follwing during ipmi_si setup:

 ipmi_si 0000:01:04.6: probing via PCI
 (NULL device *): Could not setup I/O space
 ipmi_si 0000:01:04.6: [mem 0xf5ef0000-0xf5ef00ff] regsize 1 spacing 1 irq 21

Fix the "NULL device *) by moving io.dev assignment before its potential
use by ipmi_pci_probe_regspacing().

Result:
 ipmi_si 0000:01:04.6: probing via PCI
 ipmi_si 0000:01:04.6: Could not setup I/O space
 ipmi_si 0000:01:04.6: [mem 0xf5ef0000-0xf5ef00ff] regsize 1 spacing 1 irq 21

Signed-off-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_si_pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_pci.c b/drivers/char/ipmi/ipmi_si_pci.c
index f54ca6869ed2c..022e03634ce2a 100644
--- a/drivers/char/ipmi/ipmi_si_pci.c
+++ b/drivers/char/ipmi/ipmi_si_pci.c
@@ -120,6 +120,8 @@ static int ipmi_pci_probe(struct pci_dev *pdev,
 	}
 	io.addr_data = pci_resource_start(pdev, 0);
 
+	io.dev = &pdev->dev;
+
 	io.regspacing = ipmi_pci_probe_regspacing(&io);
 	io.regsize = DEFAULT_REGSIZE;
 	io.regshift = 0;
@@ -128,8 +130,6 @@ static int ipmi_pci_probe(struct pci_dev *pdev,
 	if (io.irq)
 		io.irq_setup = ipmi_std_irq_setup;
 
-	io.dev = &pdev->dev;
-
 	dev_info(&pdev->dev, "%pR regsize %d spacing %d irq %d\n",
 		&pdev->resource[0], io.regsize, io.regspacing, io.irq);
 
-- 
2.20.1

