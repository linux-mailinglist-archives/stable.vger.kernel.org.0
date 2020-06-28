Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A710120C8BB
	for <lists+stable@lfdr.de>; Sun, 28 Jun 2020 17:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgF1Pjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jun 2020 11:39:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25198 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725970AbgF1Pjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Jun 2020 11:39:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593358782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/T+n/WMSXGYQh59L/TuX8qKl/A0OCCf7D9e+yxcaST8=;
        b=Jyffb/+xfGDNkSrezdz2ETCEFNPhhTSNjM52+Ngr/NS5HxVg24SvFaxAE57nCSZSDNWNw6
        hURcgrNvQVcm9YPo0f7PAV1IdFcAC+15pnTKNKY4+Q7bXAYci/xFItdVNjhbBBBpAX2I8y
        kmiWW1jsMRFOfD+mdnwopL52UkCOYd4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-4ukXpm18Mj6zIPXoXD6WzA-1; Sun, 28 Jun 2020 11:39:40 -0400
X-MC-Unique: 4ukXpm18Mj6zIPXoXD6WzA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2EEA080400C;
        Sun, 28 Jun 2020 15:39:39 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-112-41.ams2.redhat.com [10.36.112.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F252289B5;
        Sun, 28 Jun 2020 15:39:37 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Jie Yang <yang.jie@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Oder Chiou <oder_chiou@realtek.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, alsa-devel@alsa-project.org,
        stable@vger.kernel.org
Subject: [PATCH 2/6] ASoC: rt5670: Correct RT5670_LDO_SEL_MASK
Date:   Sun, 28 Jun 2020 17:39:29 +0200
Message-Id: <20200628153933.70538-2-hdegoede@redhat.com>
In-Reply-To: <20200628153933.70538-1-hdegoede@redhat.com>
References: <20200628153933.70538-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The RT5670_PWR_ANLG1 register has 3 bits to select the LDO voltage,
so the correct mask is 0x7 not 0x3.

Because of this wrong mask we were programming the ldo bits
to a setting of binary 001 (0x05 & 0x03) instead of binary 101
when moving to SND_SOC_BIAS_PREPARE.

According to the datasheet 001 is a reserved value, so no idea
what it did, since the driver was working fine before I guess we
got lucky and it does something which is ok.

Fixes: 5e8351de740d ("ASoC: add RT5670 CODEC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 sound/soc/codecs/rt5670.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt5670.h b/sound/soc/codecs/rt5670.h
index a8c3e44770b8..de0203369b7c 100644
--- a/sound/soc/codecs/rt5670.h
+++ b/sound/soc/codecs/rt5670.h
@@ -757,7 +757,7 @@
 #define RT5670_PWR_VREF2_BIT			4
 #define RT5670_PWR_FV2				(0x1 << 3)
 #define RT5670_PWR_FV2_BIT			3
-#define RT5670_LDO_SEL_MASK			(0x3)
+#define RT5670_LDO_SEL_MASK			(0x7)
 #define RT5670_LDO_SEL_SFT			0
 
 /* Power Management for Analog 2 (0x64) */
-- 
2.26.2

