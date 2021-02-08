Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85EA313797
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbhBHP2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:28:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:35288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233834AbhBHPXB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:23:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 987B764F10;
        Mon,  8 Feb 2021 15:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797251;
        bh=hEpoRemxNUNq4gd+swVQvh7eAGeFc+AfgUAfeBJHV7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pSNho9WlDfTpejs611IwSYlA7GWyc0vH/VNTRiQiWvZzADpaii04dyG87cO011rdn
         /jW+6L6Dfat3DZ4AI3l5n/u2ll9F0pTRdVF8OkWnFoEb7IuC/biZYf3zHjOpDnqaMw
         p6fy7PDLDQFsVgPaacA0j5GF61gFlAS7V75WH6FY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Chulski <stefanc@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/120] net: mvpp2: TCAM entry enable should be written after SRAM data
Date:   Mon,  8 Feb 2021 16:00:32 +0100
Message-Id: <20210208145820.221984712@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
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



