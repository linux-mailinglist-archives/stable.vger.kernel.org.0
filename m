Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4CE45266C
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238999AbhKPCFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:05:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:48396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239806AbhKOSEt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:04:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 379A4632E1;
        Mon, 15 Nov 2021 17:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997949;
        bh=2xvxMc1YNouKD2Ue39r/MhuA0e4s91JtqNNxPrWHim8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tw3yQxshpDvWmVIGrEIpqkXrxZV6LifNhr+Hm7opDts/dka+pnzq9l72iN4iKtz15
         HI+RghwZDbsQ1dL4XXtSCVDmwgDvPtBDYtfTxfqWr+7P4o32JPs30Q7nJJWSrGKGzN
         9Rd5nrBUhVlrDaVpq9UI17+luxLcobR1AU0tPOgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 334/575] mt76: mt7915: fix possible infinite loop release semaphore
Date:   Mon, 15 Nov 2021 18:00:59 +0100
Message-Id: <20211115165355.342288785@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit e500c9470e26be66eb2bc6de773ae9091149118a ]

Fix possible infinite loop in mt7915_load_patch if
mt7915_mcu_patch_sem_ctrl always returns an error.

Fixes: e57b7901469fc ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 7c2d09a64882e..c36c7b0e918a4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2648,7 +2648,7 @@ out:
 	default:
 		ret = -EAGAIN;
 		dev_err(dev->mt76.dev, "Failed to release patch semaphore\n");
-		goto out;
+		break;
 	}
 	release_firmware(fw);
 
-- 
2.33.0



