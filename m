Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4790291D35
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733161AbgJRTns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:43:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728793AbgJRTXc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:23:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34BC5222EB;
        Sun, 18 Oct 2020 19:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049011;
        bh=qmmnkl21MlSEpLMHKOuOV+oJnCDLpEXf/0WNi7aAr9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0E4pIESSQkmx2Y8Iv17kFduNT4OFlGKasf8FiRmKn1TgXCdsKvhRXS6R3i9VmJn6I
         zVHcU+mD2O4uIVuhcgJObXq45KuZlfR5YrtKVavlF+eNjeMa/vD0UCLfHefuxPgVbH
         V97h7Ggms4siu950uwhsXa6T8HF+wwL7pvGeQMV4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 47/80] misc: rtsx: Fix memory leak in rtsx_pci_probe
Date:   Sun, 18 Oct 2020 15:21:58 -0400
Message-Id: <20201018192231.4054535-47-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192231.4054535-1-sashal@kernel.org>
References: <20201018192231.4054535-1-sashal@kernel.org>
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
index 1958833b3b74e..4fd57052ddd3d 100644
--- a/drivers/misc/cardreader/rtsx_pcr.c
+++ b/drivers/misc/cardreader/rtsx_pcr.c
@@ -1534,12 +1534,14 @@ static int rtsx_pci_probe(struct pci_dev *pcidev,
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

