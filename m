Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60130107101
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfKVKgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:36:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:36084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727188AbfKVKgX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:36:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ABF320708;
        Fri, 22 Nov 2019 10:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574418983;
        bh=uxxm2wLEUgiQS5Hy+cXBEGA8D64YhyjFzfss5q81di0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=puIShZefAHq9DgGE1+haUzHXZ+SGcNMt/XAfa30bXGQ2qRuDC84eU1juYmKFWJN4j
         ZTF6POpDse9St1TEMCe79tMqIYoeKpcz5RN6Ws8a+cTxT5NFHwxm8RhvB3YuNmsdkx
         jfQ6oGgY0eaQIlBc0sFWZ8bBWp4y2aIkqGQuorCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Kossifidis <mickflemm@gmail.com>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 116/159] ath9k: fix reporting calculated new FFT upper max
Date:   Fri, 22 Nov 2019 11:28:27 +0100
Message-Id: <20191122100830.003379491@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Wunderlich <sw@simonwunderlich.de>

[ Upstream commit 4fb5837ac2bd46a85620b297002c704e9958f64d ]

Since the debug print code is outside of the loop, it shouldn't use the loop
iterator anymore but instead print the found maximum index.

Cc: Nick Kossifidis <mickflemm@gmail.com>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/common-spectral.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index 03945731eb65a..ec805fe6dddbb 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -411,7 +411,7 @@ ath_cmn_process_ht20_40_fft(struct ath_rx_status *rs,
 
 		ath_dbg(common, SPECTRAL_SCAN,
 			"Calculated new upper max 0x%X at %i\n",
-			tmp_mag, i);
+			tmp_mag, fft_sample_40.upper_max_index);
 	} else
 	for (i = dc_pos; i < SPECTRAL_HT20_40_NUM_BINS; i++) {
 		if (fft_sample_40.data[i] == (upper_mag >> max_exp))
-- 
2.20.1



