Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20B5DE68E1
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730308AbfJ0Vcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:32:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727319AbfJ0VOM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:14:12 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C9332064A;
        Sun, 27 Oct 2019 21:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210852;
        bh=sZbX5Yt3N5y0iN6FpR9DzyZ0uhLEKkpk4eAQNGBDUuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xy2aY/85Y7weDkxBOtstj6h2+eVJyTn+N27r0GzKsJJOCkWesk8RToaqH7ctj7aAR
         tWCABB/6CRsekh5SjOyVbsW3vlzY3XjWbxyueyGZWJllRAHuDLYJ9lEZ+zMjcAB3Hz
         2orow+amzKRf9d/kgOnXvsz4sTxj5Dxpo4vaKvhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Przemys=C5=82aw=20Kopa?= <prymoo@gmail.com>,
        Rivera Valdez <riveravaldez@ysinembargo.com>,
        Lukas Wunner <lukas@wunner.de>,
        Daniel Drake <dan@reactivated.net>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 40/93] ALSA: hda - Force runtime PM on Nvidia HDMI codecs
Date:   Sun, 27 Oct 2019 22:00:52 +0100
Message-Id: <20191027203258.387618254@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 94989e318b2f11e217e86bee058088064fa9a2e9 upstream.

Przemysław Kopa reports that since commit b516ea586d71 ("PCI: Enable
NVIDIA HDA controllers"), the discrete GPU Nvidia GeForce GT 540M on his
2011 Samsung laptop refuses to runtime suspend, resulting in a power
regression and excessive heat.

Rivera Valdez witnesses the same issue with a GeForce GT 525M (GF108M)
of the same era, as does another Arch Linux user named "R0AR" with a
more recent GeForce GTX 1050 Ti (GP107M).

The commit exposes the discrete GPU's HDA controller and all four codecs
on the controller do not set the CLKSTOP and EPSS bits in the Supported
Power States Response.  They also do not set the PS-ClkStopOk bit in the
Get Power State Response.  hda_codec_runtime_suspend() therefore does
not call snd_hdac_codec_link_down(), which prevents each codec and the
PCI device from runtime suspending.

The same issue is present on some AMD discrete GPUs and we addressed it
by forcing runtime PM despite the bits not being set, see commit
57cb54e53bdd ("ALSA: hda - Force to link down at runtime suspend on
ATI/AMD HDMI").

Do the same for Nvidia HDMI codecs.

Fixes: b516ea586d71 ("PCI: Enable NVIDIA HDA controllers")
Link: https://bbs.archlinux.org/viewtopic.php?pid=1865512
Link: https://bugs.freedesktop.org/show_bug.cgi?id=75985#c81
Reported-by: Przemysław Kopa <prymoo@gmail.com>
Reported-by: Rivera Valdez <riveravaldez@ysinembargo.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: Daniel Drake <dan@reactivated.net>
Cc: stable@vger.kernel.org # v5.3+
Link: https://lore.kernel.org/r/3086bc75135c1e3567c5bc4f3cc4ff5cbf7a56c2.1571324194.git.lukas@wunner.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_hdmi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -3264,6 +3264,8 @@ static int patch_nvhdmi(struct hda_codec
 		nvhdmi_chmap_cea_alloc_validate_get_type;
 	spec->chmap.ops.chmap_validate = nvhdmi_chmap_validate;
 
+	codec->link_down_at_suspend = 1;
+
 	return 0;
 }
 


