Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFDBFF1D5
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbfKPQPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:15:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:54362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728698AbfKPPrg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:47:36 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D21FD208D4;
        Sat, 16 Nov 2019 15:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919256;
        bh=7Jtc+OPj6lJy4u5O+w2EvlERek4r1QK+X5iuHSA0rN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1D8Of+tqmkSixvOYysSo1uRtCnRvQr4HMprdjTWRNzgsf+sXlkPUkdxEnK7JgfRdJ
         5jVZyE69dmE9Xj8H35w5KxoG1T1mtmMulTXhg/8QCOHrVa0UfOsQU+IYBWnsBU8nbu
         mxiquQa9MJZg5QyEfLkqifBkgHF24i6f7YH6QKh4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Borislav Petkov <bp@suse.de>,
        David Daney <david.daney@cavium.com>,
        Jan Glauber <jglauber@cavium.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergey Temerkhanov <s.temerkhanov@gmail.com>,
        linux-edac <linux-edac@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 009/150] EDAC, thunderx: Fix memory leak in thunderx_l2c_threaded_isr()
Date:   Sat, 16 Nov 2019 10:45:07 -0500
Message-Id: <20191116154729.9573-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit d8c27ba86a2fd806d3957e5a9b30e66dfca2a61d ]

Fix memory leak in L2c threaded interrupt handler.

 [ bp: Rewrite commit message. ]

Fixes: 41003396f932 ("EDAC, thunderx: Add Cavium ThunderX EDAC driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
CC: David Daney <david.daney@cavium.com>
CC: Jan Glauber <jglauber@cavium.com>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>
CC: Sergey Temerkhanov <s.temerkhanov@gmail.com>
CC: linux-edac <linux-edac@vger.kernel.org>
Link: http://lkml.kernel.org/r/20181013102843.GG16086@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/thunderx_edac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/thunderx_edac.c b/drivers/edac/thunderx_edac.c
index f35d87519a3e8..dfefa39e93519 100644
--- a/drivers/edac/thunderx_edac.c
+++ b/drivers/edac/thunderx_edac.c
@@ -1905,7 +1905,7 @@ static irqreturn_t thunderx_l2c_threaded_isr(int irq, void *irq_id)
 	default:
 		dev_err(&l2c->pdev->dev, "Unsupported device: %04x\n",
 			l2c->pdev->device);
-		return IRQ_NONE;
+		goto err_free;
 	}
 
 	while (CIRC_CNT(l2c->ring_head, l2c->ring_tail,
@@ -1927,7 +1927,7 @@ static irqreturn_t thunderx_l2c_threaded_isr(int irq, void *irq_id)
 		l2c->ring_tail++;
 	}
 
-	return IRQ_HANDLED;
+	ret = IRQ_HANDLED;
 
 err_free:
 	kfree(other);
-- 
2.20.1

