Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 282E914DBD
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbfEFOqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:46:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728600AbfEFOqK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:46:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14D792053B;
        Mon,  6 May 2019 14:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153969;
        bh=4fNEhUpTSk6ioQrT4WYstrl6DKNkYCRJBUW7GwlqANI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCMt0gX4nkBRa10jFbiRBYFGrVyMV0By/QLZuOIDIQDAW3+imGjrYTsrc71bqVRXU
         vPZAkZMx+aM9CLPjbNjH9c8ZMSZpX/S/Qzav2azvsqu4T+NLpPBM5FT3pNI4jegx/u
         seswzdqFzElIAsLadVe9YXQUtTP2M8prZ860jIb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.14 64/75] ASoC: stm32: fix sai driver name initialisation
Date:   Mon,  6 May 2019 16:33:12 +0200
Message-Id: <20190506143059.065468428@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.287515952@linuxfoundation.org>
References: <20190506143053.287515952@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaud Pouliquen <arnaud.pouliquen@st.com>

commit 17d3069ccf06970e2db3f7cbf4335f207524279e upstream.

This patch fixes the sai driver structure overwriting which results in
a cpu dai name equal NULL.

Fixes: 3e086ed ("ASoC: stm32: add SAI driver")

Signed-off-by: Arnaud Pouliquen <arnaud.pouliquen@st.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/stm/stm32_sai_sub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -873,7 +873,6 @@ static int stm32_sai_sub_dais_init(struc
 	if (!sai->cpu_dai_drv)
 		return -ENOMEM;
 
-	sai->cpu_dai_drv->name = dev_name(&pdev->dev);
 	if (STM_SAI_IS_PLAYBACK(sai)) {
 		memcpy(sai->cpu_dai_drv, &stm32_sai_playback_dai,
 		       sizeof(stm32_sai_playback_dai));
@@ -883,6 +882,7 @@ static int stm32_sai_sub_dais_init(struc
 		       sizeof(stm32_sai_capture_dai));
 		sai->cpu_dai_drv->capture.stream_name = sai->cpu_dai_drv->name;
 	}
+	sai->cpu_dai_drv->name = dev_name(&pdev->dev);
 
 	return 0;
 }


