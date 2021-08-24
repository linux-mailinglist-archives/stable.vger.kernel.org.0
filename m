Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3173F63A1
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbhHXQ5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:57:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234384AbhHXQ5P (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1930361452;
        Tue, 24 Aug 2021 16:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824190;
        bh=JIhXGOi/0shg5DD6Nef8G/3UhPiwd/3pMng9OkathV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dWJsSrto7y1Q5gKI1rrxm9biT0AmXhRwd3oGEmRdq+cZo4wMPi0rWyAiaoiWPcGjv
         KuhtM3f5HQTcMVXpdsYqZIZtr0amQ7HvU+2n4a5lPDDW+RBVOUpuYlK5dZAl82qJqr
         Mu6WqZ+Eqv60/vukMX2MWIcM5Qk2jf8cfpQDEnoLOQ5qwG0qihL6Z/RkU8h6VG8Yc6
         9g8D1ssbAiZPNQ5fm8+JQSATL50qCJNseLEpYfQAqNcFUjnVChvxXOigkMZ3Ps9IPq
         zl897Mu7Z6+qrSa87AsmonAPbBAI/1jKyCsUsogPFFEdrgr2OJq8ou98MI83mONCY9
         IGLqMoO+SKPrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Apurva Nandan <a-nandan@ti.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 022/127] spi: cadence-quadspi: Fix check condition for DTR ops
Date:   Tue, 24 Aug 2021 12:54:22 -0400
Message-Id: <20210824165607.709387-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Apurva Nandan <a-nandan@ti.com>

[ Upstream commit 0395be967b067d99494113d78470574e86a02ed4 ]

buswidth and dtr fields in spi_mem_op are only valid when the
corresponding spi_mem_op phase has a non-zero length. For example,
SPI NAND core doesn't set buswidth when using SPI_MEM_OP_NO_ADDR
phase.

Fix the dtr checks in set_protocol() and suppports_mem_op() to
ignore empty spi_mem_op phases, as checking for dtr field in
empty phase will result in false negatives.

Signed-off-by: Apurva Nandan <a-nandan@ti.com>
Link: https://lore.kernel.org/r/20210716232504.182-3-a-nandan@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index d62d69dd72b9..73d4f0a1558d 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -325,7 +325,15 @@ static int cqspi_set_protocol(struct cqspi_flash_pdata *f_pdata,
 	f_pdata->inst_width = CQSPI_INST_TYPE_SINGLE;
 	f_pdata->addr_width = CQSPI_INST_TYPE_SINGLE;
 	f_pdata->data_width = CQSPI_INST_TYPE_SINGLE;
-	f_pdata->dtr = op->data.dtr && op->cmd.dtr && op->addr.dtr;
+
+	/*
+	 * For an op to be DTR, cmd phase along with every other non-empty
+	 * phase should have dtr field set to 1. If an op phase has zero
+	 * nbytes, ignore its dtr field; otherwise, check its dtr field.
+	 */
+	f_pdata->dtr = op->cmd.dtr &&
+		       (!op->addr.nbytes || op->addr.dtr) &&
+		       (!op->data.nbytes || op->data.dtr);
 
 	switch (op->data.buswidth) {
 	case 0:
@@ -1227,8 +1235,15 @@ static bool cqspi_supports_mem_op(struct spi_mem *mem,
 {
 	bool all_true, all_false;
 
-	all_true = op->cmd.dtr && op->addr.dtr && op->dummy.dtr &&
-		   op->data.dtr;
+	/*
+	 * op->dummy.dtr is required for converting nbytes into ncycles.
+	 * Also, don't check the dtr field of the op phase having zero nbytes.
+	 */
+	all_true = op->cmd.dtr &&
+		   (!op->addr.nbytes || op->addr.dtr) &&
+		   (!op->dummy.nbytes || op->dummy.dtr) &&
+		   (!op->data.nbytes || op->data.dtr);
+
 	all_false = !op->cmd.dtr && !op->addr.dtr && !op->dummy.dtr &&
 		    !op->data.dtr;
 
-- 
2.30.2

