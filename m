Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9AD205C9C
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388083AbgFWUDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:03:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388076AbgFWUDk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:03:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A2882082F;
        Tue, 23 Jun 2020 20:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942619;
        bh=1UryEDmGlUrONnnp3xHIuxghwrrXGA2Qiq+pwONwrvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lWRryndH1AunBFLzo27Lz/Ji5urbD8JTJwF2/MtkyF8yo5qm90bDe/fAMgTNK3bub
         Skou6QzoJur3vo9GRA6qb5xCxwr1v22+bvShF4QGw1aQYiHPALXB+Sd7n5U7gmbn+1
         0ExMdCtwNMNmRFUBWKu7eyRvS+4F0pYP4L0h89zU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 039/477] staging: wfx: fix output of rx_stats on big endian hosts
Date:   Tue, 23 Jun 2020 21:50:36 +0200
Message-Id: <20200623195409.450730073@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1164aba118a18..a73b5bbb578e6 100644
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



