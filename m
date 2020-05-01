Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D100E1C1705
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731323AbgEAN4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:56:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728867AbgEANcn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:32:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A124208DB;
        Fri,  1 May 2020 13:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339962;
        bh=SPUAimYWK6VqhccesxSl0hV+O0yKfpd79FZoWPQ1uGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AZ0kA+wxi/ddjrLADW9cSeRkbFfLFXwCekkhU0Aw+O8Oe+JxKER+KWiAgmEkuwzhK
         O5m+2tuTnUHf1g8IUGv0spabVvYKKe1Y7oF7oy2fkhlwbClYliWOOyVDMG65pKQhuM
         gUsRR+Wc33yZH1IKvOHcGRU6ZcIkmZEcv83Ttljk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johnathan Smithinovic <johnathan.smithinovic@gmx.at>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 037/117] ALSA: hda: Remove ASUS ROG Zenith from the blacklist
Date:   Fri,  1 May 2020 15:21:13 +0200
Message-Id: <20200501131549.179095142@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
References: <20200501131544.291247695@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit a8cf44f085ac12c0b5b8750ebb3b436c7f455419 ]

The commit 3c6fd1f07ed0 ("ALSA: hda: Add driver blacklist") added a
new blacklist for the devices that are known to have empty codecs, and
one of the entries was ASUS ROG Zenith II (PCI SSID 1043:874f).
However, it turned out that the very same PCI SSID is used for the
previous model that does have the valid HD-audio codecs and the change
broke the sound on it.

This patch reverts the corresponding entry as a temporary solution.
Although Zenith II and co will see get the empty HD-audio bus again,
it'd be merely resource wastes and won't affect the functionality,
so it's no end of the world.  We'll need to address this later,
e.g. by either switching to DMI string matching or using PCI ID &
SSID pairs.

Fixes: 3c6fd1f07ed0 ("ALSA: hda: Add driver blacklist")
Reported-by: Johnathan Smithinovic <johnathan.smithinovic@gmx.at>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200419071926.22683-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index d392c1ec0b282..46670da047074 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2173,7 +2173,6 @@ static const struct hdac_io_ops pci_hda_io_ops = {
  * should be ignored from the beginning.
  */
 static const struct snd_pci_quirk driver_blacklist[] = {
-	SND_PCI_QUIRK(0x1043, 0x874f, "ASUS ROG Zenith II / Strix", 0),
 	SND_PCI_QUIRK(0x1462, 0xcb59, "MSI TRX40 Creator", 0),
 	SND_PCI_QUIRK(0x1462, 0xcb60, "MSI TRX40", 0),
 	{}
-- 
2.20.1



