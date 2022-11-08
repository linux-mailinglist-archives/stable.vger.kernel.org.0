Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27034621331
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbiKHNrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:47:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234581AbiKHNrr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:47:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A012B59876
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:47:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 579B5B81AE4
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:47:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975DBC433D6;
        Tue,  8 Nov 2022 13:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915264;
        bh=tMRYLnpq6EWpTV7qCQ/oc4bWdyeQ53a47Xfk4HhCxp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TduTdgfsP4VR0oTWlfm13REbKLMOepYLZxLaA2Gyj6vjqLsGgSiNduHDYPtjc+h8f
         qZc4b8CoxMkbeevc05+aH5I+nDy297wUeTrG9ApYoSAEcayD6ZC87GFG2+HSO5SIEH
         yXE43pk6CtxeFUczeQ1siotNF8mm3xiRrCqcQCCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dean Luick <dean.luick@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 02/74] IB/hfi1: Correctly move list in sc_disable()
Date:   Tue,  8 Nov 2022 14:38:30 +0100
Message-Id: <20221108133333.765899744@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
References: <20221108133333.659601604@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dean Luick <dean.luick@cornelisnetworks.com>

[ Upstream commit 1afac08b39d85437187bb2a92d89a741b1078f55 ]

Commit 13bac861952a ("IB/hfi1: Fix abba locking issue with sc_disable()")
incorrectly tries to move a list from one list head to another.  The
result is a kernel crash.

The crash is triggered when a link goes down and there are waiters for a
send to complete.  The following signature is seen:

  BUG: kernel NULL pointer dereference, address: 0000000000000030
  [...]
  Call Trace:
   sc_disable+0x1ba/0x240 [hfi1]
   pio_freeze+0x3d/0x60 [hfi1]
   handle_freeze+0x27/0x1b0 [hfi1]
   process_one_work+0x1b0/0x380
   ? process_one_work+0x380/0x380
   worker_thread+0x30/0x360
   ? process_one_work+0x380/0x380
   kthread+0xd7/0x100
   ? kthread_complete_and_exit+0x20/0x20
   ret_from_fork+0x1f/0x30

The fix is to use the correct call to move the list.

Fixes: 13bac861952a ("IB/hfi1: Fix abba locking issue with sc_disable()")
Signed-off-by: Dean Luick <dean.luick@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Link: https://lore.kernel.org/r/166610327042.674422.6146908799669288976.stgit@awfm-02.cornelisnetworks.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/pio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
index 1a82ea73a0fc..fa5de362010f 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -955,8 +955,7 @@ void sc_disable(struct send_context *sc)
 	spin_unlock(&sc->release_lock);
 
 	write_seqlock(&sc->waitlock);
-	if (!list_empty(&sc->piowait))
-		list_move(&sc->piowait, &wake_list);
+	list_splice_init(&sc->piowait, &wake_list);
 	write_sequnlock(&sc->waitlock);
 	while (!list_empty(&wake_list)) {
 		struct iowait *wait;
-- 
2.35.1



