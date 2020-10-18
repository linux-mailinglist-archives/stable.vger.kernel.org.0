Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75103291F52
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388219AbgJRT7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:59:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727936AbgJRTS4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:18:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4256F222C8;
        Sun, 18 Oct 2020 19:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048735;
        bh=lG9xer3NfKmY+nojdAzJLgz+78RX7Lcntov0YOqaR4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZ7v1SjpZUwcD6trz99EVs5kT/hhUHoryxDpyxOIoJ6GroPPLMbIfHSdTx4zKV+AB
         GJdUtDDPqR/0H584CU1FvfpLyzj5t7Q23airRv1T9r+R8hSRZ86wc4/ZE2chbBY8hy
         OeymDE7WB1C8vzBLdKfc60MEsqxj+w2stdGI7TCc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.9 039/111] staging: wfx: fix handling of MMIC error
Date:   Sun, 18 Oct 2020 15:16:55 -0400
Message-Id: <20201018191807.4052726-39-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jérôme Pouiller <jerome.pouiller@silabs.com>

[ Upstream commit 8d350c14ee5eb62ecd40b0991248bfbce511954d ]

As expected, when the device detect a MMIC error, it returns a specific
status. However, it also strip IV from the frame (don't ask me why).

So, with the current code, mac80211 detects a corrupted frame and it
drops it before it handle the MMIC error. The expected behavior would be
to detect MMIC error then to renegotiate the EAP session.

So, this patch correctly informs mac80211 that IV is not available. So,
mac80211 correctly takes into account the MMIC error.

Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Link: https://lore.kernel.org/r/20201007101943.749898-2-Jerome.Pouiller@silabs.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wfx/data_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wfx/data_rx.c b/drivers/staging/wfx/data_rx.c
index 6fb0788807426..81c37ec0f2834 100644
--- a/drivers/staging/wfx/data_rx.c
+++ b/drivers/staging/wfx/data_rx.c
@@ -41,7 +41,7 @@ void wfx_rx_cb(struct wfx_vif *wvif,
 	memset(hdr, 0, sizeof(*hdr));
 
 	if (arg->status == HIF_STATUS_RX_FAIL_MIC)
-		hdr->flag |= RX_FLAG_MMIC_ERROR;
+		hdr->flag |= RX_FLAG_MMIC_ERROR | RX_FLAG_IV_STRIPPED;
 	else if (arg->status)
 		goto drop;
 
-- 
2.25.1

