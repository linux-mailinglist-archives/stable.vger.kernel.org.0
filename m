Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7305451DF4
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348042AbhKPAef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344010AbhKOTXI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 210AB63612;
        Mon, 15 Nov 2021 18:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002209;
        bh=5suGFwwadIkdHdYgMByz58YOtxMn0raXcjXDY6TXIZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZKOFPm24V5imkPpU4DWlgAeDGqMvJsyYSmy2dN/orWsIVRpDuYqQWvhbH/inA/pdV
         inqd0EY11wsekbQx7gQC4M0newS6OTFa9tKqa1iqr6N+JidjfLz7Maof4CnV6/Pt8V
         MWZGyr/AzxcFBc0W5RBJbGPntNWKj++tZHi5gCdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 478/917] mt76: mt7915: fix possible infinite loop release semaphore
Date:   Mon, 15 Nov 2021 17:59:33 +0100
Message-Id: <20211115165444.977406857@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index e7e396f58c92c..85c9c08ee2a82 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2790,7 +2790,7 @@ out:
 	default:
 		ret = -EAGAIN;
 		dev_err(dev->mt76.dev, "Failed to release patch semaphore\n");
-		goto out;
+		break;
 	}
 	release_firmware(fw);
 
-- 
2.33.0



