Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E2A450E35
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240765AbhKOSNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:13:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:46102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240105AbhKOSFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 185B563290;
        Mon, 15 Nov 2021 17:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998157;
        bh=3KSsaF+4z/k7Pn25UsyVPFGavT2oKeP0mgdB6MzLY+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ZISKgmka1vMtf8Z9IH4B7+Vyyhoo5zo3Rs011sbshw802GF+vP78F80kbIiQmtUy
         I5fKUshxJXjRbwfz6EogSDUGL1+uXtwKG/JZKobDCCi7Ju44OlI6mZMKVZfdjLnmes
         4sXH2V0zZ2raJgStM10uR85scoWgs1K4O9/ou7Mw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, youling257@gmail.com,
        Imre Deak <imre.deak@intel.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 409/575] ALSA: hda: Fix hang during shutdown due to link reset
Date:   Mon, 15 Nov 2021 18:02:14 +0100
Message-Id: <20211115165357.911808671@linuxfoundation.org>
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

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit 0165c4e19f6ec76b535de090e4bd145c73810c51 ]

During system shutdown codecs may be still active, and resetting the
controller->codec HW link in this state - based on the bug reporter's
tests - leads to the shutdown sequence to get stuck. This happens at
least on the reporter's KBL system with an ALC662 codec.

For now fix the issue by skipping the link reset step.

Fixes: 472e18f63c42 ("ALSA: hda: Release controller display power during shutdown/reboot")
Reported-and-tested-by: youling257@gmail.com
Cc: youling257@gmail.com
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://lore.kernel.org/r/20210816174259.2759103-1-imre.deak@intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index e31eafe73661f..a0955e17adee9 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -936,10 +936,11 @@ static unsigned int azx_get_pos_skl(struct azx *chip, struct azx_dev *azx_dev)
 	return azx_get_pos_posbuf(chip, azx_dev);
 }
 
-static void azx_shutdown_chip(struct azx *chip)
+static void __azx_shutdown_chip(struct azx *chip, bool skip_link_reset)
 {
 	azx_stop_chip(chip);
-	azx_enter_link_reset(chip);
+	if (!skip_link_reset)
+		azx_enter_link_reset(chip);
 	azx_clear_irq_pending(chip);
 	display_power(chip, false);
 }
@@ -948,6 +949,11 @@ static void azx_shutdown_chip(struct azx *chip)
 static DEFINE_MUTEX(card_list_lock);
 static LIST_HEAD(card_list);
 
+static void azx_shutdown_chip(struct azx *chip)
+{
+	__azx_shutdown_chip(chip, false);
+}
+
 static void azx_add_card_list(struct azx *chip)
 {
 	struct hda_intel *hda = container_of(chip, struct hda_intel, chip);
@@ -2461,7 +2467,7 @@ static void azx_shutdown(struct pci_dev *pci)
 		return;
 	chip = card->private_data;
 	if (chip && chip->running)
-		azx_shutdown_chip(chip);
+		__azx_shutdown_chip(chip, true);
 }
 
 /* PCI IDs */
-- 
2.33.0



