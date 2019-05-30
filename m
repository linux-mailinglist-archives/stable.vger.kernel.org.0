Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28ACE2F532
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbfE3EpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:45:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728749AbfE3DL5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:57 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CACA244E8;
        Thu, 30 May 2019 03:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185916;
        bh=dFb6AU3j1hRuep8QAfyqSFlBYLisUFvTepGXb2ad46g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CaLp9V0bKTPrjVAouRgi9/ucpkr8Ff+dwQDWn0nS3CSo+xxBh9m7GVJIucl3aiE4J
         wCvv+g0L78Thq3PaPdshkZixVtmHBzvMZ886+UifkcVOIXwSILMDSkvN1+zdDoFyMm
         hsQQcEGADtts5aPDari4F+fylUMOI9bwLjTeKkio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thierry Escande <thierry.escande@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 300/405] misc: fastrpc: Fix a possible double free
Date:   Wed, 29 May 2019 20:04:58 -0700
Message-Id: <20190530030556.000648592@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b49f6d83e290f17e20f4e5cf31288d3bb4955ea6 ]

This patch fixes the error exit path of fastrpc_init_create_process().
If the DMA allocation or the DSP invoke fails the fastrpc_map was freed
but not removed from the mapping list leading to a double free once the
mapping list is emptied in fastrpc_device_release().

[srinivas kandagatla]: Cleaned up error path labels and reset init mem
to NULL after free
Fixes: d73f71c7c6ee("misc: fastrpc: Add support for create remote init process")
Signed-off-by: Thierry Escande <thierry.escande@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/fastrpc.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index a10937652ca73..35be1cc11dd85 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -856,12 +856,12 @@ static int fastrpc_init_create_process(struct fastrpc_user *fl,
 
 	if (copy_from_user(&init, argp, sizeof(init))) {
 		err = -EFAULT;
-		goto bail;
+		goto err;
 	}
 
 	if (init.filelen > INIT_FILELEN_MAX) {
 		err = -EINVAL;
-		goto bail;
+		goto err;
 	}
 
 	inbuf.pgid = fl->tgid;
@@ -875,17 +875,15 @@ static int fastrpc_init_create_process(struct fastrpc_user *fl,
 	if (init.filelen && init.filefd) {
 		err = fastrpc_map_create(fl, init.filefd, init.filelen, &map);
 		if (err)
-			goto bail;
+			goto err;
 	}
 
 	memlen = ALIGN(max(INIT_FILELEN_MAX, (int)init.filelen * 4),
 		       1024 * 1024);
 	err = fastrpc_buf_alloc(fl, fl->sctx->dev, memlen,
 				&imem);
-	if (err) {
-		fastrpc_map_put(map);
-		goto bail;
-	}
+	if (err)
+		goto err_alloc;
 
 	fl->init_mem = imem;
 	args[0].ptr = (u64)(uintptr_t)&inbuf;
@@ -921,13 +919,24 @@ static int fastrpc_init_create_process(struct fastrpc_user *fl,
 
 	err = fastrpc_internal_invoke(fl, true, FASTRPC_INIT_HANDLE,
 				      sc, args);
+	if (err)
+		goto err_invoke;
 
-	if (err) {
+	kfree(args);
+
+	return 0;
+
+err_invoke:
+	fl->init_mem = NULL;
+	fastrpc_buf_free(imem);
+err_alloc:
+	if (map) {
+		spin_lock(&fl->lock);
+		list_del(&map->node);
+		spin_unlock(&fl->lock);
 		fastrpc_map_put(map);
-		fastrpc_buf_free(imem);
 	}
-
-bail:
+err:
 	kfree(args);
 
 	return err;
-- 
2.20.1



