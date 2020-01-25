Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0745C149716
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 19:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgAYSKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jan 2020 13:10:37 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54533 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgAYSKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jan 2020 13:10:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579975835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=l5BsgYdFO1ghceyovlDf/lBvRehsk4J2RDjUF7pfet8=;
        b=QlLLque+RfoOrB1cC9QwYbehM3m11+PVYBOSGguk5PBOvyzbGyrImLsaOftF5ZFfci7ghC
        euP8lsPZy9WqNbcdI4H7yi9SuqtOv5QN7jNEqjc780uY+ParzlZr4sapd8sKTmLAhzkFNX
        JdIua6QwrCkeaHRjtfwr5uaPMTxM4/A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-iimH4PKBM8u3Lqm5KX8HFw-1; Sat, 25 Jan 2020 13:10:31 -0500
X-MC-Unique: iimH4PKBM8u3Lqm5KX8HFw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76250107ACC4;
        Sat, 25 Jan 2020 18:10:29 +0000 (UTC)
Received: from dhcp-44-196.space.revspace.nl (unknown [10.36.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1112260BEC;
        Sat, 25 Jan 2020 18:10:26 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Takashi Iwai <tiwai@suse.com>, Jaroslav Kysela <perex@perex.cz>
Cc:     Hans de Goede <hdegoede@redhat.com>, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: [PATCH] ALSA: hda: Add Clevo W65_67SB the power_save blacklist
Date:   Sat, 25 Jan 2020 19:10:21 +0100
Message-Id: <20200125181021.70446-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Using HDA power-saving on the Clevo W65_67SB causes the first 0.5
seconds of audio to be missing every time audio starts playing.

This commit adds the Clevo W65_67SB the power_save blacklist to avoid
this issue.

Cc: stable@vger.kernel.org
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=3D1525104
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 sound/pci/hda/hda_intel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 5b92f290cbb0..54d9ea1750f9 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2185,6 +2185,8 @@ static struct snd_pci_quirk power_save_blacklist[] =
=3D {
 	/* https://bugzilla.redhat.com/show_bug.cgi?id=3D1581607 */
 	SND_PCI_QUIRK(0x1558, 0x3501, "Clevo W35xSS_370SS", 0),
 	/* https://bugzilla.redhat.com/show_bug.cgi?id=3D1525104 */
+	SND_PCI_QUIRK(0x1558, 0x6504, "Clevo W65_67SB", 0),
+	/* https://bugzilla.redhat.com/show_bug.cgi?id=3D1525104 */
 	SND_PCI_QUIRK(0x1028, 0x0497, "Dell Precision T3600", 0),
 	/* https://bugzilla.redhat.com/show_bug.cgi?id=3D1525104 */
 	/* Note the P55A-UD3 and Z87-D3HP share the subsys id for the HDA dev *=
/
--=20
2.23.0

