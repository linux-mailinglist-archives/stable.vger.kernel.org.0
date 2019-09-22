Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4D0ABAB6C
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404494AbfIVTin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:38:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389154AbfIVSpV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:45:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AF4C21907;
        Sun, 22 Sep 2019 18:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569177921;
        bh=IW9B/HeSgNw2BYZ4ZZx2Ue6CPKz5wPi/K6VoRd80Rnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TZYyrPPlWvcy1QULguYW7UkZdwARt0iJiDep9MmC4sNnc9/yycF0NVu7xwPCNgGhJ
         svZ7ReAGU2sBCu8jCf5UDeo5yLxCXfvEazWRK9utt11gK9jF3rVaPAX81LkhiGqkQ1
         xbaidI6wRBkdSaZ9efrYmrzkjleAzcWxsolyp8fM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 033/203] ALSA: i2c: ak4xxx-adda: Fix a possible null pointer dereference in build_adc_controls()
Date:   Sun, 22 Sep 2019 14:40:59 -0400
Message-Id: <20190922184350.30563-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 2127c01b7f63b06a21559f56a8c81a3c6535bd1a ]

In build_adc_controls(), there is an if statement on line 773 to check
whether ak->adc_info is NULL:
    if (! ak->adc_info ||
        ! ak->adc_info[mixer_ch].switch_name)

When ak->adc_info is NULL, it is used on line 792:
    knew.name = ak->adc_info[mixer_ch].selector_name;

Thus, a possible null-pointer dereference may occur.

To fix this bug, referring to lines 773 and 774, ak->adc_info
and ak->adc_info[mixer_ch].selector_name are checked before being used.

This bug is found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/i2c/other/ak4xxx-adda.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/i2c/other/ak4xxx-adda.c b/sound/i2c/other/ak4xxx-adda.c
index 5f59316f982ae..7d15093844b92 100644
--- a/sound/i2c/other/ak4xxx-adda.c
+++ b/sound/i2c/other/ak4xxx-adda.c
@@ -775,11 +775,12 @@ static int build_adc_controls(struct snd_akm4xxx *ak)
 				return err;
 
 			memset(&knew, 0, sizeof(knew));
-			knew.name = ak->adc_info[mixer_ch].selector_name;
-			if (!knew.name) {
+			if (!ak->adc_info ||
+				!ak->adc_info[mixer_ch].selector_name) {
 				knew.name = "Capture Channel";
 				knew.index = mixer_ch + ak->idx_offset * 2;
-			}
+			} else
+				knew.name = ak->adc_info[mixer_ch].selector_name;
 
 			knew.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
 			knew.info = ak4xxx_capture_source_info;
-- 
2.20.1

