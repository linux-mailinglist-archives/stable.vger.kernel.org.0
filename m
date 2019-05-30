Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB792F387
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729569AbfE3DNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:13:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729563AbfE3DNo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:44 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD854244EF;
        Thu, 30 May 2019 03:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186023;
        bh=1PINnsjt3g6jDdOQ4/iT1pQCvWacpDG0iLFLg21C2aI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wZhFRrc/EOPIP16YUkInbeeP7xBOr7BQ/aM1r4NM8JqroLjgmv8IaraP6fRSWxcxK
         VlhLHi7ga0AqVYpwbvWcxBqw1/8IiL96q4cwJjA/rM1DUnTBXBQ381sqWaoJBddSsi
         S0FNkBiYrKSgh3YHZouzS6P0JYzb5MOqvpe/C22Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bard liao <yung-chuan.liao@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 095/346] ALSA: hda: fix unregister device twice on ASoC driver
Date:   Wed, 29 May 2019 20:02:48 -0700
Message-Id: <20190530030545.973849171@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4d95c51776b2edb4d4ebcea00b6e5a1fe538ce66 ]

snd_hda_codec_device_new() is used by both legacy HDA and ASoC
driver. However, we will call snd_hdac_device_unregister() in
snd_hdac_ext_bus_device_remove() for ASoC device. This patch uses
the type flag in hdac_device struct to determine is it a ASoC device
or legacy HDA device and call snd_hdac_device_unregister() in
snd_hda_codec_dev_free() only if it is a legacy HDA device.

Signed-off-by: Bard liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_codec.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index b238e903b9d7a..a00bd79866466 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -841,7 +841,13 @@ static int snd_hda_codec_dev_free(struct snd_device *device)
 	struct hda_codec *codec = device->device_data;
 
 	codec->in_freeing = 1;
-	snd_hdac_device_unregister(&codec->core);
+	/*
+	 * snd_hda_codec_device_new() is used by legacy HDA and ASoC driver.
+	 * We can't unregister ASoC device since it will be unregistered in
+	 * snd_hdac_ext_bus_device_remove().
+	 */
+	if (codec->core.type == HDA_DEV_LEGACY)
+		snd_hdac_device_unregister(&codec->core);
 	codec_display_power(codec, false);
 	put_device(hda_codec_dev(codec));
 	return 0;
-- 
2.20.1



