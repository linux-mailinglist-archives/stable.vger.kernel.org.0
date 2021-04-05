Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4D2353D37
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233749AbhDEI7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:59:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234246AbhDEI67 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:58:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5BE661394;
        Mon,  5 Apr 2021 08:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613133;
        bh=FYgPAvocIRQywXGu4UeZ45yb+UK+2LKhv8hfMFDGmz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLm+MTqDdHWgG7/S18lQukD6NPkhlarv5UZTaF4DSGFqHJeQ6rdv+c7X1BYY6kVY0
         qE4F+8QP+B2OvMCweMs3jWm+b9hmYt3U8cVzQIM6402BSHnf7mZ0GubuxAf4cEm0Vj
         aLvEN4kXIt1OSJrPuuJl0ec5/MaNFLPxP6OXFOYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 08/52] ASoC: es8316: Simplify adc_pga_gain_tlv table
Date:   Mon,  5 Apr 2021 10:53:34 +0200
Message-Id: <20210405085022.276815613@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085021.996963957@linuxfoundation.org>
References: <20210405085021.996963957@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit bb18c678754ce1514100fb4c0bf6113b5af36c48 ]

Most steps in this table are steps of 3dB (300 centi-dB), so we can
simplify the table.

This not only reduces the amount of space it takes inside the kernel,
this also makes alsa-lib's mixer code actually accept the table, where
as before this change alsa-lib saw the "ADC PGA Gain" control as a
control without a dB scale.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210228160441.241110-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8316.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/es8316.c b/sound/soc/codecs/es8316.c
index 949dbdc0445e..0410f2e5183c 100644
--- a/sound/soc/codecs/es8316.c
+++ b/sound/soc/codecs/es8316.c
@@ -56,13 +56,8 @@ static const SNDRV_CTL_TLVD_DECLARE_DB_RANGE(adc_pga_gain_tlv,
 	1, 1, TLV_DB_SCALE_ITEM(0, 0, 0),
 	2, 2, TLV_DB_SCALE_ITEM(250, 0, 0),
 	3, 3, TLV_DB_SCALE_ITEM(450, 0, 0),
-	4, 4, TLV_DB_SCALE_ITEM(700, 0, 0),
-	5, 5, TLV_DB_SCALE_ITEM(1000, 0, 0),
-	6, 6, TLV_DB_SCALE_ITEM(1300, 0, 0),
-	7, 7, TLV_DB_SCALE_ITEM(1600, 0, 0),
-	8, 8, TLV_DB_SCALE_ITEM(1800, 0, 0),
-	9, 9, TLV_DB_SCALE_ITEM(2100, 0, 0),
-	10, 10, TLV_DB_SCALE_ITEM(2400, 0, 0),
+	4, 7, TLV_DB_SCALE_ITEM(700, 300, 0),
+	8, 10, TLV_DB_SCALE_ITEM(1800, 300, 0),
 );
 
 static const SNDRV_CTL_TLVD_DECLARE_DB_RANGE(hpout_vol_tlv,
-- 
2.30.1



