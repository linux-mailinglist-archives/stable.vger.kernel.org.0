Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6C6616ED
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbfGGTnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:43:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57404 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727571AbfGGTiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:10 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz7-0006iQ-El; Sun, 07 Jul 2019 20:38:05 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz5-0005cP-Fa; Sun, 07 Jul 2019 20:38:03 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Timur Tabi" <timur@kernel.org>,
        "Nicolin Chen" <nicoleotsuka@gmail.com>,
        "Mark Brown" <broonie@kernel.org>,
        "Fabio Estevam" <festevam@gmail.com>,
        "Xiubo Li" <Xiubo.Lee@gmail.com>, "Takashi Iwai" <tiwai@suse.de>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.156746767@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 076/129] ASoC: fsl: Fix of-node refcount unbalance in
 fsl_ssi_probe_from_dt()
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
[bwh: Backported to 3.16:
 - Move declaration of root to the top of the function as there is no
   suitable block scope
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -1229,6 +1229,7 @@ static int fsl_ssi_probe(struct platform
 	struct fsl_ssi_private *ssi_private;
 	int ret = 0;
 	struct device_node *np = pdev->dev.of_node;
+	struct device_node *root;
 	const struct of_device_id *of_id;
 	const char *p, *sprop;
 	const uint32_t *iprop;
@@ -1373,7 +1374,9 @@ static int fsl_ssi_probe(struct platform
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

