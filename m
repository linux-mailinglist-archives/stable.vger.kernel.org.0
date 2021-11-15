Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1089451F04
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352000AbhKPAiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:45400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344552AbhKOTY6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3110F63688;
        Mon, 15 Nov 2021 18:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002785;
        bh=SdWdxXl4TzDeiPKkSH9rH2yuR/FJJhiw/pW90KXHfT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vhudA/r1msI6+HkHNFL2bI04br0XZFe26inPAJuK2cfDeAKcGBPEaxh4YODIj2UqF
         q9VBEEbdM1aPZkzqa5CVcRnsV/I9arhYoaTicLpL0YaxSWL3w+p3xhyDd4/jxnWHrM
         R7G5c22qrLLP4cIx5e4u7l+Vh5LTK/m9/FS9I930=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Novikov <novikov@ispras.ru>,
        Kirill Shilimanov <kirill.shilimanov@huawei.com>,
        Anton Vasilyev <vasilyev@ispras.ru>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 695/917] mtd: rawnand: intel: Fix potential buffer overflow in probe
Date:   Mon, 15 Nov 2021 18:03:10 +0100
Message-Id: <20211115165452.453638860@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit 46a0dc10fb32bec3e765e51bf71fbc070dc77ca3 ]

ebu_nand_probe() read the value of u32 variable "cs" from the device
firmware description and used it as the index for array ebu_host->cs
that can contain MAX_CS (2) elements at most. That could result in
a buffer overflow and various bad consequences later.

Fix the potential buffer overflow by restricting values of "cs" with
MAX_CS in probe.

Found by Linux Driver Verification project (linuxtesting.org).

Fixes: 0b1039f016e8 ("mtd: rawnand: Add NAND controller support on Intel LGM SoC")
Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Co-developed-by: Kirill Shilimanov <kirill.shilimanov@huawei.com>
Signed-off-by: Kirill Shilimanov <kirill.shilimanov@huawei.com>
Co-developed-by: Anton Vasilyev <vasilyev@ispras.ru>
Signed-off-by: Anton Vasilyev <vasilyev@ispras.ru>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210903082653.16441-1-novikov@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/intel-nand-controller.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mtd/nand/raw/intel-nand-controller.c b/drivers/mtd/nand/raw/intel-nand-controller.c
index b9784f3da7a11..7c1c80dae826a 100644
--- a/drivers/mtd/nand/raw/intel-nand-controller.c
+++ b/drivers/mtd/nand/raw/intel-nand-controller.c
@@ -609,6 +609,11 @@ static int ebu_nand_probe(struct platform_device *pdev)
 		dev_err(dev, "failed to get chip select: %d\n", ret);
 		return ret;
 	}
+	if (cs >= MAX_CS) {
+		dev_err(dev, "got invalid chip select: %d\n", cs);
+		return -EINVAL;
+	}
+
 	ebu_host->cs_num = cs;
 
 	resname = devm_kasprintf(dev, GFP_KERNEL, "nand_cs%d", cs);
-- 
2.33.0



