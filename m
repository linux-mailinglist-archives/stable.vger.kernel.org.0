Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3E3359B10
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbhDIKHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:07:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234122AbhDIKEo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:04:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE4AC6128E;
        Fri,  9 Apr 2021 10:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962470;
        bh=Vf/4atIVJIZu8M3poCXKaRHTSUmtfUTlzgP46VsUrEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fBLAnXBXth7+iIqTpSe2yOqKU8yuIc+vTBRvYKyilJOIHp3F/JxDVWkfDGubuU+Ym
         xkZFAA4//BHAQbWIzaK3datZkYxZpG8TOMqTFh+iSQDXpscUpGDvxfHlJOSdyX69UM
         4cHEmB8y14nStNzRqoyE5td/J+DxuqoYj6fBbtWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangbo Lu <yangbo.lu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 27/45] ptp_qoriq: fix overflow in ptp_qoriq_adjfine() u64 calcalation
Date:   Fri,  9 Apr 2021 11:53:53 +0200
Message-Id: <20210409095306.292333665@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095305.397149021@linuxfoundation.org>
References: <20210409095305.397149021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>

[ Upstream commit f51d7bf1dbe5522c51c93fe8faa5f4abbdf339cd ]

Current calculation for diff of TMR_ADD register value may have
64-bit overflow in this code line, when long type scaled_ppm is
large.

adj *= scaled_ppm;

This patch is to resolve it by using mul_u64_u64_div_u64().

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_qoriq.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
index beb5f74944cd..08f4cf0ad9e3 100644
--- a/drivers/ptp/ptp_qoriq.c
+++ b/drivers/ptp/ptp_qoriq.c
@@ -189,15 +189,16 @@ int ptp_qoriq_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	tmr_add = ptp_qoriq->tmr_add;
 	adj = tmr_add;
 
-	/* calculate diff as adj*(scaled_ppm/65536)/1000000
-	 * and round() to the nearest integer
+	/*
+	 * Calculate diff and round() to the nearest integer
+	 *
+	 * diff = adj * (ppb / 1000000000)
+	 *      = adj * scaled_ppm / 65536000000
 	 */
-	adj *= scaled_ppm;
-	diff = div_u64(adj, 8000000);
-	diff = (diff >> 13) + ((diff >> 12) & 1);
+	diff = mul_u64_u64_div_u64(adj, scaled_ppm, 32768000000);
+	diff = DIV64_U64_ROUND_UP(diff, 2);
 
 	tmr_add = neg_adj ? tmr_add - diff : tmr_add + diff;
-
 	ptp_qoriq->write(&regs->ctrl_regs->tmr_add, tmr_add);
 
 	return 0;
-- 
2.30.2



