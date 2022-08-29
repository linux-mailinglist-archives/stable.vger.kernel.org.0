Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F4D5A4483
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 10:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiH2IGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 04:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiH2IGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 04:06:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488191FCD9;
        Mon, 29 Aug 2022 01:06:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE45AB80D56;
        Mon, 29 Aug 2022 08:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A595C433D7;
        Mon, 29 Aug 2022 08:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661760404;
        bh=KNKGIE3bHAIRg1FhRy5svzN00TPQDw3yiZKUrgewicQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XUoHJHaDPKJowsLt/nWFKf9SxrhygruA3UBkM7z5BJy4erb6YRzwUkLkQnTFsD2ki
         Ctxbhn+fGLuH2Lri3qI64izeRE6/cZ5zqi0YuigMolu13Ez6iKsnVXDj9NO7PaviBm
         b8seh2f44G0++OAyrExhnCyu+9hXAc98XA7qDrSVhZ3wrsskKyX4h7bgqRGeWNMW5C
         LcaBxLO88NzGhodtRdnCih0W5WcAng5RSsBtypFZbu/JAaN0u8+fcRbUouL43mXJYk
         Z/EVwt2mBADRPPWhDjBwc8KEvKciLh70vMqzhUWbB1V+hGtlOSykX1ubIm31LQud+J
         hGh7+VFgKqLaA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1oSZnI-0007jW-3g; Mon, 29 Aug 2022 10:06:52 +0200
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Amol Maheshwari <amahesh@qti.qualcomm.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <andersson@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 2/3] misc: fastrpc: fix memory corruption on open
Date:   Mon, 29 Aug 2022 10:05:30 +0200
Message-Id: <20220829080531.29681-3-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220829080531.29681-1-johan+linaro@kernel.org>
References: <20220829080531.29681-1-johan+linaro@kernel.org>
MIME-Version: 1.0
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

The probe session-duplication overflow check incremented the session
count also when there were no more available sessions so that memory
beyond the fixed-size slab-allocated session array could be corrupted in
fastrpc_session_alloc() on open().

Fixes: f6f9279f2bf0 ("misc: fastrpc: Add Qualcomm fastrpc basic driver model")
Cc: stable@vger.kernel.org      # 5.1
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/misc/fastrpc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index 88091778c1b8..6e312ac85668 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1948,7 +1948,7 @@ static int fastrpc_cb_probe(struct platform_device *pdev)
 		spin_unlock_irqrestore(&cctx->lock, flags);
 		return -ENOSPC;
 	}
-	sess = &cctx->session[cctx->sesscount];
+	sess = &cctx->session[cctx->sesscount++];
 	sess->used = false;
 	sess->valid = true;
 	sess->dev = dev;
@@ -1961,13 +1961,12 @@ static int fastrpc_cb_probe(struct platform_device *pdev)
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
-- 
2.35.1

