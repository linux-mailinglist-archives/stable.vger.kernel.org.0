Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C625AEB06
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238701AbiIFNuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234289AbiIFNrn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:47:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652DA7F278;
        Tue,  6 Sep 2022 06:39:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3F996CE1779;
        Tue,  6 Sep 2022 13:38:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6EEC433D6;
        Tue,  6 Sep 2022 13:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471482;
        bh=RGb7/zAtVJBSBWhhk2OQ6Qt6vTGoxALVQ1v5opqZyAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZHrElLfP+Q80M9ylxQofME7ayW/ocw7vx5dMbHNNGL4EA8Vk1c/rE3Tit9C+I1Ka6
         vQUiSetIIgZ/9FFCPezvU394qfgmZjtjJ5WxFcQzRhfgQ0kgzOIOH4iS3H9AUvkzLQ
         xJYaSZlKSGQTJYTgx+pSWOvNvLS4etWjpozQn37E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 5.15 042/107] misc: fastrpc: fix memory corruption on open
Date:   Tue,  6 Sep 2022 15:30:23 +0200
Message-Id: <20220906132823.598465098@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

commit d245f43aab2b61195d8ebb64cef7b5a08c590ab4 upstream.

The probe session-duplication overflow check incremented the session
count also when there were no more available sessions so that memory
beyond the fixed-size slab-allocated session array could be corrupted in
fastrpc_session_alloc() on open().

Fixes: f6f9279f2bf0 ("misc: fastrpc: Add Qualcomm fastrpc basic driver model")
Cc: stable@vger.kernel.org      # 5.1
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20220829080531.29681-3-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1555,7 +1555,7 @@ static int fastrpc_cb_probe(struct platf
 		spin_unlock_irqrestore(&cctx->lock, flags);
 		return -ENOSPC;
 	}
-	sess = &cctx->session[cctx->sesscount];
+	sess = &cctx->session[cctx->sesscount++];
 	sess->used = false;
 	sess->valid = true;
 	sess->dev = dev;
@@ -1568,13 +1568,12 @@ static int fastrpc_cb_probe(struct platf
 		struct fastrpc_session_ctx *dup_sess;
 
 		for (i = 1; i < sessions; i++) {
-			if (cctx->sesscount++ >= FASTRPC_MAX_SESSIONS)
+			if (cctx->sesscount >= FASTRPC_MAX_SESSIONS)
 				break;
-			dup_sess = &cctx->session[cctx->sesscount];
+			dup_sess = &cctx->session[cctx->sesscount++];
 			memcpy(dup_sess, sess, sizeof(*dup_sess));
 		}
 	}
-	cctx->sesscount++;
 	spin_unlock_irqrestore(&cctx->lock, flags);
 	rc = dma_set_mask(dev, DMA_BIT_MASK(32));
 	if (rc) {


