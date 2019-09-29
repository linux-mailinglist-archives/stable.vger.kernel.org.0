Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDEDC15A5
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729295AbfI2N5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:57:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729278AbfI2N5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:57:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 631E821835;
        Sun, 29 Sep 2019 13:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765459;
        bh=XFCC5U/nFhnPJcTciLk9XGgt1eSD5qy65Ge/nfC+bzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVeJaoBu796l3VM7LADwlUTiOwt3zn77wyq322fyktHMglBK2FA0p3gieIUi5Xmsl
         3of82rWwPqWUf6hxT4XtJ/arHBzcBkDr6Jy59JF4x9YZjCS7SlTDdMkntr3qgbiDG4
         pbxWBndpLOSBjbLcpbdRz5vs3A2VGw/3qq/kxlBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Timur Tabi <timur@kernel.org>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        Xiubo Li <Xiubo.Lee@gmail.com>,
        Fabio Estevam <festevam@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 26/63] ASoC: fsl: Fix of-node refcount unbalance in fsl_ssi_probe_from_dt()
Date:   Sun, 29 Sep 2019 15:53:59 +0200
Message-Id: <20190929135037.014754864@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
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
 sound/soc/fsl/fsl_ssi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -1439,8 +1439,10 @@ static int fsl_ssi_probe_from_dt(struct
 	 * different name to register the device.
 	 */
 	if (!ssi->card_name[0] && of_get_property(np, "codec-handle", NULL)) {
-		sprop = of_get_property(of_find_node_by_path("/"),
-					"compatible", NULL);
+		struct device_node *root = of_find_node_by_path("/");
+
+		sprop = of_get_property(root, "compatible", NULL);
+		of_node_put(root);
 		/* Strip "fsl," in the compatible name if applicable */
 		p = strrchr(sprop, ',');
 		if (p)


