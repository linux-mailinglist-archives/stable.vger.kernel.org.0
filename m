Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8EC201216
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405313AbgFSPr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:47:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393450AbgFSPZl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:25:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D31D20734;
        Fri, 19 Jun 2020 15:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580341;
        bh=CvFeTCugHHRONHTP2eRlFRtgrbQbpBoVKDgXt7fTF8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eBxM4y2KReF3tPNe2+/UmdHqUHuCKUkUXLJYdH+hYGYNESg6BqrfXnYlq7jnP0p/T
         ajpUxFDe0StkjC+qJvT5dtBYQRkyMk1J8pBNilgNb1Rj9CjeEj4PLKf5tbNADU3P17
         u1ZzYKdRKUyFklFY/oo5P1JrbPdI0ED+gBr0KR/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 182/376] mt76: mt7615: fix mt7615_firmware_own for mt7663e
Date:   Fri, 19 Jun 2020 16:31:40 +0200
Message-Id: <20200619141718.967086136@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit becdf0d5d7a46f5ed1f12405ffae4b04764fe27c ]

Check the firmware-own configuration has been applied polling
MT_CONN_HIF_ON_LPCTL register

Fixes: f40ac0f3d3c0 ("mt76: mt7615: introduce mt7663e support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index a19fb0cb7794..0d56e0834bde 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -1550,9 +1550,8 @@ static int mt7615_firmware_own(struct mt7615_dev *dev)
 
 	mt76_wr(dev, addr, MT_CFG_LPCR_HOST_FW_OWN);
 
-	if (is_mt7622(&dev->mt76) &&
-	    !mt76_poll_msec(dev, MT_CFG_LPCR_HOST,
-			    MT_CFG_LPCR_HOST_FW_OWN,
+	if (!is_mt7615(&dev->mt76) &&
+	    !mt76_poll_msec(dev, addr, MT_CFG_LPCR_HOST_FW_OWN,
 			    MT_CFG_LPCR_HOST_FW_OWN, 3000)) {
 		dev_err(dev->mt76.dev, "Timeout for firmware own\n");
 		return -EIO;
-- 
2.25.1



