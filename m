Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6B13C53F2
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348126AbhGLH43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351071AbhGLHv1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D72860241;
        Mon, 12 Jul 2021 07:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076118;
        bh=F/FvuA6Lx+M33TSJzNip8hhTajCCknixoqq2lm5DqB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ktdndz4d6ZldCG5I7ctC6t9eki9ExiB3g9HcTrpaHewFEgX5+AwSrBrDoH4WuuJRT
         0J8F1SIAqJpJi3AbX0zI9WmrhUZ0IMvQZyE05+qaAibc+5qGFY4ASICTA46nLLo91M
         PdzYjQ03RpAnipMR+r0SwkcJ7y6BEfNz6p8pthOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 505/800] mt76: mt7921: wake the device before dumping power table
Date:   Mon, 12 Jul 2021 08:08:48 +0200
Message-Id: <20210712061020.915811449@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 271fa685365842962f56651c9d1a33a0d0d3b30b ]

Always wake the device up before dumping the single_sku power table
otherwise the device can hang.

Fixes: ea29acc97c555 ("mt76: mt7921: add dumping Tx power table")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
index 6ee423dd4027..6602903c0d02 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
@@ -184,7 +184,10 @@ mt7921_txpwr(struct seq_file *s, void *data)
 	struct mt7921_txpwr txpwr;
 	int ret;
 
+	mt7921_mutex_acquire(dev);
 	ret = mt7921_get_txpwr_info(dev, &txpwr);
+	mt7921_mutex_release(dev);
+
 	if (ret)
 		return ret;
 
-- 
2.30.2



