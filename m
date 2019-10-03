Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1183CA2CF
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733146AbfJCQJ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:09:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733163AbfJCQJZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:09:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1629215EA;
        Thu,  3 Oct 2019 16:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118964;
        bh=N9/Rg1+PUsp0y7YSgg+0BkRpyqmK9meFIu4cSaUzWUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lfc5b78UD3EXvTwRUO66a8P13oZIRCM4cadu458bUuuPFaRLfuTqr828XW7GT7fgz
         HDHWZuTDit/c7rO5T8AE3/G4hM5AKHNxPmsqYnL5zzK9rY08Jc/e/rIKhK1h9/OEVe
         iyYYPZV7YyAUnf2VDnvJ/gzVLdCRF47WJ91DbQ/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Borislav Petkov <bp@suse.de>,
        Thor Thayer <thor.thayer@linux.intel.com>,
        James Morse <james.morse@arm.com>,
        kernel-janitors@vger.kernel.org,
        linux-edac <linux-edac@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 074/185] EDAC/altera: Use the proper type for the IRQ status bits
Date:   Thu,  3 Oct 2019 17:52:32 +0200
Message-Id: <20191003154454.303806714@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 38983f56ad0dd..d92090b127de7 100644
--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -1646,6 +1646,7 @@ static void altr_edac_a10_irq_handler(struct irq_desc *desc)
 	struct altr_arria10_edac *edac = irq_desc_get_handler_data(desc);
 	struct irq_chip *chip = irq_desc_get_chip(desc);
 	int irq = irq_desc_get_irq(desc);
+	unsigned long bits;
 
 	dberr = (irq == edac->db_irq) ? 1 : 0;
 	sm_offset = dberr ? A10_SYSMGR_ECC_INTSTAT_DERR_OFST :
@@ -1655,7 +1656,8 @@ static void altr_edac_a10_irq_handler(struct irq_desc *desc)
 
 	regmap_read(edac->ecc_mgr_map, sm_offset, &irq_status);
 
-	for_each_set_bit(bit, (unsigned long *)&irq_status, 32) {
+	bits = irq_status;
+	for_each_set_bit(bit, &bits, 32) {
 		irq = irq_linear_revmap(edac->domain, dberr * 32 + bit);
 		if (irq)
 			generic_handle_irq(irq);
-- 
2.20.1



