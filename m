Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D497A37CEA2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345074AbhELRGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:06:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235092AbhELQqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:46:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E58CA61E79;
        Wed, 12 May 2021 16:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836106;
        bh=QHVS36Hx5QQArgAt4AN/5gs/dR2JKtoTsFGR679Wkz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MnBH2LowNpludk0oEbToWAbHPgpFh0LGTQ785pgVdy/hj7RYUPzLrNpG3W3M7l3g1
         47omtM0+W/VBx5vOiklijYTnH2u3DLxY+FcaPbM8fg7gd/WryNFRyHeZSp5LkWHWqO
         DuvitA3RcV8d9N00LXi2YojSQfa61V+O9varke3M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 613/677] mt76: mt7921: run mt7921_mcu_fw_log_2_host holding mt76 mutex
Date:   Wed, 12 May 2021 16:50:59 +0200
Message-Id: <20210512144857.739993206@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 987c8fb4de437344f19a23d074c06faf67520a11 ]

Wake the chip before configuring the mcu log level

Fixes: 1d8efc741df8 ("mt76: mt7921: introduce Runtime PM support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
index 6aa11ca6fc81..87a7ea12f3b3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/debugfs.c
@@ -9,10 +9,13 @@ mt7921_fw_debug_set(void *data, u64 val)
 {
 	struct mt7921_dev *dev = data;
 
-	dev->fw_debug = (u8)val;
+	mt7921_mutex_acquire(dev);
 
+	dev->fw_debug = (u8)val;
 	mt7921_mcu_fw_log_2_host(dev, dev->fw_debug);
 
+	mt7921_mutex_release(dev);
+
 	return 0;
 }
 
-- 
2.30.2



