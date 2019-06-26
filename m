Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 382D856087
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfFZDlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:41:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbfFZDlv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:41:51 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-74.mobile.att.net [107.77.172.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A6472146E;
        Wed, 26 Jun 2019 03:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520510;
        bh=qZrYUCu2arjVH/XGWiobP8O3+hLn3+p6Pl5mkDCDoGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=syAouCE8AJeMVLdI2m4k9MGtpxcGRLrAJ4Ar11juy5RelW8GcAI/jy+0JOxq1vqSF
         bVY1CYYkpEE5q51zbpqJypNhrowvl7szUrcWlQSva1fj0Ogq4qKK1tHJz0ldaWVB2n
         W0UQtIaiTnY6mnlqBE+qu5deR/S3shaT8LTnZIbI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 14/51] ASoC: hda: fix unbalanced codec dev refcount for HDA_DEV_ASOC
Date:   Tue, 25 Jun 2019 23:40:30 -0400
Message-Id: <20190626034117.23247-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034117.23247-1-sashal@kernel.org>
References: <20190626034117.23247-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit d6947bb234dcc86e878d502516d0fb9d635aa2ae ]

HDA_DEV_ASOC type codec device refcounts are managed differently
from HDA_DEV_LEGACY devices. The refcount is released explicitly
in snd_hdac_ext_bus_device_remove() for ASOC type devices.
So, remove the put_device() call in snd_hda_codec_dev_free()
for such devices to make the refcount balanced. This will prevent
the NULL pointer exception when the codec driver is released
after the card is freed.

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_codec.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index b20eb7fc83eb..fcdf2cd3783b 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -840,7 +840,14 @@ static int snd_hda_codec_dev_free(struct snd_device *device)
 	if (codec->core.type == HDA_DEV_LEGACY)
 		snd_hdac_device_unregister(&codec->core);
 	codec_display_power(codec, false);
-	put_device(hda_codec_dev(codec));
+
+	/*
+	 * In the case of ASoC HD-audio bus, the device refcount is released in
+	 * snd_hdac_ext_bus_device_remove() explicitly.
+	 */
+	if (codec->core.type == HDA_DEV_LEGACY)
+		put_device(hda_codec_dev(codec));
+
 	return 0;
 }
 
-- 
2.20.1

