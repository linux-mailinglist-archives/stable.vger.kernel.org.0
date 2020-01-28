Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49A7C14BB1A
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgA1OL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:11:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:60576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728230AbgA1OLZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:11:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55C0A24685;
        Tue, 28 Jan 2020 14:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220684;
        bh=3aQyFgPEAY1vmqYeYtAfg2xVoLGXpJTEIWhM2Kq7G/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IfjvL16MkiKNVbtA6QGuXMXVeNrb9dpCE9yujZ8NMVFuqEHBu3N+ghH23FDaBRM2f
         6VPVPgJY4IRKsPiWcluA7CG7+dcZb9kXm3snXwMVmwkCkjR5aBXmJPCkOhR7es3hH/
         zrApB6piZrXwW+K/i2qoLiXdOpcwUwMyJUYSevFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 104/183] ASoC: ti: davinci-mcasp: Fix slot mask settings when using multiple AXRs
Date:   Tue, 28 Jan 2020 15:05:23 +0100
Message-Id: <20200128135840.370880508@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2f7be6cee98e9..fc0a73227b023 100644
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



