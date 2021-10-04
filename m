Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8797A420EBE
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237023AbhJDN1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:27:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236765AbhJDNZy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:25:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95F7361BFD;
        Mon,  4 Oct 2021 13:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353086;
        bh=HkzmHn7XQtDDUPx25hwrJ9mNGPveo/J5caG/OJrMG2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2qZXWcSXUauYkHSoAs3bYVo5tcFsLtOOIywTd3w6/DVpdhCyOshscxZqjvNI6m7x
         rJOLfwxQFHQQ4P6xErRYx8PQHcYsUhyfxLsOw9ToTS3dWWl+qjHkVRy6IHrVp9TYue
         /qyrbXS3zi8GlBVMCqg6ee+pE6YUlcqLTv/X8C7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@linux.intel.com>,
        Shuming Fan <shumingf@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Robert Lee <lerobert@google.com>
Subject: [PATCH 5.10 83/93] ASoC: dapm: use component prefix when checking widget names
Date:   Mon,  4 Oct 2021 14:53:21 +0200
Message-Id: <20211004125037.353769462@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuming Fan <shumingf@realtek.com>

commit ae4fc532244b3bb4d86c397418d980b0c6be1dfd upstream.

On a TigerLake SoundWire platform, we see these warnings:

[   27.360086] rt5682 sdw:0:25d:5682:0: ASoC: DAPM unknown pin MICBIAS
[   27.360092] rt5682 sdw:0:25d:5682:0: ASoC: DAPM unknown pin Vref2

This is root-caused to the addition of a component prefix in the
machine driver. The tests in soc-dapm should account for a prefix
instead of reporting an invalid issue.

Reported-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@linux.intel.com>
Signed-off-by: Shuming Fan <shumingf@realtek.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210208234043.59750-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Robert Lee <lerobert@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-dapm.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -2528,9 +2528,20 @@ static struct snd_soc_dapm_widget *dapm_
 {
 	struct snd_soc_dapm_widget *w;
 	struct snd_soc_dapm_widget *fallback = NULL;
+	char prefixed_pin[80];
+	const char *pin_name;
+	const char *prefix = soc_dapm_prefix(dapm);
+
+	if (prefix) {
+		snprintf(prefixed_pin, sizeof(prefixed_pin), "%s %s",
+			 prefix, pin);
+		pin_name = prefixed_pin;
+	} else {
+		pin_name = pin;
+	}
 
 	for_each_card_widgets(dapm->card, w) {
-		if (!strcmp(w->name, pin)) {
+		if (!strcmp(w->name, pin_name)) {
 			if (w->dapm == dapm)
 				return w;
 			else


