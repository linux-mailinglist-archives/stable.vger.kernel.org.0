Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049CE452F7E
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 11:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbhKPKwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 05:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234325AbhKPKwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 05:52:05 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767C4C061570
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 02:49:01 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id n26so13185825pff.3
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 02:49:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+ubYjqdvkqE78QDA/znztFhltIrAjEQ86b9eBrLM2LE=;
        b=q7+wL343vAdlQBCXH0jLHz3oVoKKCUVMqZ0JeuNSEA8wN8rar7Fru/MatkkTyo9NSM
         AO0aypEiRxb/uEWSgxhfip7XaGeE7WibuQb1Y82Wd7pCR+xbVC0qjfDSMjNmEwwGydJV
         ONBd43Fi/MHRPyF9CTEbYmWHHQhV4M4QgsOFZ+xgojPdfCr9D3r0hgyAvI5zv3G/vVUI
         3wxjLtc3km4fmBHRgmlqXtsBfcwzs16KxkPw1huBAN23XfXb537Rxdw0VZS2e4yndQXC
         YFOs8zdzPj3XIk2lEv2u1eBnU4Y8+VMXs7c0yZfJOZS26VFL9bbkAznQ0kfeZMLfSUMd
         f/Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+ubYjqdvkqE78QDA/znztFhltIrAjEQ86b9eBrLM2LE=;
        b=6p13Mkk7OKjcgGqZOcN7wdjJRoxAN84E/MPLitJ8cCeIMGNFd9onyefEmAkHWW9M0Y
         G3imRH4mqPa235NM0+kg/SaeCWF0p88rp0yv4U90Jc6Nv+odpS5q0Ww1Jg4D+uAEt1Q/
         bHKegJKM5IrnNfITONJHhEjTgV69vUkbQFhQ5oDO/sUEAx4KqhxZA+GUyUgGaHdJKYov
         VqShbaXSZUKyRF/QGxrqpwqLVCcGDQ5Eq3RpEIGCLEmKQclk2PA4JYcTcWfxwolfSFjW
         NoKvwWM+LmA7g9P4Uq+HsSH9eki9/A2RVyPr+AWx/sDT8CQAyKn7mjVcGDJ6z/gpt7mK
         eEpA==
X-Gm-Message-State: AOAM53151ycmN3Bzw+FYMySJ2cjxTxVZUU90o16+CJb2+M2HRMEBtegK
        f2Yyvv6tMTkb/gS5xec3xMk=
X-Google-Smtp-Source: ABdhPJz6EbeguKjmfLV1R238sI7ugRdnPNKZogLectgrt06SIoPMqM0ji1rHrvyIsEpM7yuPXy/tlA==
X-Received: by 2002:aa7:8019:0:b0:44d:d761:6f79 with SMTP id j25-20020aa78019000000b0044dd7616f79mr40041804pfi.3.1637059741007;
        Tue, 16 Nov 2021 02:49:01 -0800 (PST)
Received: from lenovo.spreadtrum.com ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id p2sm2024375pja.55.2021.11.16.02.48.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Nov 2021 02:49:00 -0800 (PST)
From:   Orson Zhai <orsonzhai@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>, orson.zhai@gmail.com,
        Orson Zhai <orson.zhai@unisoc.com>
Subject: [PATCH 1/2] scsi: ufs: Fix interrupt error message for shared interrupts
Date:   Tue, 16 Nov 2021 18:48:30 +0800
Message-Id: <1637059711-11746-2-git-send-email-orsonzhai@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1637059711-11746-1-git-send-email-orsonzhai@gmail.com>
References: <1637059711-11746-1-git-send-email-orsonzhai@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 6337f58cec030b34ced435b3d9d7d29d63c96e36 ]

The interrupt might be shared, in which case it is not an error for the
interrupt handler to be called when the interrupt status is zero, so don't
print the message unless there was enabled interrupt status.

Change-Id: Ic18aa63b43d9479a62e8e664a73e70380669b109
Link: https://lore.kernel.org/r/20200811133936.19171-1-adrian.hunter@intel.com
Fixes: 9333d7757348 ("scsi: ufs: Fix irq return code")
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Orson Zhai <orson.zhai@unisoc.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 24396f4..a5d4ee6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5661,7 +5661,7 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 		intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
 	}
 
-	if (retval == IRQ_NONE) {
+	if (enabled_intr_status && retval == IRQ_NONE) {
 		dev_err(hba->dev, "%s: Unhandled interrupt 0x%08x\n",
 					__func__, intr_status);
 		ufshcd_dump_regs(hba, 0, UFSHCI_REG_SPACE_SIZE, "host_regs: ");
-- 
2.7.4

