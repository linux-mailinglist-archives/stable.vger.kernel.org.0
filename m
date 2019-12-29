Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0931212C7C6
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731067AbfL2RqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:46:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:56124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731063AbfL2RqY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:46:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AE8C206DB;
        Sun, 29 Dec 2019 17:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641583;
        bh=DXF7o8ExpQHb1qVoGDDq9vcyp1WYD4pNzRMkR6MRaOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HfkHhj7uLpEQZE9cX9y0P8uTzE7K+909E7Z7paUrse02loMe4jFVdq8Agb2f5x0XG
         cr46VEe9yDtYOpK7brrUXU5M9sINeuKa3wfyMOTFxvQUXggSKSQE6jgE5nA3tjhKxl
         v0kROcr3IhTQOMJVGaEvupYlCx2MbL7dZOS2Ygn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 126/434] ASoC: SOF: enable sync_write in hdac_bus
Date:   Sun, 29 Dec 2019 18:22:59 +0100
Message-Id: <20191229172710.067867230@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit f3416e7144f5d4ba0fc5dcef6ebfff891266c46a ]

Align SOF HDA implementation with snd-hda-intel driver and enable
sync_write flag for all supported Intel platforms in SOF. When set,
a sync is issued after each verb write.

Sync after write has helped to overcome intermittent delays in
system resume flow on Intel Coffee Lake systems, and most recently
probe errors related to the HDMI codec on Ice Lake systems.

Matches the snd-hda-intel driver change done in commit 2756d9143aa5
("ALSA: hda - Fix intermittent CORB/RIRB stall on Intel chips").

Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20191008164443.1358-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index 06e84679087b..5a5163eef2ef 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -268,6 +268,7 @@ static int hda_init(struct snd_sof_dev *sdev)
 
 	bus->use_posbuf = 1;
 	bus->bdl_pos_adj = 0;
+	bus->sync_write = 1;
 
 	mutex_init(&hbus->prepare_mutex);
 	hbus->pci = pci;
-- 
2.20.1



