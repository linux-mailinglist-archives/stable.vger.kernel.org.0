Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74637CA21B
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730309AbfJCQB7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:01:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731947AbfJCQB6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:01:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17021207FF;
        Thu,  3 Oct 2019 16:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118517;
        bh=h7qqrCFgfZ/DEQTk1JCp/CFiLubA0n8oC6DSbz2Bmhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0mSx9jpl9Se26RgDeciWpL5VxRRPYqcSxkiccqO/jDmE0FRAqRSYWiMLZ0IM5HBK2
         rTi+VKo+2IMSkwj9HiSdpZ6XSpHN6WG99w2Y4M9S2EsRS1kB7jdpZDVVlJHa44zu5x
         w0fcmIRwNgbEHa4k+3qHM8DADtqlim0ZYIkS5bKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Timur Tabi <timur@kernel.org>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Xiubo Li <Xiubo.Lee@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.9 009/129] ASoC: fsl: Fix of-node refcount unbalance in fsl_ssi_probe_from_dt()
Date:   Thu,  3 Oct 2019 17:52:12 +0200
Message-Id: <20191003154323.127768962@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154318.081116689@linuxfoundation.org>
References: <20191003154318.081116689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 2757970f6d0d0a112247600b23d38c0c728ceeb3 upstream.

The node obtained from of_find_node_by_path() has to be unreferenced
after the use, but we forgot it for the root node.

Fixes: f0fba2ad1b6b ("ASoC: multi-component - ASoC Multi-Component Support")
Cc: Timur Tabi <timur@kernel.org>
Cc: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: Xiubo Li <Xiubo.Lee@gmail.com>
Cc: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Acked-by: Nicolin Chen <nicoleotsuka@gmail.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/fsl/fsl_ssi.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -1431,6 +1431,7 @@ static int fsl_ssi_probe(struct platform
 	struct fsl_ssi_private *ssi_private;
 	int ret = 0;
 	struct device_node *np = pdev->dev.of_node;
+	struct device_node *root;
 	const struct of_device_id *of_id;
 	const char *p, *sprop;
 	const uint32_t *iprop;
@@ -1620,7 +1621,9 @@ static int fsl_ssi_probe(struct platform
 	 * device tree.  We also pass the address of the CPU DAI driver
 	 * structure.
 	 */
-	sprop = of_get_property(of_find_node_by_path("/"), "compatible", NULL);
+	root = of_find_node_by_path("/");
+	sprop = of_get_property(root, "compatible", NULL);
+	of_node_put(root);
 	/* Sometimes the compatible name has a "fsl," prefix, so we strip it. */
 	p = strrchr(sprop, ',');
 	if (p)


