Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A264329B921
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802219AbgJ0PqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:46:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798453AbgJ0P2H (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:28:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95E9A20728;
        Tue, 27 Oct 2020 15:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812486;
        bh=McwCREqjz1VCxlUZN5S8ecfgLRQFnbqegt3n/+qw5EU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DAFxQAbCwQiCLs4b6t4kSxajWBRiKv/lCLh0g6V2O4hqOGDOVnTZMN11lxg52BTB5
         MKDoHZWsML6lmkqAhyDafFylq/+KeFnBwvJId/Rr9/CHLlfxWpHHn+XmoqmMcsdozC
         fA+IIUvXKwMiPFwD9gwHGige2sGl5BvbxbPulgxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Eric Biggers <ebiggers@google.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 226/757] scsi: ufs: Make ufshcd_print_trs() consider UFSHCD_QUIRK_PRDT_BYTE_GRAN
Date:   Tue, 27 Oct 2020 14:47:56 +0100
Message-Id: <20201027135501.214050324@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit cc770ce34aeeff21991f162f0db1a758ea672727 ]

Fix ufshcd_print_trs() to consider UFSHCD_QUIRK_PRDT_BYTE_GRAN when using
utp_transfer_req_desc::prd_table_length, so that it doesn't treat the
number of bytes as the number of entries.

Originally from Kiwoong Kim
(https://lkml.kernel.org/r/20200218233115.8185-1-kwmad.kim@samsung.com).

Link: https://lore.kernel.org/r/20200826021040.152148-1-ebiggers@kernel.org
Fixes: 26f968d7de82 ("scsi: ufs: Introduce UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk")
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1d157ff58d817..316b861305eae 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -474,6 +474,9 @@ void ufshcd_print_trs(struct ufs_hba *hba, unsigned long bitmap, bool pr_prdt)
 
 		prdt_length = le16_to_cpu(
 			lrbp->utr_descriptor_ptr->prd_table_length);
+		if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN)
+			prdt_length /= sizeof(struct ufshcd_sg_entry);
+
 		dev_err(hba->dev,
 			"UPIU[%d] - PRDT - %d entries  phys@0x%llx\n",
 			tag, prdt_length,
-- 
2.25.1



