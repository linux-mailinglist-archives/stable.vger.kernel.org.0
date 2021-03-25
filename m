Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3466E348FFE
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhCYLbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:31:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231387AbhCYL3W (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:29:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B6F961A33;
        Thu, 25 Mar 2021 11:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671650;
        bh=qlNPSD0v2axzEzc7mYlfNmvnClomzy38BEjQdUlMqXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f1YCYwGk7g+e3ognEgjYUm6xJcLHz70/9ohd/O5YByRB1KxhgL274B4yAdeZuktOW
         XPA6i/hO/+uT0g4cRT1zxMlsC9T8rXs5nC6eySSu7bczuczH1DvNRuLDr9IdwLq7u8
         bzC+F00V7Go6aPZJmuMSXz/UaP6z3fIhdhpNoCmmknwpXoqvOIGpzqvuPy62FnyVtU
         2bJeD+BGGIaTa7K1HILutqBdTONsJGABCR86ubR0apScoBh6OqmAMCWsSivTSqYHQt
         wYsExJJzTUULzMAMvdHgb2oqnE3lolwN0bORMvbiV6ImQ6fyI7fBKA574EEytqBF6+
         MWSFrRALFGYjg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.19 04/20] ASoC: rt5651: Fix dac- and adc- vol-tlv values being off by a factor of 10
Date:   Thu, 25 Mar 2021 07:27:08 -0400
Message-Id: <20210325112724.1928174-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112724.1928174-1-sashal@kernel.org>
References: <20210325112724.1928174-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit eee51df776bd6cac10a76b2779a9fdee3f622b2b ]

The adc_vol_tlv volume-control has a range from -17.625 dB to +30 dB,
not -176.25 dB to + 300 dB. This wrong scale is esp. a problem in userspace
apps which translate the dB scale to a linear scale. With the logarithmic
dB scale being of by a factor of 10 we loose all precision in the lower
area of the range when apps translate things to a linear scale.

E.g. the 0 dB default, which corresponds with a value of 47 of the
0 - 127 range for the control, would be shown as 0/100 in alsa-mixer.

Since the centi-dB values used in the TLV struct cannot represent the
0.375 dB step size used by these controls, change the TLV definition
for them to specify a min and max value instead of min + stepsize.

Note this mirrors commit 3f31f7d9b540 ("ASoC: rt5670: Fix dac- and adc-
vol-tlv values being off by a factor of 10") which made the exact same
change to the rt5670 codec driver.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210226143817.84287-3-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5651.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5651.c b/sound/soc/codecs/rt5651.c
index 985852fd9723..318a4c9b380f 100644
--- a/sound/soc/codecs/rt5651.c
+++ b/sound/soc/codecs/rt5651.c
@@ -288,9 +288,9 @@ static bool rt5651_readable_register(struct device *dev, unsigned int reg)
 }
 
 static const DECLARE_TLV_DB_SCALE(out_vol_tlv, -4650, 150, 0);
-static const DECLARE_TLV_DB_SCALE(dac_vol_tlv, -65625, 375, 0);
+static const DECLARE_TLV_DB_MINMAX(dac_vol_tlv, -6562, 0);
 static const DECLARE_TLV_DB_SCALE(in_vol_tlv, -3450, 150, 0);
-static const DECLARE_TLV_DB_SCALE(adc_vol_tlv, -17625, 375, 0);
+static const DECLARE_TLV_DB_MINMAX(adc_vol_tlv, -1762, 3000);
 static const DECLARE_TLV_DB_SCALE(adc_bst_tlv, 0, 1200, 0);
 
 /* {0, +20, +24, +30, +35, +40, +44, +50, +52} dB */
-- 
2.30.1

