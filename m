Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10A4017EA18
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 21:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgCIUfK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 16:35:10 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56357 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725992AbgCIUfJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 16:35:09 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 2D2DD21ED6;
        Mon,  9 Mar 2020 16:35:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 09 Mar 2020 16:35:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=YOVzPk
        EnpyYHgVLnN3aQVfvtwV/VjAQ64IEwIehaykk=; b=E8peC0xw0C9ogzVbS0kiIW
        VScWmVyrGKhE9X6DS1UvTFGA9vvKdCTAkFtZEBbw+lFpxoeTpJnW8vC/2J/2mjlE
        nBH+RqgpTtem74WW7FCkLgccpmnKIDzOggtEli5GUDEkaz8djjy9RiDM35s8CmdV
        wCGg/OCONJ80b1SGpfI+9rxDz48+vetWzPJA4otbLNHThRFbRrQh8UYrxN2GEjK7
        WCX/OVQj6m5GAJTo3UdstFCjn+d78n4c6PYwl0PvILtMoasPERaeHMJBKWHYZSJT
        6zcW4XgqC1YA6B5r8jWO5mlCkaeMuMeae8wAYAMNtrK9K9Z8F07LmvPvOgDg3csA
        ==
X-ME-Sender: <xms:fKhmXhiey4StCTobndlUU6hjUJi7mKBfMsYdVEdq4QIMoylLinyK0A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddukedgudefkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekle
    druddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:fKhmXj7msIHGhccUzoy6iA0Z6fMZbnJGY0VH4iPIItg3_vt240sXPA>
    <xmx:fKhmXqIwK9h_59PJNvdrU-beIGkK0wA8DiqrLu46Y8sx953-tAZ6PA>
    <xmx:fKhmXnief8TWpeHy-8Uv3Fs6uaZlcVAjzTzCx49Jo904eWyMniFjQg>
    <xmx:fahmXsf3fx7lrWy-_hQT1lBAojPae3xH5WFfyS5v6AnsO_u6im1NmQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 955B6328005E;
        Mon,  9 Mar 2020 16:35:08 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ASoC: topology: Fix memleak in soc_tplg_manifest_load()" failed to apply to 4.14-stable tree
To:     dragos_tarcatu@mentor.com, broonie@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Mar 2020 21:35:06 +0100
Message-ID: <158378610642216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 242c46c023610dbc0213fc8fb6b71eb836bc5d95 Mon Sep 17 00:00:00 2001
From: Dragos Tarcatu <dragos_tarcatu@mentor.com>
Date: Fri, 7 Feb 2020 20:53:25 +0200
Subject: [PATCH] ASoC: topology: Fix memleak in soc_tplg_manifest_load()

In case of ABI version mismatch, _manifest needs to be freed as
it is just a copy of the original topology manifest. However, if
a driver manifest handler is defined, that would get executed and
the cleanup is never reached. Fix that by getting the return status
of manifest() instead of returning directly.

Fixes: 583958fa2e52 ("ASoC: topology: Make manifest backward compatible from ABI v4")
Signed-off-by: Dragos Tarcatu <dragos_tarcatu@mentor.com>
Link: https://lore.kernel.org/r/20200207185325.22320-3-dragos_tarcatu@mentor.com
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index 953517a73298..22c38df40d5a 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -2544,7 +2544,7 @@ static int soc_tplg_manifest_load(struct soc_tplg *tplg,
 {
 	struct snd_soc_tplg_manifest *manifest, *_manifest;
 	bool abi_match;
-	int err;
+	int ret = 0;
 
 	if (tplg->pass != SOC_TPLG_PASS_MANIFEST)
 		return 0;
@@ -2557,19 +2557,19 @@ static int soc_tplg_manifest_load(struct soc_tplg *tplg,
 		_manifest = manifest;
 	} else {
 		abi_match = false;
-		err = manifest_new_ver(tplg, manifest, &_manifest);
-		if (err < 0)
-			return err;
+		ret = manifest_new_ver(tplg, manifest, &_manifest);
+		if (ret < 0)
+			return ret;
 	}
 
 	/* pass control to component driver for optional further init */
 	if (tplg->comp && tplg->ops && tplg->ops->manifest)
-		return tplg->ops->manifest(tplg->comp, tplg->index, _manifest);
+		ret = tplg->ops->manifest(tplg->comp, tplg->index, _manifest);
 
 	if (!abi_match)	/* free the duplicated one */
 		kfree(_manifest);
 
-	return 0;
+	return ret;
 }
 
 /* validate header magic, size and type */

