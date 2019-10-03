Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3376CA19F
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 17:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731007AbfJCP5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:57:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731004AbfJCP5l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:57:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB3F720700;
        Thu,  3 Oct 2019 15:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118260;
        bh=IcFEqKSzhlE2huX698hch9Qt6fR7Sr3QJnA7k5YfM6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9rZrpmcB5Klx0KlBXtmwWTUMF39SByFD3o+5rkDtD+Q041Bx5YsDLAS9WoeKRMHi
         fWC8dY1cwmtd48LMunds/KH5bxf4lTCIrjqiYE3g1k5AAk+0fVYrmfBS5k1A9EOoDd
         ku9MVSBYJ1aiolWjwzjuaIKgPwuU8zWqg+IPjVIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Timur Tabi <timur@kernel.org>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Xiubo Li <Xiubo.Lee@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.4 09/99] ASoC: fsl: Fix of-node refcount unbalance in fsl_ssi_probe_from_dt()
Date:   Thu,  3 Oct 2019 17:52:32 +0200
Message-Id: <20191003154257.324014712@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
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
@@ -1374,6 +1374,7 @@ static int fsl_ssi_probe(struct platform
 	struct fsl_ssi_private *ssi_private;
 	int ret = 0;
 	struct device_node *np = pdev->dev.of_node;
+	struct device_node *root;
 	const struct of_device_id *of_id;
 	const char *p, *sprop;
 	const uint32_t *iprop;
@@ -1510,7 +1511,9 @@ static int fsl_ssi_probe(struct platform
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


