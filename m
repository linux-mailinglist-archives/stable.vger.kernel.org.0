Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25F929AF17
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754788AbgJ0OHE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:07:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754784AbgJ0OHD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:07:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1B4922258;
        Tue, 27 Oct 2020 14:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807623;
        bh=O+IHjo24MmO5QxbAQXUaVG9tU1jK7u/IyWbU513gXiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ummyH8iJo0I/pbuIsJzUvY/NsFxDyUE9bwcngCVM1zEPiIESAtENj5zg2Lx5iKxL0
         ePX85vpg9cB34j1zK6j/5zn7GEk4EhgRsDHARf3dpnRpgCr3qVJTBiJh5qE0dsIkuC
         yMOPs+RVn0hK7LLZLfAY1GePZ3mnE5XthMW1KDp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 120/139] misc: rtsx: Fix memory leak in rtsx_pci_probe
Date:   Tue, 27 Oct 2020 14:50:14 +0100
Message-Id: <20201027134907.839556992@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134902.130312227@linuxfoundation.org>
References: <20201027134902.130312227@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/mfd/rtsx_pcr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 98029ee0959e3..be61f8606a045 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -1255,12 +1255,14 @@ static int rtsx_pci_probe(struct pci_dev *pcidev,
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



