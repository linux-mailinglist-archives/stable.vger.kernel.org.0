Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581821FE8DF
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgFRCva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:51:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726965AbgFRBI7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:08:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17E8C2193E;
        Thu, 18 Jun 2020 01:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442538;
        bh=4cd6BES8OaJlVZsooW8Dw++aKDGtzg3B1yFFQ+/V6Yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hWuonSC02zvoFYxgWT/gNsj8TYy4qXAE2CZl/HV7W/eJATkSkdNmWCe58QTq4oxDz
         Ou61peyBMyD4bm5BzW5qKn5+CA+OAkHMi9hagbwGPLWE4h1p0fxoYKKS9zIXrMt1nb
         aXZFRPhr69tCVvkdco8BJKEe/5VT+BJ7hC1m2ygE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.7 040/388] staging: wfx: fix output of rx_stats on big endian hosts
Date:   Wed, 17 Jun 2020 21:02:17 -0400
Message-Id: <20200618010805.600873-40-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jérôme Pouiller <jerome.pouiller@silabs.com>

[ Upstream commit a823d6ecd4904e1a6ffb12964de88fb0bb4802f6 ]

The struct hif_rx_stats contains only little endian values. Thus, it is
necessary to fix byte ordering before to use them.

Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Link: https://lore.kernel.org/r/20200512150414.267198-6-Jerome.Pouiller@silabs.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wfx/debug.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wfx/debug.c b/drivers/staging/wfx/debug.c
index 1164aba118a1..a73b5bbb578e 100644
--- a/drivers/staging/wfx/debug.c
+++ b/drivers/staging/wfx/debug.c
@@ -142,7 +142,7 @@ static int wfx_rx_stats_show(struct seq_file *seq, void *v)
 	mutex_lock(&wdev->rx_stats_lock);
 	seq_printf(seq, "Timestamp: %dus\n", st->date);
 	seq_printf(seq, "Low power clock: frequency %uHz, external %s\n",
-		   st->pwr_clk_freq,
+		   le32_to_cpu(st->pwr_clk_freq),
 		   st->is_ext_pwr_clk ? "yes" : "no");
 	seq_printf(seq,
 		   "Num. of frames: %d, PER (x10e4): %d, Throughput: %dKbps/s\n",
@@ -152,9 +152,12 @@ static int wfx_rx_stats_show(struct seq_file *seq, void *v)
 	for (i = 0; i < ARRAY_SIZE(channel_names); i++) {
 		if (channel_names[i])
 			seq_printf(seq, "%5s %8d %8d %8d %8d %8d\n",
-				   channel_names[i], st->nb_rx_by_rate[i],
-				   st->per[i], st->rssi[i] / 100,
-				   st->snr[i] / 100, st->cfo[i]);
+				   channel_names[i],
+				   le32_to_cpu(st->nb_rx_by_rate[i]),
+				   le16_to_cpu(st->per[i]),
+				   (s16)le16_to_cpu(st->rssi[i]) / 100,
+				   (s16)le16_to_cpu(st->snr[i]) / 100,
+				   (s16)le16_to_cpu(st->cfo[i]));
 	}
 	mutex_unlock(&wdev->rx_stats_lock);
 
-- 
2.25.1

