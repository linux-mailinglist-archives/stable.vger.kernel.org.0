Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4BAFEA0B6
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 17:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbfJ3PvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:51:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726691AbfJ3PvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:51:10 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4638208C0;
        Wed, 30 Oct 2019 15:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450670;
        bh=tCu4UpkpbyeBzVGi3Tlm180a+mIntA+FBp6LDTqaeD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f7QtHIYrZ1w0eXlPInI7txAtRFre/f6I4sVvx74UDYZwCF8jfT2kCGJDQQjdmiUe8
         ug2vaqx3L8s9Nyyf89oO0LPB6dERZh/czNnl4R2igjvpL2LDertiSThADgrtViaXfj
         kT6NFm7hW4zlmhT0xFVWuHHB/m00xh/KLvBbP47s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaska Uimonen <jaska.uimonen@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 19/81] ASoC: intel: bytcr_rt5651: add null check to support_button_press
Date:   Wed, 30 Oct 2019 11:48:25 -0400
Message-Id: <20191030154928.9432-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaska Uimonen <jaska.uimonen@intel.com>

[ Upstream commit 2bdf194e2030fce4f2e91300817338353414ab3b ]

When removing sof module the support_button_press function will oops
because hp_jack pointer is not checked for NULL. So add a check to fix
this.

Signed-off-by: Jaska Uimonen <jaska.uimonen@intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20190927201408.925-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5651.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/rt5651.c b/sound/soc/codecs/rt5651.c
index 762595de956c1..c506c9305043e 100644
--- a/sound/soc/codecs/rt5651.c
+++ b/sound/soc/codecs/rt5651.c
@@ -1770,6 +1770,9 @@ static int rt5651_detect_headset(struct snd_soc_component *component)
 
 static bool rt5651_support_button_press(struct rt5651_priv *rt5651)
 {
+	if (!rt5651->hp_jack)
+		return false;
+
 	/* Button press support only works with internal jack-detection */
 	return (rt5651->hp_jack->status & SND_JACK_MICROPHONE) &&
 		rt5651->gpiod_hp_det == NULL;
-- 
2.20.1

