Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A357D44023
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbfFMQDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:03:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731387AbfFMIrf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:47:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A93C1206BA;
        Thu, 13 Jun 2019 08:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415655;
        bh=pjnwfwGiJYutj18puiYrP3QmViEjlCpeHyEpfC+fZKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qJn24IPU06ukPgXuwepQoPELz4bz1aumLlEbVASaHK0w9UnD9ieydQqNBNswZpHcj
         x3hGs6Bv3pYNonHVBOSz/9fAwdXe4qEMKLN7qzHXnlyNr08UnyZsAJC0yIaD323x+4
         qn1RobflhphGHxYg0GStYNARgfhZoH/KZ0fXNwmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liwei Song <liwei.song@windriver.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 079/155] ALSA: hda - Register irq handler after the chip initialization
Date:   Thu, 13 Jun 2019 10:33:11 +0200
Message-Id: <20190613075657.448190480@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f495222e28275222ab6fd93813bd3d462e16d340 ]

Currently the IRQ handler in HD-audio controller driver is registered
before the chip initialization.  That is, we have some window opened
between the azx_acquire_irq() call and the CORB/RIRB setup.  If an
interrupt is triggered in this small window, the IRQ handler may
access to the uninitialized RIRB buffer, which leads to a NULL
dereference Oops.

This is usually no big problem since most of Intel chips do register
the IRQ via MSI, and we've already fixed the order of the IRQ
enablement and the CORB/RIRB setup in the former commit b61749a89f82
("sound: enable interrupt after dma buffer initialization"), hence the
IRQ won't be triggered in that room.  However, some platforms use a
shared IRQ, and this may allow the IRQ trigger by another source.

Another possibility is the kdump environment: a stale interrupt might
be present in there, the IRQ handler can be falsely triggered as well.

For covering this small race, let's move the azx_acquire_irq() call
after hda_intel_init_chip() call.  Although this is a bit radical
change, it can cover more widely than checking the CORB/RIRB setup
locally in the callee side.

Reported-by: Liwei Song <liwei.song@windriver.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 2ec91085fa3e..789308f54785 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1788,9 +1788,6 @@ static int azx_first_init(struct azx *chip)
 			chip->msi = 0;
 	}
 
-	if (azx_acquire_irq(chip, 0) < 0)
-		return -EBUSY;
-
 	pci_set_master(pci);
 	synchronize_irq(bus->irq);
 
@@ -1904,6 +1901,9 @@ static int azx_first_init(struct azx *chip)
 		return -ENODEV;
 	}
 
+	if (azx_acquire_irq(chip, 0) < 0)
+		return -EBUSY;
+
 	strcpy(card->driver, "HDA-Intel");
 	strlcpy(card->shortname, driver_short_names[chip->driver_type],
 		sizeof(card->shortname));
-- 
2.20.1



