Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBD64F7EEE
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbfKKSh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:37:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:56190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728205AbfKKSh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:37:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91A7A204FD;
        Mon, 11 Nov 2019 18:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497448;
        bh=uxEvp3r+DUrdQpzFfJWDPNp1kudzxm5ipX/GdX8RGgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RqHurOv5/boyi3xdYZdYbi06i3f89cKibi0Jl/LUIVuL3iFyuQIxv7PaS9sq6xz4G
         J2VYYfSQFBksH5elsP31P6aSPQECbsVJJ0zg9cbAN5OkGBXgjETyqHo6KVhajAx7zn
         KDvpuHyvAbYSQQkIKQL7s2gzaFRjEfFG/sPuUplM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 4.14 058/105] ASoC: davinci-mcasp: Fix an error handling path in davinci_mcasp_probe()
Date:   Mon, 11 Nov 2019 19:28:28 +0100
Message-Id: <20191111181444.554038205@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>

commit 1b8b68b05d1868404316d32e20782b00442aba90 upstream

All error handling paths in this function 'goto err' except this one.

If one of the 2 previous memory allocations fails, we should go through
the existing error handling path. Otherwise there is an unbalanced
pm_runtime_enable()/pm_runtime_disable().

Fixes: dd55ff8346a9 ("ASoC: davinci-mcasp: Add set_tdm_slots() support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/davinci/davinci-mcasp.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/sound/soc/davinci/davinci-mcasp.c
+++ b/sound/soc/davinci/davinci-mcasp.c
@@ -2022,8 +2022,10 @@ static int davinci_mcasp_probe(struct pl
 			     GFP_KERNEL);
 
 	if (!mcasp->chconstr[SNDRV_PCM_STREAM_PLAYBACK].list ||
-	    !mcasp->chconstr[SNDRV_PCM_STREAM_CAPTURE].list)
-		return -ENOMEM;
+	    !mcasp->chconstr[SNDRV_PCM_STREAM_CAPTURE].list) {
+		ret = -ENOMEM;
+		goto err;
+	}
 
 	ret = davinci_mcasp_set_ch_constraints(mcasp);
 	if (ret)


