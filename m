Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729D036426C
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239392AbhDSNIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:08:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239366AbhDSNIh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:08:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C61986128C;
        Mon, 19 Apr 2021 13:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837687;
        bh=S0PCsNpCxnGZk+NkzrOu+957G4bstUEIIdmSOfVwMqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vQE1H9AK5JszBQwoPDtPMdUV53sPS5s6ed6hXlcV75eFJAdPw8tBTVVyNiGi3PcsQ
         KifD1WZGbTgxF8W8bX6/Amrm7WPndSmrwUmXdwSjVktvvYkl2tWckAIlq3OXbVgZk6
         qh9qjilBfzjyVJjXhcb0c8Vt3KL2Ug70V7wLDCsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dimitar Dimitrov <dimitar@dinux.eu>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 019/122] remoteproc: pru: Fix loading of GNU Binutils ELF
Date:   Mon, 19 Apr 2021 15:04:59 +0200
Message-Id: <20210419130530.819674808@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 16979c1cd2f4..dcb380e868df 100644
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



