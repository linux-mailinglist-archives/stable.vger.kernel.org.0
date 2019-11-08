Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF80CF55D1
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390097AbfKHTE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:04:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:34988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732512AbfKHTE4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:04:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1EF9218AE;
        Fri,  8 Nov 2019 19:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239895;
        bh=tCu4UpkpbyeBzVGi3Tlm180a+mIntA+FBp6LDTqaeD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rya1hkL2x/fzikFDZYpnzT0MD/xh6IOG1HSnGNOnyfk+J0EQF2IugQ1myJ/04iY9x
         4erIOu6ly7FUjYR8SOIRzzi6F5sIgxgP0ROotvnVyUkn0YTnI3WQC8sPZgKhWXcU9b
         iLVbseAr/d9Qrei1TDTCXw00VOVtbslWX0Z+NKQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaska Uimonen <jaska.uimonen@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 019/140] ASoC: intel: bytcr_rt5651: add null check to support_button_press
Date:   Fri,  8 Nov 2019 19:49:07 +0100
Message-Id: <20191108174903.875052819@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



