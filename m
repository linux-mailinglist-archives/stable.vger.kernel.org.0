Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3523A96E
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731091AbfFIRKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:10:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388335AbfFIRC6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:02:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EDEA206C3;
        Sun,  9 Jun 2019 17:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099777;
        bh=acZXoBPoKiXvlqIJzBAzO0pMqsa6VZtkUPUMJfKHWvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KW7OcEmPBNNvc4KMslz5eGNj1dok/gkUg8TN0r74gQisYnT2cXMcZzjpabP6HFjnG
         WEcohsED3LXzmYFK15tYoadibFQBwPUH23bH33g65EtfayxLoRv2ILNookhT2PSpE3
         3kLrkrA1ibcmEfOM8fUJC080b/t7atwFttDcEJok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 162/241] ASoC: eukrea-tlv320: fix a leaked reference by adding missing of_node_put
Date:   Sun,  9 Jun 2019 18:41:44 +0200
Message-Id: <20190609164152.447744799@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b820d52e7eed7b30b2dfef5f4213a2bc3cbea6f3 ]

The call to of_parse_phandle returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with the following warnings:
./sound/soc/fsl/eukrea-tlv320.c:121:3-9: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 102, but without a correspo    nding object release within this function.
./sound/soc/fsl/eukrea-tlv320.c:127:3-9: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 102, but without a correspo    nding object release within this function.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/eukrea-tlv320.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/eukrea-tlv320.c b/sound/soc/fsl/eukrea-tlv320.c
index 883087f2b092b..38132143b7d5e 100644
--- a/sound/soc/fsl/eukrea-tlv320.c
+++ b/sound/soc/fsl/eukrea-tlv320.c
@@ -119,13 +119,13 @@ static int eukrea_tlv320_probe(struct platform_device *pdev)
 		if (ret) {
 			dev_err(&pdev->dev,
 				"fsl,mux-int-port node missing or invalid.\n");
-			return ret;
+			goto err;
 		}
 		ret = of_property_read_u32(np, "fsl,mux-ext-port", &ext_port);
 		if (ret) {
 			dev_err(&pdev->dev,
 				"fsl,mux-ext-port node missing or invalid.\n");
-			return ret;
+			goto err;
 		}
 
 		/*
-- 
2.20.1



