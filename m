Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA041AEE1C
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgDROKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:10:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727906AbgDROKh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:10:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E07121D6C;
        Sat, 18 Apr 2020 14:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587219036;
        bh=TxGvwKirdzeH0HzqPaUcNdhQgOWVsAZkw7r9reHCr2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iYm6q5Iu4kLKtFBiWgK5bRAXcyGiFF18Fts59Kresfg+YwjIB1fF3PAJDNAuNX0DK
         htdqtyYl1wmZj77y08rACp4jMFy3I/MncrhS9AnM6ojvvbruCJ4db2CR7VuaDpOJNt
         f47gNXft1+kydGg1virsGyd5a/EHL+dkKzdnYxFA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        sound-open-firmware@alsa-project.org, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.5 70/75] ASoC: SOF: trace: fix unconditional free in trace release
Date:   Sat, 18 Apr 2020 10:09:05 -0400
Message-Id: <20200418140910.8280-70-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418140910.8280-1-sashal@kernel.org>
References: <20200418140910.8280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit e6110114d18d330c05fd6de9f31283fd086a5a3a ]

Check if DMA pages were successfully allocated in initialization
before calling free. For many types of memory (like sgbufs)
the extra free is harmless, but not all backends track allocation
state, so add an explicit check.

Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200124213625.30186-5-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/trace.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/trace.c b/sound/soc/sof/trace.c
index b0e4556c8536a..5bf63fa67fb09 100644
--- a/sound/soc/sof/trace.c
+++ b/sound/soc/sof/trace.c
@@ -343,7 +343,10 @@ void snd_sof_free_trace(struct snd_sof_dev *sdev)
 
 	snd_sof_release_trace(sdev);
 
-	snd_dma_free_pages(&sdev->dmatb);
-	snd_dma_free_pages(&sdev->dmatp);
+	if (sdev->dma_trace_pages) {
+		snd_dma_free_pages(&sdev->dmatb);
+		snd_dma_free_pages(&sdev->dmatp);
+		sdev->dma_trace_pages = 0;
+	}
 }
 EXPORT_SYMBOL(snd_sof_free_trace);
-- 
2.20.1

