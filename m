Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE98329B99C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802646AbgJ0Puk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S368857AbgJ0PmE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:42:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACAA0223FB;
        Tue, 27 Oct 2020 15:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813324;
        bh=M/kzpbcip4o+7zdV9ri29oK4Vwl6RhReR5vq50WidzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qq8q0zRzo5D4PxuECF9/oqeBEMU3NWkpGJ9rlelznPvNpD+2XZXXEO9Jtsj9v6Lh+
         t+Ls+S88XyvlmSyNTI1CLzYLP+3wR40mPOP0F2sTD7Vp0HPt9OfUgxzhabGRZsC4V7
         XrPCOQdDhjAcrEsBNpJLpsXh5Pl/UvOTfuHm/IB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Novikov <novikov@ispras.ru>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 473/757] mtd: rawnand: vf610: disable clk on error handling path in probe
Date:   Tue, 27 Oct 2020 14:52:03 +0100
Message-Id: <20201027135512.698507632@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit cb7dc3178a9862614b1e7567d77f4679f027a074 ]

vf610_nfc_probe() does not invoke clk_disable_unprepare() on one error
handling path. The patch fixes that.

Found by Linux Driver Verification project (linuxtesting.org).

Fixes: 6f0ce4dfc5a3 ("mtd: rawnand: vf610: Avoid a potential NULL pointer dereference")
Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200806072634.23528-1-novikov@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/vf610_nfc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/vf610_nfc.c b/drivers/mtd/nand/raw/vf610_nfc.c
index 7248c59011836..fcca45e2abe20 100644
--- a/drivers/mtd/nand/raw/vf610_nfc.c
+++ b/drivers/mtd/nand/raw/vf610_nfc.c
@@ -852,8 +852,10 @@ static int vf610_nfc_probe(struct platform_device *pdev)
 	}
 
 	of_id = of_match_device(vf610_nfc_dt_ids, &pdev->dev);
-	if (!of_id)
-		return -ENODEV;
+	if (!of_id) {
+		err = -ENODEV;
+		goto err_disable_clk;
+	}
 
 	nfc->variant = (enum vf610_nfc_variant)of_id->data;
 
-- 
2.25.1



