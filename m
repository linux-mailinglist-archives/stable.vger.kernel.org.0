Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87B5E14503D
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388133AbgAVJpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:45:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730717AbgAVJpB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:45:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DB4C2468B;
        Wed, 22 Jan 2020 09:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686300;
        bh=GYw1/+TmNY94s3zMTDGdLysrUmfCzwKhAPzuaj5rd5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TW3rpg0boSiNdFlSBU8xz5nkKtENXZUqFcfcjBnzA2owe7IMH2MBPhGffKYsOhAja
         XSl/hy+0rUCMKddPdRfaijrY4SFU1zctsIRbv/aw1fRkuMW/Zd4jid+Nc+J2onvQYq
         3BvMPwXfFAsWJBjKeM6aTzkYNoTIFpQhyiKFOygU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, russianneuromancer@ya.ru,
        Hans de Goede <hdegoede@redhat.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 021/222] ASoC: Intel: bytcht_es8316: Fix Irbis NB41 netbook quirk
Date:   Wed, 22 Jan 2020 10:26:47 +0100
Message-Id: <20200122092834.924493921@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 869bced7a055665e3ddb1ba671a441ce6f997bf1 upstream.

When a quirk for the Irbis NB41 netbook was added, to override the defaults
for this device, I forgot to add/keep the BYT_CHT_ES8316_SSP0 part of the
defaults, completely breaking audio on this netbook.

This commit adds the BYT_CHT_ES8316_SSP0 flag to the Irbis NB41 netbook
quirk, making audio work again.

Cc: stable@vger.kernel.org
Cc: russianneuromancer@ya.ru
Fixes: aa2ba991c420 ("ASoC: Intel: bytcht_es8316: Add quirk for Irbis NB41 netbook")
Reported-and-tested-by: russianneuromancer@ya.ru
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20200106113903.279394-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/intel/boards/bytcht_es8316.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/intel/boards/bytcht_es8316.c
+++ b/sound/soc/intel/boards/bytcht_es8316.c
@@ -442,7 +442,8 @@ static const struct dmi_system_id byt_ch
 			DMI_MATCH(DMI_SYS_VENDOR, "IRBIS"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "NB41"),
 		},
-		.driver_data = (void *)(BYT_CHT_ES8316_INTMIC_IN2_MAP
+		.driver_data = (void *)(BYT_CHT_ES8316_SSP0
+					| BYT_CHT_ES8316_INTMIC_IN2_MAP
 					| BYT_CHT_ES8316_JD_INVERTED),
 	},
 	{	/* Teclast X98 Plus II */


