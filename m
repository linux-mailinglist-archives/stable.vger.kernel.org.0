Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E2E23A456
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgHCM0C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:26:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728298AbgHCMZ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:25:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9445C204EC;
        Mon,  3 Aug 2020 12:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457558;
        bh=x7YoQtupH7CiYhIjtuOqqsTxqZZSxlDcl4I1Z5TtKrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DnOch+yBRZJ507KhBaV1Es4aJTswLnENC3rO9sHCzWPzTiYDtxXZ+OiXdLSwYxglQ
         SkdxBKdX1mu2cdQR6ewCRxZT1bOpAIfGeoQbkANr5za+2ec8BNcRmlUbmXRoPTpRdr
         clFb2agKRJ8MSu/6ur+UgOOiDOnAJPxvh2ZWB67g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 094/120] mt76: mt7615: fix lmac queue debugsfs entry
Date:   Mon,  3 Aug 2020 14:19:12 +0200
Message-Id: <20200803121907.494879651@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit d941f47caa386931c3b598ad1b43d5ddd65869aa ]

acs and wmm index are swapped in mt7615_queues_acq respect to the hw
design

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
index b4d0795154e3d..a2afd1a3c51ba 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/debugfs.c
@@ -206,10 +206,11 @@ mt7615_queues_acq(struct seq_file *s, void *data)
 	int i;
 
 	for (i = 0; i < 16; i++) {
-		int j, acs = i / 4, index = i % 4;
+		int j, wmm_idx = i % MT7615_MAX_WMM_SETS;
+		int acs = i / MT7615_MAX_WMM_SETS;
 		u32 ctrl, val, qlen = 0;
 
-		val = mt76_rr(dev, MT_PLE_AC_QEMPTY(acs, index));
+		val = mt76_rr(dev, MT_PLE_AC_QEMPTY(acs, wmm_idx));
 		ctrl = BIT(31) | BIT(15) | (acs << 8);
 
 		for (j = 0; j < 32; j++) {
@@ -217,11 +218,11 @@ mt7615_queues_acq(struct seq_file *s, void *data)
 				continue;
 
 			mt76_wr(dev, MT_PLE_FL_Q0_CTRL,
-				ctrl | (j + (index << 5)));
+				ctrl | (j + (wmm_idx << 5)));
 			qlen += mt76_get_field(dev, MT_PLE_FL_Q3_CTRL,
 					       GENMASK(11, 0));
 		}
-		seq_printf(s, "AC%d%d: queued=%d\n", acs, index, qlen);
+		seq_printf(s, "AC%d%d: queued=%d\n", wmm_idx, acs, qlen);
 	}
 
 	return 0;
-- 
2.25.1



