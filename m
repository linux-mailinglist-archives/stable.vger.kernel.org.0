Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109301CAEAF
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729352AbgEHMpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:45:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729348AbgEHMpy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:45:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 457A921473;
        Fri,  8 May 2020 12:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941953;
        bh=ckdokyxCcZHS3WWPIBXErXIFlstl00/XsmL+7HOVBiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PsUzmY4fcJeAsRqOqAEt4t9YET/f7gNJyxHC569jul3XRVB7hGtNmOz67lxgCe5HK
         pfNAlsQaHWoEosGBS6ShhGOxmvitPBI1sGZ31CkKRaEG3RvO3OmwlT52WuzIe+tTVg
         pdWCB4iWPibNFh0llL28CILqnw6Y1+B6bjtoP0PE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=C3=89meric=20MASCHINO?= <emeric.maschino@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 239/312] ALSA: fm801: Initialize chip after IRQ handler is registered
Date:   Fri,  8 May 2020 14:33:50 +0200
Message-Id: <20200508123141.234437570@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 610e1ae9b533be82b3aa118b907e0a703256913d upstream.

The commit b56fa687e02b ("ALSA: fm801: detect FM-only card earlier")
rearranged initialization calls, i.e. it makes snd_fm801_chip_init() to
be called before we register interrupt handler and set PCI bus
mastering.

Somehow it prevents FM801-AU to work properly. Thus, partially revert
initialization order changed by commit mentioned above.

Fixes: b56fa687e02b ("ALSA: fm801: detect FM-only card earlier")
Reported-by: Émeric MASCHINO <emeric.maschino@gmail.com>
Tested-by: Émeric MASCHINO <emeric.maschino@gmail.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: <stable@vger.kernel.org> # v4.5+
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/fm801.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -1225,8 +1225,6 @@ static int snd_fm801_create(struct snd_c
 		}
 	}
 
-	snd_fm801_chip_init(chip);
-
 	if ((chip->tea575x_tuner & TUNER_ONLY) == 0) {
 		if (devm_request_irq(&pci->dev, pci->irq, snd_fm801_interrupt,
 				IRQF_SHARED, KBUILD_MODNAME, chip)) {
@@ -1238,6 +1236,8 @@ static int snd_fm801_create(struct snd_c
 		pci_set_master(pci);
 	}
 
+	snd_fm801_chip_init(chip);
+
 	if ((err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, chip, &ops)) < 0) {
 		snd_fm801_free(chip);
 		return err;


