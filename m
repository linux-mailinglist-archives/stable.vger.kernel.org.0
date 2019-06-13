Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFE6442E6
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731200AbfFMQ0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:26:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730964AbfFMIgS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:36:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68D652146F;
        Thu, 13 Jun 2019 08:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560414977;
        bh=YCT7ioCTMlfSNqJdXxS/UUxBZzG++8zttWVLIz3vY/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LlNOZSS0xV1+nCkp/7dWSUv2gGBA9NFbIdHnIG6GsyjB/jvxKwY6yNgCjgy7fy4hK
         xv2h+yoTxbMmmw4LgOA2CablMg8bqkTZXx0itPw1ZlEJSV39fwMYoEVC7ooT4Y/ewh
         j45+V9erFA7NKlMEaJHl8GaTm9Az6RIaFToqRZp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 18/81] drm/nouveau/disp/dp: respect sink limits when selecting failsafe link configuration
Date:   Thu, 13 Jun 2019 10:33:01 +0200
Message-Id: <20190613075650.410787319@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075649.074682929@linuxfoundation.org>
References: <20190613075649.074682929@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 13d03e9daf70dab032c03dc172e75bb98ad899c4 ]

Where possible, we want the failsafe link configuration (one which won't
hang the OR during modeset because of not enough bandwidth for the mode)
to also be supported by the sink.

This prevents "link rate unsupported by sink" messages when link training
fails.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c b/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c
index 6160a6158cf2..5e51a5c1eb01 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c
@@ -364,8 +364,15 @@ nvkm_dp_train(struct nvkm_dp *dp, u32 dataKBps)
 	 * and it's better to have a failed modeset than that.
 	 */
 	for (cfg = nvkm_dp_rates; cfg->rate; cfg++) {
-		if (cfg->nr <= outp_nr && cfg->nr <= outp_bw)
-			failsafe = cfg;
+		if (cfg->nr <= outp_nr && cfg->nr <= outp_bw) {
+			/* Try to respect sink limits too when selecting
+			 * lowest link configuration.
+			 */
+			if (!failsafe ||
+			    (cfg->nr <= sink_nr && cfg->bw <= sink_bw))
+				failsafe = cfg;
+		}
+
 		if (failsafe && cfg[1].rate < dataKBps)
 			break;
 	}
-- 
2.20.1



