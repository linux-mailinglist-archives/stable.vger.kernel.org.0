Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E31EFCA5E8
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404627AbfJCQh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:37:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392295AbfJCQh6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:37:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D164222C8;
        Thu,  3 Oct 2019 16:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120678;
        bh=NXMysJ5e2+Am4q6601uqhjNjIcYRPQ+6oZ2nGUXSlxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=liEVrL5z7meD7nm34tEySFyjNrChAAaYsaiMjI463a/ronRYu+3ORIi98ssTvkJ+r
         tc3d4h707rDCnz6a+7DDq8grbe+A7qSiedU4im+QMEbFpwHhcQq+8HSdx/bnjjHKzE
         soxVsypwtF9G01MLYA1LABInxow+Nq9bLxIljgUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 311/313] mt76: mt7615: always release sem in mt7615_load_patch
Date:   Thu,  3 Oct 2019 17:54:49 +0200
Message-Id: <20191003154603.815074337@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 2fc446487c364bf8bbd5f8f5f27e52d914fa1d72 ]

Release patch semaphore even if request_firmware fails in
mt7615_load_patch

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index dc1301effa242..e2dd425ac97e0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -289,9 +289,9 @@ static int mt7615_driver_own(struct mt7615_dev *dev)
 
 static int mt7615_load_patch(struct mt7615_dev *dev)
 {
-	const struct firmware *fw;
-	const struct mt7615_patch_hdr *hdr;
 	const char *firmware = MT7615_ROM_PATCH;
+	const struct mt7615_patch_hdr *hdr;
+	const struct firmware *fw = NULL;
 	int len, ret, sem;
 
 	sem = mt7615_mcu_patch_sem_ctrl(dev, 1);
@@ -307,7 +307,7 @@ static int mt7615_load_patch(struct mt7615_dev *dev)
 
 	ret = request_firmware(&fw, firmware, dev->mt76.dev);
 	if (ret)
-		return ret;
+		goto out;
 
 	if (!fw || !fw->data || fw->size < sizeof(*hdr)) {
 		dev_err(dev->mt76.dev, "Invalid firmware\n");
-- 
2.20.1



