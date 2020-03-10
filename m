Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 851CC17FB6E
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731801AbgCJNN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:13:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731795AbgCJNNx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:13:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0111B2468C;
        Tue, 10 Mar 2020 13:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583846032;
        bh=ZDJk+mwxFqV9auaVzGh9+Z3RTbLdrF7yBgZNTtYldSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uc+TXWY+sKdi/WrRIXxqGQa5+er0MEZ8rShP+YFKEB6hBwrW0wO0LSlpVRi4s7Mhg
         3UNv8wYHwAH63vSVsHDmjizIqpw8O5uAzuTF+nPHz1QALclDR52vzjm3Y8lJ1D8B7R
         8HvAIzem1aA7x1LMgyAjKXQoiA/fxUeppuCjT1xI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dragos Tarcatu <dragos_tarcatu@mentor.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 61/86] ASoC: topology: Fix memleak in soc_tplg_manifest_load()
Date:   Tue, 10 Mar 2020 13:45:25 +0100
Message-Id: <20200310124534.088509047@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124530.808338541@linuxfoundation.org>
References: <20200310124530.808338541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dragos Tarcatu <dragos_tarcatu@mentor.com>

commit 242c46c023610dbc0213fc8fb6b71eb836bc5d95 upstream.

In case of ABI version mismatch, _manifest needs to be freed as
it is just a copy of the original topology manifest. However, if
a driver manifest handler is defined, that would get executed and
the cleanup is never reached. Fix that by getting the return status
of manifest() instead of returning directly.

Fixes: 583958fa2e52 ("ASoC: topology: Make manifest backward compatible from ABI v4")
Signed-off-by: Dragos Tarcatu <dragos_tarcatu@mentor.com>
Link: https://lore.kernel.org/r/20200207185325.22320-3-dragos_tarcatu@mentor.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-topology.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -2313,7 +2313,7 @@ static int soc_tplg_manifest_load(struct
 {
 	struct snd_soc_tplg_manifest *manifest, *_manifest;
 	bool abi_match;
-	int err;
+	int ret = 0;
 
 	if (tplg->pass != SOC_TPLG_PASS_MANIFEST)
 		return 0;
@@ -2326,19 +2326,19 @@ static int soc_tplg_manifest_load(struct
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


