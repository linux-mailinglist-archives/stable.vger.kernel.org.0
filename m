Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E43BCAA27
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388949AbfJCQUU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:20:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388650AbfJCQUT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:20:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 034A9215EA;
        Thu,  3 Oct 2019 16:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119618;
        bh=fLXXfy+8DeSWD+W67ibSeRkxDybWu5Ovr0GanZ2/0q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GdSdZcWr61nFHw6zbUi2lQIr/xgLALYVaisaww+k7aXo+MJsFydDBWYdY23+kCxrk
         BufK8hS2LyN1pT5u7mF/U3RP1hA9ZmLp/osr0gZunmHj4v2AQfvzIZIn9Sh9gOGrk5
         Jk8Q3BMX57rwbHQKlL66lH40iAuBJygIzTC0NFS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Arthur She <arthur.she@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 131/211] ASoC: dmaengine: Make the pcm->name equal to pcm->id if the name is not set
Date:   Thu,  3 Oct 2019 17:53:17 +0200
Message-Id: <20191003154516.761460881@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

[ Upstream commit 2ec42f3147e1610716f184b02e65d7f493eed925 ]

Some tools use the snd_pcm_info_get_name() to try to identify PCMs or for
other purposes.

Currently it is left empty with the dmaengine-pcm, in this case copy the
pcm->id string as pcm->name.

For example IGT is using this to find the HDMI PCM for testing audio on it.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Reported-by: Arthur She <arthur.she@linaro.org>
Link: https://lore.kernel.org/r/20190906055524.7393-1-peter.ujfalusi@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-generic-dmaengine-pcm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/soc/soc-generic-dmaengine-pcm.c b/sound/soc/soc-generic-dmaengine-pcm.c
index 30e791a533528..232df04ca5866 100644
--- a/sound/soc/soc-generic-dmaengine-pcm.c
+++ b/sound/soc/soc-generic-dmaengine-pcm.c
@@ -313,6 +313,12 @@ static int dmaengine_pcm_new(struct snd_soc_pcm_runtime *rtd)
 
 		if (!dmaengine_pcm_can_report_residue(dev, pcm->chan[i]))
 			pcm->flags |= SND_DMAENGINE_PCM_FLAG_NO_RESIDUE;
+
+		if (rtd->pcm->streams[i].pcm->name[0] == '\0') {
+			strncpy(rtd->pcm->streams[i].pcm->name,
+				rtd->pcm->streams[i].pcm->id,
+				sizeof(rtd->pcm->streams[i].pcm->name));
+		}
 	}
 
 	return 0;
-- 
2.20.1



