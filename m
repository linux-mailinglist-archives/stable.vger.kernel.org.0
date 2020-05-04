Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC12D1C4387
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 19:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730728AbgEDR7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 13:59:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730715AbgEDR7L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 13:59:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37073207DD;
        Mon,  4 May 2020 17:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615150;
        bh=19ZLzxZ3iCQ95N4Ki0BMSsdfiekRIWUaniX2b/lyVuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KEW8wftZbUpEmxFotn3YU9a97Rx/SMnhZGNkzqQiDeH3sheOQuxMZpoXIP9FbO9Po
         maoI4sE06JBJ+ORaqsDMBGpPvSJJoNQO0wO6lMTY/45418tRs+DY8VewN5baLUdjoq
         xXhL4R3aYs55HbmxWYxamia1RtybWzmWJQG6DLG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.4 16/18] ASoC: imx-spdif: Fix crash on suspend
Date:   Mon,  4 May 2020 19:57:14 +0200
Message-Id: <20200504165445.006367933@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165441.533160703@linuxfoundation.org>
References: <20200504165441.533160703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

commit 9954859185c6e8359e71121037b627f1e294057d upstream.

When registering a ASoC card the driver data of the parent device is set to
point to the card. This driver data is used in the
snd_soc_suspend()/resume() callbacks.

The imx-spdif driver overwrites the driver data with custom data which
causes snd_soc_suspend() to crash.  Since the custom driver is not used
anywhere simply deleting the line which sets the custom driver data fixes
the issue.

Fixes: 43ac946922b3 ("ASoC: imx-spdif: add snd_soc_pm_ops for spdif machine driver")
Tested-by: Fabio Estevam <fabio.estevam@nxp.com>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/fsl/imx-spdif.c |    2 --
 1 file changed, 2 deletions(-)

--- a/sound/soc/fsl/imx-spdif.c
+++ b/sound/soc/fsl/imx-spdif.c
@@ -72,8 +72,6 @@ static int imx_spdif_audio_probe(struct
 		goto end;
 	}
 
-	platform_set_drvdata(pdev, data);
-
 end:
 	of_node_put(spdif_np);
 


