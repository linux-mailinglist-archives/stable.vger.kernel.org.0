Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5017635CB1A
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243373AbhDLQXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:23:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243309AbhDLQXZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:23:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4A8F61363;
        Mon, 12 Apr 2021 16:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244587;
        bh=CeTUghtikrcLWr0fV+9wynorJgQdQVB1NdTkfu+cc7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uKWwDG/tHaPZ0buuD/6S+kLMVfMIc9BPjbwbDykLo5QkIhEZ5zFJ+dJOj+s/70F78
         AVcHZiyuxoQNL2pPh8PNXPqDBc7LiHLPTmbNAtd6+9UcTbdFZLwXDaBzPIhfOo+BDd
         0tnWET4Oacp4khB9f5HEe1+q8RJZ2xYH8n3cHjI376wzJUt9QSson9pRerO27WHSr/
         0Md7mqh9JmVpSBCUIZkbUGQ68P8ivhsJitjLfRtW0tJlzWibUj6/TBwlbfqcp/wHC2
         YEIiioGAjxXf5WpSfpldYuVHr39wiO1u0zFQVZ3fFAZxXtC2cBEGZMKDvaoigU4Tnw
         6IxPkN3oyz3PA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dimitar Dimitrov <dimitar@dinux.eu>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-remoteproc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 08/51] remoteproc: pru: Fix loading of GNU Binutils ELF
Date:   Mon, 12 Apr 2021 12:22:13 -0400
Message-Id: <20210412162256.313524-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162256.313524-1-sashal@kernel.org>
References: <20210412162256.313524-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dimitar Dimitrov <dimitar@dinux.eu>

[ Upstream commit e6d9423d31b2f9bdd0220fd0584e3bb6ed2c4e52 ]

PRU port of GNU Binutils lacks support for separate address spaces.
PRU IRAM addresses are marked with artificial offset to differentiate
them from DRAM addresses. Hence remoteproc must mask IRAM addresses
coming from GNU ELF in order to get the true hardware address.

PRU firmware used for testing was the example in:
  https://github.com/dinuxbg/pru-gcc-examples/tree/master/blinking-led/pru

Signed-off-by: Dimitar Dimitrov <dimitar@dinux.eu>
Link: https://lore.kernel.org/r/20201230105005.30492-1-dimitar@dinux.eu
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/pru_rproc.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/remoteproc/pru_rproc.c b/drivers/remoteproc/pru_rproc.c
index 2667919d76b3..5fad787ba012 100644
--- a/drivers/remoteproc/pru_rproc.c
+++ b/drivers/remoteproc/pru_rproc.c
@@ -450,6 +450,24 @@ static void *pru_i_da_to_va(struct pru_rproc *pru, u32 da, size_t len)
 	if (len == 0)
 		return NULL;
 
+	/*
+	 * GNU binutils do not support multiple address spaces. The GNU
+	 * linker's default linker script places IRAM at an arbitrary high
+	 * offset, in order to differentiate it from DRAM. Hence we need to
+	 * strip the artificial offset in the IRAM addresses coming from the
+	 * ELF file.
+	 *
+	 * The TI proprietary linker would never set those higher IRAM address
+	 * bits anyway. PRU architecture limits the program counter to 16-bit
+	 * word-address range. This in turn corresponds to 18-bit IRAM
+	 * byte-address range for ELF.
+	 *
+	 * Two more bits are added just in case to make the final 20-bit mask.
+	 * Idea is to have a safeguard in case TI decides to add banking
+	 * in future SoCs.
+	 */
+	da &= 0xfffff;
+
 	if (da >= PRU_IRAM_DA &&
 	    da + len <= PRU_IRAM_DA + pru->mem_regions[PRU_IOMEM_IRAM].size) {
 		offset = da - PRU_IRAM_DA;
-- 
2.30.2

