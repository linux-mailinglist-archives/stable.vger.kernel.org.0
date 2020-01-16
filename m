Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21A3F13EAA5
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406151AbgAPRpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:45:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:36842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406144AbgAPRpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:45:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22BEB2476E;
        Thu, 16 Jan 2020 17:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196715;
        bh=Om9OS8yeIJC84xn8fWXWK4tzn/MLFB3gRUoN6Kp1y1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YTg7BDYfXFemzSGdoe8K2C6Iyd2MY1bc1V37PnUo13gLtY0URH5o4tWCaRJzasq9Z
         m87ZFMePAdL9k3v5mNMENEwuzvTSyC2lrMATV6MbYJpr0mptNG6O1xy064vNKHbzR2
         OHJys3yoxuFnTO5vOv576g/m7OUvj+1d8HctP61g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 4.4 103/174] ASoC: ti: davinci-mcasp: Fix slot mask settings when using multiple AXRs
Date:   Thu, 16 Jan 2020 12:41:40 -0500
Message-Id: <20200116174251.24326-103-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit fd14f4436fd47d5418023c90e933e66d3645552e ]

If multiple serializers are connected in the system and the number of
channels will need to use more than one serializer the mask to enable the
serializers were left to 0 if tdm_mask is provided

Fixes: dd55ff8346a97 ("ASoC: davinci-mcasp: Add set_tdm_slots() support")

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/davinci/davinci-mcasp.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/sound/soc/davinci/davinci-mcasp.c b/sound/soc/davinci/davinci-mcasp.c
index 2f7be6cee98e..fc0a73227b02 100644
--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -875,14 +875,13 @@ static int mcasp_i2s_hw_param(struct davinci_mcasp *mcasp, int stream,
 		active_slots = hweight32(mcasp->tdm_mask[stream]);
 		active_serializers = (channels + active_slots - 1) /
 			active_slots;
-		if (active_serializers == 1) {
+		if (active_serializers == 1)
 			active_slots = channels;
-			for (i = 0; i < total_slots; i++) {
-				if ((1 << i) & mcasp->tdm_mask[stream]) {
-					mask |= (1 << i);
-					if (--active_slots <= 0)
-						break;
-				}
+		for (i = 0; i < total_slots; i++) {
+			if ((1 << i) & mcasp->tdm_mask[stream]) {
+				mask |= (1 << i);
+				if (--active_slots <= 0)
+					break;
 			}
 		}
 	} else {
-- 
2.20.1

