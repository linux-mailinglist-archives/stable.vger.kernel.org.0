Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4DC56FBF7
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbiGKJh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbiGKJgn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:36:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC851261F;
        Mon, 11 Jul 2022 02:19:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B4836111F;
        Mon, 11 Jul 2022 09:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34BE3C34115;
        Mon, 11 Jul 2022 09:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531147;
        bh=x7m0mhFzTw7bZfUJ5gPgtgFWPeIZ0MGHw9B9TK6gqyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cTbqoFdsar8Ty4czdenutGtSOfvmWfvy9P5ciyQ85+xukHEJ3PF3E//QfRjruicUo
         5ZkrdRuc9vncNh0PKT34ftqTkZwcXyLGgkHbG49NpLK01IHn2BCFZTDyMRk18RjbPk
         jngJ7A+bmr2Eiz7lfk6nJIXLWUftfZ91Zk8DFdpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Zhu <tony.zhu@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.18 112/112] dmaengine: idxd: force wq context cleanup on device disable path
Date:   Mon, 11 Jul 2022 11:07:52 +0200
Message-Id: <20220711090552.746712817@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

commit 44c4237cf3436bda2b185ff728123651ad133f69 upstream.

Testing shown that when a wq mode is setup to be dedicated and then torn
down and reconfigured to shared, the wq configured end up being dedicated
anyays. The root cause is when idxd_device_wqs_clear_state() gets called
during idxd_driver removal, idxd_wq_disable_cleanup() does not get called
vs when the wq driver is removed first. The check of wq state being
"enabled" causes the cleanup to be bypassed. However, idxd_driver->remove()
releases all wq drivers. So the wqs goes to "disabled" state and will never
be "enabled". By that point, the driver has no idea if the wq was
previously configured or clean. So force call idxd_wq_disable_cleanup() on
all wqs always to make sure everything gets cleaned up.

Reported-by: Tony Zhu <tony.zhu@intel.com>
Tested-by: Tony Zhu <tony.zhu@intel.com>
Fixes: 0dcfe41e9a4c ("dmanegine: idxd: cleanup all device related bits after disabling device")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Co-developed-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: https://lore.kernel.org/r/20220628230056.2527816-1-fenghua.yu@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/device.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -698,10 +698,7 @@ static void idxd_device_wqs_clear_state(
 	for (i = 0; i < idxd->max_wqs; i++) {
 		struct idxd_wq *wq = idxd->wqs[i];
 
-		if (wq->state == IDXD_WQ_ENABLED) {
-			idxd_wq_disable_cleanup(wq);
-			wq->state = IDXD_WQ_DISABLED;
-		}
+		idxd_wq_disable_cleanup(wq);
 		idxd_wq_device_reset_cleanup(wq);
 	}
 }


