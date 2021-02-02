Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0175930CB8A
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbhBBT1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:27:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233539AbhBBN7L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:59:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2764E64F71;
        Tue,  2 Feb 2021 13:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273587;
        bh=Q1Un96wR1iagfGo+CoPWzh5Jo6V09DwWjVSrAUpXUHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBT5g1S7c5MGNDTt4Y+kGg3I3/4KWNLFLdvluuf5k6r4MP2DSYeUpfKWbu+nSZPeU
         G0l5rT/bDMBmJYbcO+nas24Y07B8p+ku9R/xy13iE9JO2VzWDWc43yXybIMqZXpo2Z
         1okJ3y0VZ1YUZLlrT82JJHw/nCXNyJHgtwUngKZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 07/61] ALSA: hda/via: Apply the workaround generically for Clevo machines
Date:   Tue,  2 Feb 2021 14:37:45 +0100
Message-Id: <20210202132946.787422784@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 4961167bf7482944ca09a6f71263b9e47f949851 upstream.

We've got another report indicating a similar problem wrt the
power-saving behavior with VIA codec on Clevo machines.  Let's apply
the existing workaround generically to all Clevo devices with VIA
codecs to cover all in once.

BugLink: https://bugzilla.opensuse.org/show_bug.cgi?id=1181330
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210126165603.11683-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_via.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -1043,7 +1043,7 @@ static const struct hda_fixup via_fixups
 static const struct snd_pci_quirk vt2002p_fixups[] = {
 	SND_PCI_QUIRK(0x1043, 0x1487, "Asus G75", VIA_FIXUP_ASUS_G75),
 	SND_PCI_QUIRK(0x1043, 0x8532, "Asus X202E", VIA_FIXUP_INTMIC_BOOST),
-	SND_PCI_QUIRK(0x1558, 0x3501, "Clevo W35xSS_370SS", VIA_FIXUP_POWER_SAVE),
+	SND_PCI_QUIRK_VENDOR(0x1558, "Clevo", VIA_FIXUP_POWER_SAVE),
 	{}
 };
 


