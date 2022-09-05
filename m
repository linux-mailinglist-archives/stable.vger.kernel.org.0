Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD875AD705
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 17:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbiIEP7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 11:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiIEP7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 11:59:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1272712616
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 08:59:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA7CAB81201
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 15:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16731C433C1;
        Mon,  5 Sep 2022 15:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662393549;
        bh=K8irKvhFKFNAIzyGN+nplpH75F0JNplKKZFFXWH/5jw=;
        h=Subject:To:Cc:From:Date:From;
        b=V0ql+CtTDlcFQxYQ1DNDsxYcw4PJZSho0V5L24ZT9tM2iuW29UnO/8/l8o/mKvRIk
         ibj8BJTinbgNsj8G3UlgNJ5N0yjNHxBcb3Z8dzrVzFnIFyyZwD+3gZyKPkTIr0ySq4
         KRLINMgmsU5ueKH+7UxgkBCsEw4GHFdWd3W/GM3Q=
Subject: FAILED: patch "[PATCH] mmc: core: Fix UHS-I SD 1.8V workaround branch" failed to apply to 5.10-stable tree
To:     adrian.hunter@intel.com, sh043.lee@samsung.com,
        ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Sep 2022 17:59:06 +0200
Message-ID: <166239354678155@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 15c56208c79c340686869c31595c209d1431c5e8 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@intel.com>
Date: Mon, 15 Aug 2022 10:33:20 +0300
Subject: [PATCH] mmc: core: Fix UHS-I SD 1.8V workaround branch

When introduced, upon success, the 1.8V fixup workaround in
mmc_sd_init_card() would branch to practically the end of the function, to
a label named "done". Unfortunately, perhaps due to the label name, over
time new code has been added that really should have come after "done" not
before it. Let's fix the problem by moving the label to the correct place
and rename it "cont".

Fixes: 045d705dc1fb ("mmc: core: Enable the MMC host software queue for the SD card")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Seunghui Lee <sh043.lee@samsung.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220815073321.63382-2-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index cee4c0b59f43..bc84d7dfc8e1 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -1498,7 +1498,7 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
 					mmc_remove_card(card);
 				goto retry;
 			}
-			goto done;
+			goto cont;
 		}
 	}
 
@@ -1534,7 +1534,7 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
 			mmc_set_bus_width(host, MMC_BUS_WIDTH_4);
 		}
 	}
-
+cont:
 	if (!oldcard) {
 		/* Read/parse the extension registers. */
 		err = sd_read_ext_regs(card);
@@ -1566,7 +1566,7 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
 		err = -EINVAL;
 		goto free_card;
 	}
-done:
+
 	host->card = card;
 	return 0;
 

