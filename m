Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4A9310BCC8
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732115AbfK0VXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:23:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:57450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727445AbfK0VEF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:04:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29ADA2086A;
        Wed, 27 Nov 2019 21:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888644;
        bh=nOskZj0L/b7ymmq40aLThte2XvXczGSoKhi6G9WlnOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EbhwJjfzxGk2lVbWTqM+lTL7tAdJcxewXbBjovbTzS8REpIrB0Mwbq03KQ+Uy54mM
         7lZiVAOhIPg3Z26q5rW8nXYVfoyzplCHdNMMMIJmDTufbsHvJpC/dLV+GzqghKMJFG
         eeAQS8pO2a2xoZamZu0O4su3rqctWrOGTKERcAjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 214/306] wil6210: fix L2 RX status handling
Date:   Wed, 27 Nov 2019 21:31:04 +0100
Message-Id: <20191127203130.735558221@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maya Erez <merez@codeaurora.org>

[ Upstream commit 04de15010aa42a92add66b159e3ae44b4287390f ]

L2 RX status errors should not be treated as a bitmap and the actual
error values should be checked.
Print L2 errors as wil_err_ratelimited for easier debugging
when such errors occurs.

Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/wil6210/txrx_edma.c | 23 ++++++++++----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index 409a6fa8b6c8f..5fa8d6ad66482 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -808,23 +808,24 @@ static int wil_rx_error_check_edma(struct wil6210_priv *wil,
 		wil_dbg_txrx(wil, "L2 RX error, l2_rx_status=0x%x\n",
 			     l2_rx_status);
 		/* Due to HW issue, KEY error will trigger a MIC error */
-		if (l2_rx_status & WIL_RX_EDMA_ERROR_MIC) {
-			wil_dbg_txrx(wil,
-				     "L2 MIC/KEY error, dropping packet\n");
+		if (l2_rx_status == WIL_RX_EDMA_ERROR_MIC) {
+			wil_err_ratelimited(wil,
+					    "L2 MIC/KEY error, dropping packet\n");
 			stats->rx_mic_error++;
 		}
-		if (l2_rx_status & WIL_RX_EDMA_ERROR_KEY) {
-			wil_dbg_txrx(wil, "L2 KEY error, dropping packet\n");
+		if (l2_rx_status == WIL_RX_EDMA_ERROR_KEY) {
+			wil_err_ratelimited(wil,
+					    "L2 KEY error, dropping packet\n");
 			stats->rx_key_error++;
 		}
-		if (l2_rx_status & WIL_RX_EDMA_ERROR_REPLAY) {
-			wil_dbg_txrx(wil,
-				     "L2 REPLAY error, dropping packet\n");
+		if (l2_rx_status == WIL_RX_EDMA_ERROR_REPLAY) {
+			wil_err_ratelimited(wil,
+					    "L2 REPLAY error, dropping packet\n");
 			stats->rx_replay++;
 		}
-		if (l2_rx_status & WIL_RX_EDMA_ERROR_AMSDU) {
-			wil_dbg_txrx(wil,
-				     "L2 AMSDU error, dropping packet\n");
+		if (l2_rx_status == WIL_RX_EDMA_ERROR_AMSDU) {
+			wil_err_ratelimited(wil,
+					    "L2 AMSDU error, dropping packet\n");
 			stats->rx_amsdu_error++;
 		}
 		return -EFAULT;
-- 
2.20.1



