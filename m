Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D6229B764
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799621AbgJ0Pc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:32:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799617AbgJ0Pc1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:32:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE1DD20727;
        Tue, 27 Oct 2020 15:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812747;
        bh=SylvcWgk7HoFwyUj4K/2d5OkPkgdpez2EfhpnHVMNkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dS5tsT4BPJHtSpGttqOLSeB1B/GMwY+l0AOiBPm4fY6GdEgUUsGL/NYBlvVyzgl9D
         rI0YGjq9ULry2VzyeewxRa14fmSYrInqDulyx7POcb+BHXRDtxCx4DaHZUMuPnXlHx
         ipFcB7VBamalO5KoPp+Sd7m9gOypbU0+whKjg2ck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YN Chen <YN.Chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 317/757] mt76: mt7663s: fix resume failure
Date:   Tue, 27 Oct 2020 14:49:27 +0100
Message-Id: <20201027135505.407805187@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 8b7c6e1cb2cb1d4e2ee94556695d80dde6ccdcc6 ]

MT7663s have to rely on MMC_PM_KEEP_POWER in pm_flags for to avoid SDIO
power is being shut off.

To fix sdio access failure like "mt7663s mmc1:0001:1: sdio write failed:
-22" for the first sdio command to access the bus in the resume handler.

Fixes: a66cbdd6573d ("mt76: mt7615: introduce mt7663s support")
Co-developed-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/sdio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/sdio.c b/drivers/net/wireless/mediatek/mt76/mt7615/sdio.c
index dabce51117b0a..57d60876db544 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/sdio.c
@@ -426,6 +426,8 @@ static int mt7663s_suspend(struct device *dev)
 			return err;
 	}
 
+	sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
+
 	mt76s_stop_txrx(&mdev->mt76);
 
 	return mt7663s_firmware_own(mdev);
-- 
2.25.1



