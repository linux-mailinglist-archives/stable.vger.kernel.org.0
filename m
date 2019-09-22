Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2E0BAA99
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731635AbfIVT21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:28:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:48070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404533AbfIVSuq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:50:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94C76214AF;
        Sun, 22 Sep 2019 18:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178245;
        bh=PAolAwDXSt+ysTH+9yNnx2oXETE5pOv1wJqyLHv1WTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xYPssyJQBNGz3+1HkJffhekzMR11yuEvNANIvJv/rY0PSC+UHyuQfjjo6tlqnQtXN
         58Kdm2zBG+7bPLamX0ov4yFsNPRnqbtGRLwbQhNJJsiRVnGBhemnJDs7x2NAjx4MZT
         GJ0f2QbM/CfBsIUXJ5GFjEBNP5WJeijl0EjcSioI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Borislav Petkov <bp@suse.de>,
        Thor Thayer <thor.thayer@linux.intel.com>,
        James Morse <james.morse@arm.com>,
        kernel-janitors@vger.kernel.org,
        linux-edac <linux-edac@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 039/185] EDAC/altera: Use the proper type for the IRQ status bits
Date:   Sun, 22 Sep 2019 14:46:57 -0400
Message-Id: <20190922184924.32534-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 8faa1cf6ed82f33009f63986c3776cc48af1b7b2 ]

Smatch complains about the cast of a u32 pointer to unsigned long:

  drivers/edac/altera_edac.c:1878 altr_edac_a10_irq_handler()
  warn: passing casted pointer '&irq_status' to 'find_first_bit()'

This code wouldn't work on a 64 bit big endian system because it would
read past the end of &irq_status.

 [ bp: massage. ]

Fixes: 13ab8448d2c9 ("EDAC, altera: Add ECC Manager IRQ controller support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Thor Thayer <thor.thayer@linux.intel.com>
Cc: James Morse <james.morse@arm.com>
Cc: kernel-janitors@vger.kernel.org
Cc: linux-edac <linux-edac@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Link: https://lkml.kernel.org/r/20190624134717.GA1754@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/altera_edac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/edac/altera_edac.c b/drivers/edac/altera_edac.c
index 8816f74a22b4a..2d12b94eccda2 100644
--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -1829,6 +1829,7 @@ static void altr_edac_a10_irq_handler(struct irq_desc *desc)
 	struct altr_arria10_edac *edac = irq_desc_get_handler_data(desc);
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 	int irq = irq_desc_get_irq(desc);
+	unsigned long bits;
 
 	dberr = (irq == edac->db_irq) ? 1 : 0;
 	sm_offset = dberr ? A10_SYSMGR_ECC_INTSTAT_DERR_OFST :
@@ -1838,7 +1839,8 @@ static void altr_edac_a10_irq_handler(struct irq_desc *desc)
 
 	regmap_read(edac->ecc_mgr_map, sm_offset, &irq_status);
 
-	for_each_set_bit(bit, (unsigned long *)&irq_status, 32) {
+	bits = irq_status;
+	for_each_set_bit(bit, &bits, 32) {
 		irq = irq_linear_revmap(edac->domain, dberr * 32 + bit);
 		if (irq)
 			generic_handle_irq(irq);
-- 
2.20.1

