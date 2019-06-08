Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5AD39DC0
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 13:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbfFHLns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 07:43:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:32950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728885AbfFHLnr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Jun 2019 07:43:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB07F21537;
        Sat,  8 Jun 2019 11:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994227;
        bh=V43q5vePLLILHyVdGJ8qzvNX5TaFaqGO9M2fhuBgr2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pq0RhgIds5nLpi6bG82sgqktE5yOqru+1SuOX1huoYAV3X2+0l9tFXSRHqtbYOHyN
         fReY+amTexlCwRt9rFOCThk/ADRDK/UgH5seh+H1Kzy2/EC+a8iOnqfRDmweROWgkZ
         DyzyiL7r/DAyMplqGk0BeEnQc/IY8cbh9xahu38Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bard Liao <yung-chuan.liao@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 28/49] ALSA: hda - Force polling mode on CNL for fixing codec communication
Date:   Sat,  8 Jun 2019 07:42:09 -0400
Message-Id: <20190608114232.8731-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608114232.8731-1-sashal@kernel.org>
References: <20190608114232.8731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit fa763f1b2858752e6150ffff46886a1b7faffc82 ]

We observed the same issue as reported by commit a8d7bde23e7130686b7662
("ALSA: hda - Force polling mode on CFL for fixing codec communication")
We don't have a better solution. So apply the same workaround to CNL.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 9bc8a7cb40ea..e895e2dd8764 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -378,6 +378,7 @@ enum {
 
 #define IS_BXT(pci) ((pci)->vendor == 0x8086 && (pci)->device == 0x5a98)
 #define IS_CFL(pci) ((pci)->vendor == 0x8086 && (pci)->device == 0xa348)
+#define IS_CNL(pci) ((pci)->vendor == 0x8086 && (pci)->device == 0x9dc8)
 
 static char *driver_short_names[] = {
 	[AZX_DRIVER_ICH] = "HDA Intel",
@@ -1795,8 +1796,8 @@ static int azx_create(struct snd_card *card, struct pci_dev *pci,
 	else
 		chip->bdl_pos_adj = bdl_pos_adj[dev];
 
-	/* Workaround for a communication error on CFL (bko#199007) */
-	if (IS_CFL(pci))
+	/* Workaround for a communication error on CFL (bko#199007) and CNL */
+	if (IS_CFL(pci) || IS_CNL(pci))
 		chip->polling_mode = 1;
 
 	err = azx_bus_init(chip, model[dev], &pci_hda_io_ops);
-- 
2.20.1

