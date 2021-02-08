Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5EAD313701
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbhBHPSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:18:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:56488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232887AbhBHPLx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:11:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF84A64EEF;
        Mon,  8 Feb 2021 15:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796935;
        bh=hEpoRemxNUNq4gd+swVQvh7eAGeFc+AfgUAfeBJHV7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yYqYY+IuR89tDaPGBCAiFQrnEVPaZnPlfiCrrhH4Z+9jnEqcLoYME3pgRWi3kRL9Y
         JUEv/AQHTOs01zXtmP3/t3ZRmbeW18cyeRFGpPSZAwD6y32URA1sMr+hN/V/mHlGIN
         ietxO2Kq7NTiJ+0JLQSLk3eEhfURLmOq1UUPxVUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Chulski <stefanc@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/38] net: mvpp2: TCAM entry enable should be written after SRAM data
Date:   Mon,  8 Feb 2021 16:00:56 +0100
Message-Id: <20210208145806.505889756@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145806.141056364@linuxfoundation.org>
References: <20210208145806.141056364@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

[ Upstream commit 43f4a20a1266d393840ce010f547486d14cc0071 ]

Last TCAM data contains TCAM enable bit.
It should be written after SRAM data before entry enabled.

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
Link: https://lore.kernel.org/r/1612172139-28343-1-git-send-email-stefanc@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
index a30eb90ba3d28..dd590086fe6a5 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
@@ -29,16 +29,16 @@ static int mvpp2_prs_hw_write(struct mvpp2 *priv, struct mvpp2_prs_entry *pe)
 	/* Clear entry invalidation bit */
 	pe->tcam[MVPP2_PRS_TCAM_INV_WORD] &= ~MVPP2_PRS_TCAM_INV_MASK;
 
-	/* Write tcam index - indirect access */
-	mvpp2_write(priv, MVPP2_PRS_TCAM_IDX_REG, pe->index);
-	for (i = 0; i < MVPP2_PRS_TCAM_WORDS; i++)
-		mvpp2_write(priv, MVPP2_PRS_TCAM_DATA_REG(i), pe->tcam[i]);
-
 	/* Write sram index - indirect access */
 	mvpp2_write(priv, MVPP2_PRS_SRAM_IDX_REG, pe->index);
 	for (i = 0; i < MVPP2_PRS_SRAM_WORDS; i++)
 		mvpp2_write(priv, MVPP2_PRS_SRAM_DATA_REG(i), pe->sram[i]);
 
+	/* Write tcam index - indirect access */
+	mvpp2_write(priv, MVPP2_PRS_TCAM_IDX_REG, pe->index);
+	for (i = 0; i < MVPP2_PRS_TCAM_WORDS; i++)
+		mvpp2_write(priv, MVPP2_PRS_TCAM_DATA_REG(i), pe->tcam[i]);
+
 	return 0;
 }
 
-- 
2.27.0



