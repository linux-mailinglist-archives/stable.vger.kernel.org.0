Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C67F85AE9C9
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240468AbiIFNes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240469AbiIFNeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:34:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412DE76941;
        Tue,  6 Sep 2022 06:33:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0001C61551;
        Tue,  6 Sep 2022 13:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D91AC433D7;
        Tue,  6 Sep 2022 13:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471193;
        bh=JKz0+usl3abCFLqFGuLN5xKJQJ+tO2O3kjFQG9YA+mU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yc1/NWBamDwXiq0bhOrsTShzcFc3cTl41gVM5AVrjI3IN04nxRKY7bGn4uLvuJgar
         Slaytn8gQZY/tB/b5O7tONd7cypS8/85eNnOu+TjaTCFs6DfFYqWYbPZdHz/+soqPk
         W8Xx3AY7YVFEs5V/espv60BhFjYcJUNJAmBAqaXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 5.10 30/80] misc: fastrpc: fix memory corruption on open
Date:   Tue,  6 Sep 2022 15:30:27 +0200
Message-Id: <20220906132818.214683804@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
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
@@ -1553,7 +1553,7 @@ static int fastrpc_cb_probe(struct platf
 		spin_unlock_irqrestore(&cctx->lock, flags);
 		return -ENOSPC;
 	}
-	sess = &cctx->session[cctx->sesscount];
+	sess = &cctx->session[cctx->sesscount++];
 	sess->used = false;
 	sess->valid = true;
 	sess->dev = dev;
@@ -1566,13 +1566,12 @@ static int fastrpc_cb_probe(struct platf
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


