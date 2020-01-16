Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D63A514002D
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392006AbgAPXs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:48:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729923AbgAPXTn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:19:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EBD82072B;
        Thu, 16 Jan 2020 23:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216782;
        bh=vCMaZbhVxeYyBOsgnoe59PxeVoonivF9+vmENCbzV+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZicqWHeDlg5hIMcyqCELVbwPlRDOnLg4hBBkV93LHOQCheYlx6iJovE9AeAASKaBX
         WbNPF4utzAza2vcDQKTEUYXO+Vbw5sWfs7bpWsZHKAr4WXOZimCckSHsJRX9Tzrz8g
         npJsrKe2vFK3I70UFZ60Or0Ujet2cDMpSESXcJcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 009/203] ASoC: SOF: imx8: fix memory allocation failure check on priv->pd_dev
Date:   Fri, 17 Jan 2020 00:15:26 +0100
Message-Id: <20200116231745.778215226@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit 98910e1d61384430a080b4bcf986c3b0cf3fdf46 upstream.

The memory allocation failure check for priv->pd_dev is incorrectly
pointer checking priv instead of priv->pd_dev. Fix this.

Addresses-Coverity: ("Logically dead code")
Fixes: 202acc565a1f ("ASoC: SOF: imx: Add i.MX8 HW support")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20191204124816.1415359-1-colin.king@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/sof/imx/imx8.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/sof/imx/imx8.c
+++ b/sound/soc/sof/imx/imx8.c
@@ -209,7 +209,7 @@ static int imx8_probe(struct snd_sof_dev
 
 	priv->pd_dev = devm_kmalloc_array(&pdev->dev, priv->num_domains,
 					  sizeof(*priv->pd_dev), GFP_KERNEL);
-	if (!priv)
+	if (!priv->pd_dev)
 		return -ENOMEM;
 
 	priv->link = devm_kmalloc_array(&pdev->dev, priv->num_domains,


