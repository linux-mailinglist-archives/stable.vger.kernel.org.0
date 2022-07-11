Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA1C56FE21
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbiGKKEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234485AbiGKKDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 06:03:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128CF48EB0;
        Mon, 11 Jul 2022 02:29:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AAF361366;
        Mon, 11 Jul 2022 09:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB014C34115;
        Mon, 11 Jul 2022 09:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531779;
        bh=4P9xq6q8hGoQvb8Sigl3/Po/KZymH+V3vIWWDe8U1Uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sp8LOhS7MXPRFIee/jhapWJ/JWVTzjy5/XOBtIkKeROUoxMLFG70rSnf4B3Q69pdp
         4Ojvo1cUt3L36jzrbQoK3B+DeLtAbNyX0H+d2cOiwtL9zGJCeZBWW9ts82Uj6+W1ts
         qZ+FvEPrQ91QDW2oVuPT/F8c+Jb733gJoiTfnwBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Zhu <tony.zhu@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 229/230] dmaengine: idxd: force wq context cleanup on device disable path
Date:   Mon, 11 Jul 2022 11:08:05 +0200
Message-Id: <20220711090610.597250131@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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
@@ -720,10 +720,7 @@ static void idxd_device_wqs_clear_state(
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


