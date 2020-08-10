Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A772409D3
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgHJPgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:36:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728757AbgHJP1d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:27:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 630CA22BF3;
        Mon, 10 Aug 2020 15:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073252;
        bh=8DpZJzOA2XOE6mKbWrjqeDu4/W69O4cH8yppwCZN43w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dWd8yXT2IImxw0fRlr4IWyWFkzXotEbpsPSkgHt3a2SXB5asQ2sfv2Jk3iBDf2Lt0
         C4WLUAIF7VnjLzzoI3+JyeharsY03Q8awFTi9szU6YqTXrspoKyxe+5u+cRwTFeOUQ
         wGbZ+DTGBymJyJSepZb8sHKxkSV9srR+Dz0o5sCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 40/67] ALSA: hda: fix NULL pointer dereference during suspend
Date:   Mon, 10 Aug 2020 17:21:27 +0200
Message-Id: <20200810151811.413584797@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151809.438685785@linuxfoundation.org>
References: <20200810151809.438685785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit 7fcd9bb5acd01250bcae1ecc0cb8b8d4bb5b7e63 ]

When the ASoC card registration fails and the codec component driver
never probes, the codec device is not initialized and therefore
memory for codec->wcaps is not allocated. This results in a NULL pointer
dereference when the codec driver suspend callback is invoked during
system suspend. Fix this by returning without performing any actions
during codec suspend/resume if the card was not registered successfully.

Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20200728231011.1454066-1-ranjani.sridharan@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_codec.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 07c03c32715a9..801abf0fc98b3 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -2924,6 +2924,10 @@ static int hda_codec_runtime_suspend(struct device *dev)
 	struct hda_codec *codec = dev_to_hda_codec(dev);
 	unsigned int state;
 
+	/* Nothing to do if card registration fails and the component driver never probes */
+	if (!codec->card)
+		return 0;
+
 	cancel_delayed_work_sync(&codec->jackpoll_work);
 	state = hda_call_codec_suspend(codec);
 	if (codec->link_down_at_suspend ||
@@ -2938,6 +2942,10 @@ static int hda_codec_runtime_resume(struct device *dev)
 {
 	struct hda_codec *codec = dev_to_hda_codec(dev);
 
+	/* Nothing to do if card registration fails and the component driver never probes */
+	if (!codec->card)
+		return 0;
+
 	codec_display_power(codec, true);
 	snd_hdac_codec_link_up(&codec->core);
 	hda_call_codec_resume(codec);
-- 
2.25.1



