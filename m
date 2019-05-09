Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F129191E8
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbfEISuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:50:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728347AbfEISuE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:50:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C91A62183F;
        Thu,  9 May 2019 18:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427803;
        bh=+VAxYx/TALkJjCkfL9vJ1pG5USI8ruLBbQXUkwice94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+u7hi5Him76PeJhb7HVEx1g5bUqMVpOHWc3u60zQ/5Cs9Wyt9Aac1q5AfpyxflHS
         kwuo+FKnP4QFsnmp7bpO1arCZ85W5DTObgQDFJZYbSi9N6x+8Zu+q5Pt2t4N7qxLVO
         9lA3hYCwPTAWxrpGV6whDfYAxZpYuMXlc5uqKDtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olivier Moysan <olivier.moysan@st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 10/95] ASoC: stm32: sai: fix iec958 controls indexation
Date:   Thu,  9 May 2019 20:41:27 +0200
Message-Id: <20190509181310.067277539@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5f8a1000c3e630c3ac06f1d664eeaa755bce8823 ]

Allow indexation of sai iec958 controls according
to device id.

Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_sai_sub.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/soc/stm/stm32_sai_sub.c b/sound/soc/stm/stm32_sai_sub.c
index 29a131e0569e7..aaacec5b442df 100644
--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -100,7 +100,7 @@
  * @slot_mask: rx or tx active slots mask. set at init or at runtime
  * @data_size: PCM data width. corresponds to PCM substream width.
  * @spdif_frm_cnt: S/PDIF playback frame counter
- * @snd_aes_iec958: iec958 data
+ * @iec958: iec958 data
  * @ctrl_lock: control lock
  */
 struct stm32_sai_sub_data {
@@ -1070,11 +1070,12 @@ static int stm32_sai_pcm_new(struct snd_soc_pcm_runtime *rtd,
 			     struct snd_soc_dai *cpu_dai)
 {
 	struct stm32_sai_sub_data *sai = dev_get_drvdata(cpu_dai->dev);
+	struct snd_kcontrol_new knew = iec958_ctls;
 
 	if (STM_SAI_PROTOCOL_IS_SPDIF(sai)) {
 		dev_dbg(&sai->pdev->dev, "%s: register iec controls", __func__);
-		return snd_ctl_add(rtd->pcm->card,
-				   snd_ctl_new1(&iec958_ctls, sai));
+		knew.device = rtd->pcm->device;
+		return snd_ctl_add(rtd->pcm->card, snd_ctl_new1(&knew, sai));
 	}
 
 	return 0;
-- 
2.20.1



