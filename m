Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF052A55F2
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387887AbgKCVDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:03:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:41270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387870AbgKCVDh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:03:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 163CC20658;
        Tue,  3 Nov 2020 21:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437416;
        bh=J9qNKeZVSuYHZhqkgsqlY5TmyCHjs1jjs8+6xeaNbQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VJE/gKYb/wkbEU4CktesrTEdem2Fv65kVnB9KzrAAZ3DvilPXgXNSYUj6oR2km4YS
         zfOOs3qSNm9AuMzWhRYsdli7tZq/1sulljpUWPF6b8iaTOU2KH07/FAJ0y/1djECO1
         TcElAAOMGhJ4uymORX9FWqUKbKgcYKV64XvEmE9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sathishkumar Muruganandam <murugana@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 067/191] ath10k: fix VHT NSS calculation when STBC is enabled
Date:   Tue,  3 Nov 2020 21:35:59 +0100
Message-Id: <20201103203240.792860729@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sathishkumar Muruganandam <murugana@codeaurora.org>

[ Upstream commit 99f41b8e43b8b4b31262adb8ac3e69088fff1289 ]

When STBC is enabled, NSTS_SU value need to be accounted for VHT NSS
calculation for SU case.

Without this fix, 1SS + STBC enabled case was reported wrongly as 2SS
in radiotap header on monitor mode capture.

Tested-on: QCA9984 10.4-3.10-00047

Signed-off-by: Sathishkumar Muruganandam <murugana@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1597392971-3897-1-git-send-email-murugana@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 7d15f6208b463..68cda1564c77a 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -767,6 +767,7 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 	u8 preamble = 0;
 	u8 group_id;
 	u32 info1, info2, info3;
+	u32 stbc, nsts_su;
 
 	info1 = __le32_to_cpu(rxd->ppdu_start.info1);
 	info2 = __le32_to_cpu(rxd->ppdu_start.info2);
@@ -811,11 +812,16 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 		 */
 		bw = info2 & 3;
 		sgi = info3 & 1;
+		stbc = (info2 >> 3) & 1;
 		group_id = (info2 >> 4) & 0x3F;
 
 		if (GROUP_ID_IS_SU_MIMO(group_id)) {
 			mcs = (info3 >> 4) & 0x0F;
-			nss = ((info2 >> 10) & 0x07) + 1;
+			nsts_su = ((info2 >> 10) & 0x07);
+			if (stbc)
+				nss = (nsts_su >> 2) + 1;
+			else
+				nss = (nsts_su + 1);
 		} else {
 			/* Hardware doesn't decode VHT-SIG-B into Rx descriptor
 			 * so it's impossible to decode MCS. Also since
-- 
2.27.0



