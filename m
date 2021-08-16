Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59ABA3ED593
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238852AbhHPNMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:12:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238609AbhHPNHq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:07:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00CCF6329B;
        Mon, 16 Aug 2021 13:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119214;
        bh=9xYWXLy5eqswbbVVDGKdKmia3sEo3pev6hYkG3bAWP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lfMF7O7AGQP4QG+zGYgC8ToAyRFTWDdngiIZ8gbxvbvoA30Agl4SQc058w89ogUHH
         SkgqELxeideDJZ+sWd7PeoXM8xAX7nlEraW/30ekcWMJLL0m7re0l5cRuSDHUUSxRh
         kXWNa3pVnxH6hddiIgnDZO6N+ztzaOpOyYxCFwzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 08/96] ASoC: tlv320aic31xx: Fix jack detection after suspend
Date:   Mon, 16 Aug 2021 15:01:18 +0200
Message-Id: <20210816125435.209378501@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

commit 2c39ca6885a2ec03e5c9e7c12a4da2aa8926605a upstream.

The tlv320aic31xx driver relies on regcache_sync() to restore the register
contents after going to _BIAS_OFF, for example during system suspend. This
does not work for the jack detection configuration since that is configured
via the same register that status is read back from so the register is
volatile and not cached. This can also cause issues during init if the jack
detection ends up getting set up before the CODEC is initially brought out
of _BIAS_OFF, we will reset the CODEC and resync the cache as part of that
process.

Fix this by explicitly reapplying the jack detection configuration after
resyncing the register cache during power on.

This issue was found by an engineer working off-list on a product
kernel, I just wrote up the upstream fix.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20210723180200.25105-1-broonie@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/tlv320aic31xx.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/sound/soc/codecs/tlv320aic31xx.c
+++ b/sound/soc/codecs/tlv320aic31xx.c
@@ -35,6 +35,9 @@
 
 #include "tlv320aic31xx.h"
 
+static int aic31xx_set_jack(struct snd_soc_component *component,
+                            struct snd_soc_jack *jack, void *data);
+
 static const struct reg_default aic31xx_reg_defaults[] = {
 	{ AIC31XX_CLKMUX, 0x00 },
 	{ AIC31XX_PLLPR, 0x11 },
@@ -1256,6 +1259,13 @@ static int aic31xx_power_on(struct snd_s
 		return ret;
 	}
 
+	/*
+	 * The jack detection configuration is in the same register
+	 * that is used to report jack detect status so is volatile
+	 * and not covered by the cache sync, restore it separately.
+	 */
+	aic31xx_set_jack(component, aic31xx->jack, NULL);
+
 	return 0;
 }
 


