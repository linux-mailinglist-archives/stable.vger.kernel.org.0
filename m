Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596C5353DAF
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237351AbhDEJCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:02:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237182AbhDEJB3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:01:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 388DD613A3;
        Mon,  5 Apr 2021 09:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613267;
        bh=H8VK9c4QfGqrxZeHrXB88VlBEU6W2MuiAA/+LW4Iomg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SiWpz3DxwIWCYB8NpAkXB0u9tK94iR9blbgIG53YKykWXwqY8OWYNvSoUS1Le2XEJ
         1Kf5U74LOFu8wrpvMpwssdBOidLhXzATH85ZRDXKYX7t/vGwUf64eIfCz6pV3zzUyW
         jEVO3CsHZ78vKTmrfCA3v6amFHvoWf+iBY7CIljA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/56] ASoC: es8316: Simplify adc_pga_gain_tlv table
Date:   Mon,  5 Apr 2021 10:53:40 +0200
Message-Id: <20210405085022.850989223@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085022.562176619@linuxfoundation.org>
References: <20210405085022.562176619@linuxfoundation.org>
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
index 9ebe77c3784a..57130edaf3ab 100644
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



