Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD4F1C12EB
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbgEANZc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:25:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729023AbgEANZ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:25:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9395D208D6;
        Fri,  1 May 2020 13:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339527;
        bh=ZaolymePEi9YN4pYSwp3fniWhkkwp1vSbCFUxaZWuFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uWrAjzL5ohNKu8Sfpiz2OwGNeIv+3HmjYowQHFsB+hifDI/SFgDdmMLb1xfWTK53u
         yFHEMkIwvJW0DLBIKGDOU6pJ2D6RxmfYJuYaL+/rU+V6Min2JDlNoIxKHq7MCK61tT
         TLvvGwVd4szB0S0+lAeLVFuL2FUv1umGw7740NU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johnathan Smithinovic <johnathan.smithinovic@gmx.at>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 25/70] ALSA: hda: Remove ASUS ROG Zenith from the blacklist
Date:   Fri,  1 May 2020 15:21:13 +0200
Message-Id: <20200501131522.222176485@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.302599262@linuxfoundation.org>
References: <20200501131513.302599262@linuxfoundation.org>
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
index faf2554397021..da9f6749b3be2 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1978,7 +1978,6 @@ static const struct hdac_io_ops pci_hda_io_ops = {
  * should be ignored from the beginning.
  */
 static const struct snd_pci_quirk driver_blacklist[] = {
-	SND_PCI_QUIRK(0x1043, 0x874f, "ASUS ROG Zenith II / Strix", 0),
 	SND_PCI_QUIRK(0x1462, 0xcb59, "MSI TRX40 Creator", 0),
 	SND_PCI_QUIRK(0x1462, 0xcb60, "MSI TRX40", 0),
 	{}
-- 
2.20.1



