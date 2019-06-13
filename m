Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5EF7440A5
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfFMQIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:08:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731293AbfFMIpQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:45:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FC5020851;
        Thu, 13 Jun 2019 08:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415515;
        bh=RyQfi8PifalqsZTXPrVVALQ1aLa+4Pwc5y07uBkObAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i+8S2E0Gr+a5W6xQ7ZEqFhD+poyJgE4wLMHm8cNdje6O0Alg36uGzudKMHzqqemZt
         EFEEhgptgRqbLpUjZ2OgE6aPKRx7iNTBTMH+xQd2CtHuDBmPMPD6UtZdZNySLALsDy
         g6SExICAZkt9b0UtU2glfJn2pOhPKA4RcTaefKf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 029/155] drm/nouveau/disp/dp: respect sink limits when selecting failsafe link configuration
Date:   Thu, 13 Jun 2019 10:32:21 +0200
Message-Id: <20190613075654.544378169@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
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
index 5f301e632599..818d21bd28d3 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c
@@ -365,8 +365,15 @@ nvkm_dp_train(struct nvkm_dp *dp, u32 dataKBps)
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



