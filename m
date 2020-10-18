Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70912291F10
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388095AbgJRT5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:57:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726718AbgJRTT1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:19:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4337D22314;
        Sun, 18 Oct 2020 19:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048766;
        bh=jGhIYn9+hreKv4nbyLYh0TO9+zKHvDDLYmmXOSDfhiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2aFP3GR/xPQgNrnolYGEff0YOyBN/Eszbvke+i+9iiIReY9jXZuZD/8JXFfxEEaMe
         xix6IMiWVGM/GDa1mO3y9BK6L4FbexqGRZErcjWC/F4YBiit9ypZ/8q25SNKeHomld
         j+zPqlHf+Z9cymQcYtC+i+B5HF6y0xuY7SgAzQ8Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.9 066/111] misc: rtsx: Fix memory leak in rtsx_pci_probe
Date:   Sun, 18 Oct 2020 15:17:22 -0400
Message-Id: <20201018191807.4052726-66-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>

[ Upstream commit bc28369c6189009b66d9619dd9f09bd8c684bb98 ]

When mfd_add_devices() fail, pcr->slots should also be freed. However,
the current implementation does not free the member, leading to a memory
leak.

Fix this by adding a new goto label that frees pcr->slots.

Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Link: https://lore.kernel.org/r/20200909071853.4053-1-keitasuzuki.park@sslab.ics.keio.ac.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/cardreader/rtsx_pcr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/cardreader/rtsx_pcr.c b/drivers/misc/cardreader/rtsx_pcr.c
index 37ccc67f4914b..f2b2805942f50 100644
--- a/drivers/misc/cardreader/rtsx_pcr.c
+++ b/drivers/misc/cardreader/rtsx_pcr.c
@@ -1562,12 +1562,14 @@ static int rtsx_pci_probe(struct pci_dev *pcidev,
 	ret = mfd_add_devices(&pcidev->dev, pcr->id, rtsx_pcr_cells,
 			ARRAY_SIZE(rtsx_pcr_cells), NULL, 0, NULL);
 	if (ret < 0)
-		goto disable_irq;
+		goto free_slots;
 
 	schedule_delayed_work(&pcr->idle_work, msecs_to_jiffies(200));
 
 	return 0;
 
+free_slots:
+	kfree(pcr->slots);
 disable_irq:
 	free_irq(pcr->irq, (void *)pcr);
 disable_msi:
-- 
2.25.1

