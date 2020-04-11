Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51C421A516B
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgDKMQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:16:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728268AbgDKMQh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:16:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CAC220644;
        Sat, 11 Apr 2020 12:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607397;
        bh=xacCaSjYPsHBVqZkGGRHnwwdd/qhSoItzvcjxjYZf0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KpICZ0XdtQ7y4TXTA6cvpmnz/Uojx9w4E8iAfU8mCQSX4RjJj9IbHtZI+UqKhMKbA
         VTHgIEYHXt+iF6y+udDXzVZFojorzkKJ9hpQhh+zNyEv4xW9hFeX+CloBAaUNOK2DW
         +K8PfGlcS2PoDbL0y2k8jCWXMgqVrRJOrs66n+Io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geoffrey Allott <geoffrey@allott.email>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 21/54] ALSA: hda/ca0132 - Add Recon3Di quirk to handle integrated sound on EVGA X99 Classified motherboard
Date:   Sat, 11 Apr 2020 14:09:03 +0200
Message-Id: <20200411115510.609102571@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115508.284500414@linuxfoundation.org>
References: <20200411115508.284500414@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geoffrey Allott <geoffrey@allott.email>

commit e9097e47e349b747dee50f935216de0ffb662962 upstream.

I have a system which has an EVGA X99 Classified motherboard. The pin
assignments for the HD Audio controller are not correct under Linux.
Windows 10 works fine and informs me that it's using the Recon3Di
driver, and on Linux, `cat
/sys/class/sound/card0/device/subsystem_{vendor,device}` yields

0x3842
0x1038

This patch adds a corresponding entry to the quirk list.

Signed-off-by: Geoffrey Allott <geoffrey@allott.email>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/a6cd56b678c00ce2db3685e4278919f2584f8244.camel@allott.email
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_ca0132.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -1069,6 +1069,7 @@ static const struct snd_pci_quirk ca0132
 	SND_PCI_QUIRK(0x1458, 0xA016, "Recon3Di", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x1458, 0xA026, "Gigabyte G1.Sniper Z97", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x1458, 0xA036, "Gigabyte GA-Z170X-Gaming 7", QUIRK_R3DI),
+	SND_PCI_QUIRK(0x3842, 0x1038, "EVGA X99 Classified", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x1102, 0x0013, "Recon3D", QUIRK_R3D),
 	{}
 };


