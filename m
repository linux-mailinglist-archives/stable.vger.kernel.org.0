Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086472E3D47
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440213AbgL1ONf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:13:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440209AbgL1ONe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:13:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA8BD205CB;
        Mon, 28 Dec 2020 14:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164799;
        bh=zzuJMY+o0rZHf9ldOzV0e4o8kbV+3YZQxBj4RWsQ82g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UFvWvzN0vke9UUs1TibiJeMn+TVnJaXRg/zMFbQe9Ki0lVWlvft5DZfb3yiLQgSPp
         nfNq1XVPYkNEG6EZjime8o+eVhdXTV0UqZxCy4mY4qHtEJBP1SROR2zmsm2olUyMkb
         yrY+X5keTBT66JrZdQL9g/avva3wPLLGBNWJCZkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 302/717] mt76: mt7663s: fix a possible ple quota underflow
Date:   Mon, 28 Dec 2020 13:45:00 +0100
Message-Id: <20201228125035.496787170@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 1c79a190e94325e01811f653f770a34e816fdd8f ]

Properly account current consumed ple quota in mt7663s_tx_pick_quota
routine and avoid possible underflow.

Fixes: 6ef2d665f64d ("mt76: mt7663s: split mt7663s_tx_update_sched in mt7663s_tx_{pick,update}_quota")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c b/drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c
index 2486cda3243bc..69e38f477b1e4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c
@@ -150,7 +150,7 @@ static int mt7663s_tx_pick_quota(struct mt76_sdio *sdio, enum mt76_txq_id qid,
 			return -EBUSY;
 	} else {
 		if (sdio->sched.pse_data_quota < *pse_size + pse_sz ||
-		    sdio->sched.ple_data_quota < *ple_size)
+		    sdio->sched.ple_data_quota < *ple_size + 1)
 			return -EBUSY;
 
 		*ple_size = *ple_size + 1;
-- 
2.27.0



