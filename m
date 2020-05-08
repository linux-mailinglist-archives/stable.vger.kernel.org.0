Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E642D1CAC24
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbgEHMul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:50:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728049AbgEHMui (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:50:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BDE324963;
        Fri,  8 May 2020 12:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942237;
        bh=X+QFvlslj3xLEnQMTiymE5gzDAxb491WfUk+/OQDZIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WR1mR3lXFBiCEQzL6wN6UZIDoQMI7jOWmNEy7IcUFra2dnkE6EHBZa+xro6mUQ0in
         dXmpIQUIqUP2Ptz0wUcPtyhn1oJpG2p3A/uXhdu8tdLzsLFzxwiz0INv0jnMXwl27J
         mdsCQ+gkbRFzgN6h8AfKmRPBZINDeB/1nKa1iYJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 20/22] ALSA: hda: Match both PCI ID and SSID for driver blacklist
Date:   Fri,  8 May 2020 14:35:32 +0200
Message-Id: <20200508123036.413187466@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123033.915895060@linuxfoundation.org>
References: <20200508123033.915895060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 977dfef40c8996b69afe23a9094d184049efb7bb upstream.

The commit 3c6fd1f07ed0 ("ALSA: hda: Add driver blacklist") added a
new blacklist for the devices that are known to have empty codecs, and
one of the entries was ASUS ROG Zenith II (PCI SSID 1043:874f).
However, it turned out that the very same PCI SSID is used for the
previous model that does have the valid HD-audio codecs and the change
broke the sound on it.

Since the empty codec problem appear on the certain AMD platform (PCI
ID 1022:1487), this patch changes the blacklist matching to both PCI
ID and SSID using pci_match_id().  Also, the entry that was removed by
the previous fix for ASUS ROG Zenigh II is re-added.

Link: https://lore.kernel.org/r/20200424061222.19792-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2172,9 +2172,10 @@ static const struct hdac_io_ops pci_hda_
  * some HD-audio PCI entries are exposed without any codecs, and such devices
  * should be ignored from the beginning.
  */
-static const struct snd_pci_quirk driver_blacklist[] = {
-	SND_PCI_QUIRK(0x1462, 0xcb59, "MSI TRX40 Creator", 0),
-	SND_PCI_QUIRK(0x1462, 0xcb60, "MSI TRX40", 0),
+static const struct pci_device_id driver_blacklist[] = {
+	{ PCI_DEVICE_SUB(0x1022, 0x1487, 0x1043, 0x874f) }, /* ASUS ROG Zenith II / Strix */
+	{ PCI_DEVICE_SUB(0x1022, 0x1487, 0x1462, 0xcb59) }, /* MSI TRX40 Creator */
+	{ PCI_DEVICE_SUB(0x1022, 0x1487, 0x1462, 0xcb60) }, /* MSI TRX40 */
 	{}
 };
 
@@ -2197,7 +2198,7 @@ static int azx_probe(struct pci_dev *pci
 	bool schedule_probe;
 	int err;
 
-	if (snd_pci_quirk_lookup(pci, driver_blacklist)) {
+	if (pci_match_id(driver_blacklist, pci)) {
 		dev_info(&pci->dev, "Skipping the blacklisted device\n");
 		return -ENODEV;
 	}


