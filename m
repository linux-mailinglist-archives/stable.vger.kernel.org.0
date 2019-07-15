Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E68E068D3A
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 15:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732931AbfGON45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:56:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732926AbfGON44 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:56:56 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C06620C01;
        Mon, 15 Jul 2019 13:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199015;
        bh=6JvuEJ2jZQoAtrlOQ/pl0yGKBrjDFLIlyVotuHAJdKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npakiStCQIDmrxpaMzK+TCuBBsy9axYl8FHNsQkp/32hMew+JWVwERaIa5dnFF7As
         47rxPtdNenIs8JuK/2Hun0DX32Ig/H4Dwfc1f0eOidcnmhp7FrHRDIV95X2ahSd1ea
         i8QAUNHzOLeaf+EeGHNicaqfRuXG1xdHF94TriW0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 166/249] ALSA: hdac: Fix codec name after machine driver is unloaded and reloaded
Date:   Mon, 15 Jul 2019 09:45:31 -0400
Message-Id: <20190715134655.4076-166-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 8a5b0177a7f6099ff534a4d9ce72673af5c3cade ]

Currently on each driver reload internal counter is being increased. It
causes failure to enumerate driver devices, as they have hardcoded:
.codec_name = "ehdaudio0D2",
As there is currently no devices with multiple hda codecs and there is
currently no established way to reliably differentiate, between them,
always assign bus->idx = 0;

This fixes a problem when we unload and reload machine driver idx gets
incremented, so .codec_name would've needed to be set to "ehdaudio1D2"
after first reload and so on.

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Acked-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/ext/hdac_ext_bus.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/hda/ext/hdac_ext_bus.c b/sound/hda/ext/hdac_ext_bus.c
index a3a113ef5d56..4f9f1d2a2ec5 100644
--- a/sound/hda/ext/hdac_ext_bus.c
+++ b/sound/hda/ext/hdac_ext_bus.c
@@ -85,7 +85,6 @@ int snd_hdac_ext_bus_init(struct hdac_bus *bus, struct device *dev,
 			const struct hdac_ext_bus_ops *ext_ops)
 {
 	int ret;
-	static int idx;
 
 	/* check if io ops are provided, if not load the defaults */
 	if (io_ops == NULL)
@@ -96,7 +95,12 @@ int snd_hdac_ext_bus_init(struct hdac_bus *bus, struct device *dev,
 		return ret;
 
 	bus->ext_ops = ext_ops;
-	bus->idx = idx++;
+	/* FIXME:
+	 * Currently only one bus is supported, if there is device with more
+	 * buses, bus->idx should be greater than 0, but there needs to be a
+	 * reliable way to always assign same number.
+	 */
+	bus->idx = 0;
 	bus->cmd_dma_state = true;
 
 	return 0;
-- 
2.20.1

