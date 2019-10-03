Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3B73CA4A2
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391133AbfJCQ0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:26:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391130AbfJCQ0r (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:26:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5068121783;
        Thu,  3 Oct 2019 16:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120006;
        bh=IW9B/HeSgNw2BYZ4ZZx2Ue6CPKz5wPi/K6VoRd80Rnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBfakHuA/ggr4yROi4ABIk7xXNMEaCvS1KdpGUJ7f4NdApIRBeFS0SU1ebqYHYT/l
         T4EkTO2nGDEW6Nz1BBgQKozA5ojBw9GGLuLW2YsGEC//gKjNmsoORbcJ8UT4I3c3sv
         gGDtGIM6cUQhtdZ05RZe7MyoPmYOIxRGV56zfGVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 062/313] ALSA: i2c: ak4xxx-adda: Fix a possible null pointer dereference in build_adc_controls()
Date:   Thu,  3 Oct 2019 17:50:40 +0200
Message-Id: <20191003154539.088797687@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



