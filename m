Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2EE12C978
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731204AbfL2SIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:08:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:57488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731199AbfL2RrH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:47:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61353206A4;
        Sun, 29 Dec 2019 17:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641626;
        bh=aLZtRPo3J/10vYacInLSi2e43+VprTKkpjOLkrQxtFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yx1w1B6TgV3dcIlHcdCwrrZy265VBrmN3U25H/2dyztUuZdMw4kIIWxctwM5dWcdi
         SOINXn0KY67cYFIML1904B+cmKp8oxJQ+H5R7LY6CK5g4YLs3LuWKOk8KbAvGxVXs+
         5Ih1+6h+HMILwoErSS4F0QlQ5vZFQv7myTfCa/rw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 142/434] ath10k: Correct error handling of dma_map_single()
Date:   Sun, 29 Dec 2019 18:23:15 +0100
Message-Id: <20191229172711.169025164@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit d43810b2c1808ac865aa1a2a2c291644bf95345c ]

The return value of dma_map_single() should be checked for errors using
dma_mapping_error() and the skb has been dequeued so it needs to be
freed.

This was found when enabling CONFIG_DMA_API_DEBUG and it warned about the
missing dma_mapping_error() call.

Fixes: 1807da49733e ("ath10k: wmi: add management tx by reference support over wmi")
Reported-by: Niklas Cassel <niklas.cassel@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a40e1a998f4c..2b53ea6ca205 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3903,8 +3903,10 @@ void ath10k_mgmt_over_wmi_tx_work(struct work_struct *work)
 			     ar->running_fw->fw_file.fw_features)) {
 			paddr = dma_map_single(ar->dev, skb->data,
 					       skb->len, DMA_TO_DEVICE);
-			if (!paddr)
+			if (dma_mapping_error(ar->dev, paddr)) {
+				ieee80211_free_txskb(ar->hw, skb);
 				continue;
+			}
 			ret = ath10k_wmi_mgmt_tx_send(ar, skb, paddr);
 			if (ret) {
 				ath10k_warn(ar, "failed to transmit management frame by ref via WMI: %d\n",
-- 
2.20.1



