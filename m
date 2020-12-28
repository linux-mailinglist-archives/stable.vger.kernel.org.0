Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F123C2E41F1
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437481AbgL1OEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:04:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:39106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437407AbgL1OEt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:04:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B94EA207AB;
        Mon, 28 Dec 2020 14:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164248;
        bh=+cmMv0uMJrujWPoK3N8mcTeU9YsK9TRbgsnMpu+2CUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mb7qh44LpD43DGSF3zeLgOf+nU8Ajc5i660eYvZQJ78pklv5IPU645yHmX6GUPoX3
         dVu295efgLWmoUNdRQgsJ2SaBKD1z8fTzFh6fq3/zDQPBeZzZkXbCzhCM2QpLpS39n
         PtV5xrKUre2iVnc8sljK/XcGLa2FT70wydpZTVTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 083/717] ASoC: qcom: common: Fix refcounting in qcom_snd_parse_of()
Date:   Mon, 28 Dec 2020 13:41:21 +0100
Message-Id: <20201228125024.962206587@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 4e59dd249cd513a211e2ecce2cb31f4e29a5ce5b ]

There are two issues in this function.

1) We can't drop the refrences on "cpu", "codec" and "platform" before
   we take the reference.  This doesn't cause a problem on the first
   iteration because those pointers start as NULL so the of_node_put()
   is a no-op.  But on the subsequent iterations, it will lead to a use
   after free.

2) If the devm_kzalloc() allocation failed then the code returned
   directly instead of cleaning up.

Fixes: c1e6414cdc37 ("ASoC: qcom: common: Fix refcount imbalance on error")
Fixes: 1e36ea360ab9 ("ASoC: qcom: common: use modern dai_link style")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20201105125154.GA176426@mwanda
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/common.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/sound/soc/qcom/common.c b/sound/soc/qcom/common.c
index 54660f126d09e..09af007007007 100644
--- a/sound/soc/qcom/common.c
+++ b/sound/soc/qcom/common.c
@@ -58,7 +58,7 @@ int qcom_snd_parse_of(struct snd_soc_card *card)
 		dlc = devm_kzalloc(dev, 2 * sizeof(*dlc), GFP_KERNEL);
 		if (!dlc) {
 			ret = -ENOMEM;
-			goto err;
+			goto err_put_np;
 		}
 
 		link->cpus	= &dlc[0];
@@ -70,7 +70,7 @@ int qcom_snd_parse_of(struct snd_soc_card *card)
 		ret = of_property_read_string(np, "link-name", &link->name);
 		if (ret) {
 			dev_err(card->dev, "error getting codec dai_link name\n");
-			goto err;
+			goto err_put_np;
 		}
 
 		cpu = of_get_child_by_name(np, "cpu");
@@ -130,8 +130,10 @@ int qcom_snd_parse_of(struct snd_soc_card *card)
 		} else {
 			/* DPCM frontend */
 			dlc = devm_kzalloc(dev, sizeof(*dlc), GFP_KERNEL);
-			if (!dlc)
-				return -ENOMEM;
+			if (!dlc) {
+				ret = -ENOMEM;
+				goto err;
+			}
 
 			link->codecs	 = dlc;
 			link->num_codecs = 1;
@@ -158,10 +160,11 @@ int qcom_snd_parse_of(struct snd_soc_card *card)
 
 	return 0;
 err:
-	of_node_put(np);
 	of_node_put(cpu);
 	of_node_put(codec);
 	of_node_put(platform);
+err_put_np:
+	of_node_put(np);
 	return ret;
 }
 EXPORT_SYMBOL(qcom_snd_parse_of);
-- 
2.27.0



