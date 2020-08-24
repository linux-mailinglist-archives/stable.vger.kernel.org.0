Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30CE324FA42
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbgHXJy5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:54:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgHXIhN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:37:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 919D9207DF;
        Mon, 24 Aug 2020 08:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258233;
        bh=ku/z8qYLkIM9eEL4YUUwvaQZEet4R35N8mWyYHjbq10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j/iWwBKoGKYUCeuwWHmMtvFDJX5MSxNhhQuibiyQuTfKQBD551cCJuEaS2nOVS+a7
         E8FS/dwEELD3nmKzdq6tdgjHCh0bsq+lSyJWMR7AAgkOMt8Wf4P9zOCMqO5Bbenmkt
         kH/NWSV6/c/UYvReth/Lm9l90WPReIzuJddueom4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 116/148] scsi: ufs: Fix interrupt error message for shared interrupts
Date:   Mon, 24 Aug 2020 10:30:14 +0200
Message-Id: <20200824082419.568091081@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 6337f58cec030b34ced435b3d9d7d29d63c96e36 ]

The interrupt might be shared, in which case it is not an error for the
interrupt handler to be called when the interrupt status is zero, so don't
print the message unless there was enabled interrupt status.

Link: https://lore.kernel.org/r/20200811133936.19171-1-adrian.hunter@intel.com
Fixes: 9333d7757348 ("scsi: ufs: Fix irq return code")
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 69c7c039b5fac..136b863bc1d45 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6013,7 +6013,7 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 		intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
 	} while (intr_status && --retries);
 
-	if (retval == IRQ_NONE) {
+	if (enabled_intr_status && retval == IRQ_NONE) {
 		dev_err(hba->dev, "%s: Unhandled interrupt 0x%08x\n",
 					__func__, intr_status);
 		ufshcd_dump_regs(hba, 0, UFSHCI_REG_SPACE_SIZE, "host_regs: ");
-- 
2.25.1



