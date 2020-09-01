Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5DA259CE1
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbgIARVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728693AbgIAPMn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:12:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C9CF20BED;
        Tue,  1 Sep 2020 15:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973162;
        bh=dP9OWR2F7qWnMhX4Sx22XvrX3BkgvzRlHX2MWVWC4Gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cTtr0AE2RW8mNYcieRqxKo0ME2U4ywFnTzax9YdZzVRqqO+DoTEeEmKSpkwLQi/fB
         xovCp9WdoUnDIsBdelVsV6r2L7pb0ZuIL8MwGdFkgybvBYU0i//ZslwNTKa+0ZR0O8
         TukGHrK3tMRii1JxCzagjRGvzZCtFTCpluGrtoZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhi Chen <zhichen@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 32/62] Revert "ath10k: fix DMA related firmware crashes on multiple devices"
Date:   Tue,  1 Sep 2020 17:10:15 +0200
Message-Id: <20200901150922.332417901@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150920.697676718@linuxfoundation.org>
References: <20200901150920.697676718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhi Chen <zhichen@codeaurora.org>

[ Upstream commit a1769bb68a850508a492e3674ab1e5e479b11254 ]

This reverts commit 76d164f582150fd0259ec0fcbc485470bcd8033e.
PCIe hung issue was observed on multiple platforms. The issue was reproduced
when DUT was configured as AP and associated with 50+ STAs.

For QCA9984/QCA9888, the DMA_BURST_SIZE register controls the AXI burst size
of the RD/WR access to the HOST MEM.
0 - No split , RAW read/write transfer size from MAC is put out on bus
    as burst length
1 - Split at 256 byte boundary
2,3 - Reserved

With PCIe protocol analyzer, we can see DMA Read crossing 4KB boundary when
issue happened. It broke PCIe spec and caused PCIe stuck. So revert
the default value from 0 to 1.

Tested:  IPQ8064 + QCA9984 with firmware 10.4-3.10-00047
         QCS404 + QCA9984 with firmware 10.4-3.9.0.2--00044
         Synaptics AS370 + QCA9888  with firmware 10.4-3.9.0.2--00040

Signed-off-by: Zhi Chen <zhichen@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/hw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 713c2bcea1782..8ec5c579d7fa8 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -429,7 +429,7 @@ enum ath10k_hw_rate_cck {
 
 #define TARGET_10_4_TX_DBG_LOG_SIZE		1024
 #define TARGET_10_4_NUM_WDS_ENTRIES		32
-#define TARGET_10_4_DMA_BURST_SIZE		0
+#define TARGET_10_4_DMA_BURST_SIZE		1
 #define TARGET_10_4_MAC_AGGR_DELIM		0
 #define TARGET_10_4_RX_SKIP_DEFRAG_TIMEOUT_DUP_DETECTION_CHECK 1
 #define TARGET_10_4_VOW_CONFIG			0
-- 
2.25.1



