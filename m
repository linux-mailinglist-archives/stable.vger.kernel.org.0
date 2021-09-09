Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE000404C28
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236545AbhIIL4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:56:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239892AbhIILyK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:54:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08C846138E;
        Thu,  9 Sep 2021 11:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187883;
        bh=gMzlS6eZ1f/ByV3KBZmIrkiSw6UxTcu2UVXACyjKUw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wesw0w6tM8cQIj/SM+2L1+lcs8ODNqvh+eWS3qsHUb79uuup9MOJ+swzm9jdXnk9m
         cs2RFFkHI1ID4Y0hnaTea3lzymd3JZzLPopIu3PB5um6xDT6+qJDLlYxGeyULlz/lb
         ypInvHyZFaqOsFfgZlZ4D9KyPToviAIsLVRZVqQVx9933fSux0toxaBX9uz/cQKEbV
         vAJ25UrvIPzi8Z/+CYCnPl4dnjE8j/MAlwP0YAMbQd7QWC/GGqOysRuCDbMhUZz1/s
         Tp7JGxPn1KiaHFIG0QH7yL/gfJH+IEPU0fgKbDK16WCQGMedjDq4g/tJcsvC5q+DBy
         KVZkRybgyFVaA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.14 166/252] ALSA: hda: Drop workaround for a hang at shutdown again
Date:   Thu,  9 Sep 2021 07:39:40 -0400
Message-Id: <20210909114106.141462-166-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 8fc8e903156f42c66245838441d03607e9067381 ]

The commit 0165c4e19f6e ("ALSA: hda: Fix hang during shutdown due to
link reset") modified the shutdown callback of the HD-audio controller
for working around a hang.  Meanwhile, the actual culprit of the hang
was identified to be the leftover active codecs that may interfere
with the powered down controller somehow, but we took a minimal fix
approach for 5.14, and that was the commit above.

Now, since the codec drivers go runtime-suspend at shutdown for 5.15,
we can revert the change and make sure that the full runtime-suspend
is performed at shutdown of HD-audio controller again.  This patch
essentially reverts the commit above to restore the behavior.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=214045
Link: https://lore.kernel.org/r/20210817075630.7115-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 0062c18b646a..0322b289505e 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -883,11 +883,10 @@ static unsigned int azx_get_pos_skl(struct azx *chip, struct azx_dev *azx_dev)
 	return azx_get_pos_posbuf(chip, azx_dev);
 }
 
-static void __azx_shutdown_chip(struct azx *chip, bool skip_link_reset)
+static void azx_shutdown_chip(struct azx *chip)
 {
 	azx_stop_chip(chip);
-	if (!skip_link_reset)
-		azx_enter_link_reset(chip);
+	azx_enter_link_reset(chip);
 	azx_clear_irq_pending(chip);
 	display_power(chip, false);
 }
@@ -896,11 +895,6 @@ static void __azx_shutdown_chip(struct azx *chip, bool skip_link_reset)
 static DEFINE_MUTEX(card_list_lock);
 static LIST_HEAD(card_list);
 
-static void azx_shutdown_chip(struct azx *chip)
-{
-	__azx_shutdown_chip(chip, false);
-}
-
 static void azx_add_card_list(struct azx *chip)
 {
 	struct hda_intel *hda = container_of(chip, struct hda_intel, chip);
@@ -2391,7 +2385,7 @@ static void azx_shutdown(struct pci_dev *pci)
 		return;
 	chip = card->private_data;
 	if (chip && chip->running)
-		__azx_shutdown_chip(chip, true);
+		azx_shutdown_chip(chip);
 }
 
 /* PCI IDs */
-- 
2.30.2

