Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B9C5AEA1C
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238465AbiIFNnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbiIFNlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:41:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4D07B1E1;
        Tue,  6 Sep 2022 06:37:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3689B818B9;
        Tue,  6 Sep 2022 13:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E14C43149;
        Tue,  6 Sep 2022 13:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471338;
        bh=CuVSKtAd/E+3xS9tOaxYW/Bt0fKE3J+lXMil/OahZec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dLasBCPuxdpyS/qXGdRj8YLzlWKxbrbqbiEVAemh/rnbCa1a6YZkTd5i2B1TdjYBC
         u4r4K5j5Y78HcOlLz9Kmr3Xd0X2bMg5aN59k7VoTYFEBJWxHEX/qyo9Jrk90yc2/zE
         h+YR3awq1dHXkFiBNYJ5dSBhRrMSL6j1L8Eo5TwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Seunghui Lee <sh043.lee@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 75/80] mmc: core: Fix UHS-I SD 1.8V workaround branch
Date:   Tue,  6 Sep 2022 15:31:12 +0200
Message-Id: <20220906132820.254243758@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

commit 15c56208c79c340686869c31595c209d1431c5e8 upstream.

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
[Backport to 5.10]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/sd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -1107,7 +1107,7 @@ retry:
 					mmc_remove_card(card);
 				goto retry;
 			}
-			goto done;
+			goto cont;
 		}
 	}
 
@@ -1143,7 +1143,7 @@ retry:
 			mmc_set_bus_width(host, MMC_BUS_WIDTH_4);
 		}
 	}
-
+cont:
 	if (host->cqe_ops && !host->cqe_enabled) {
 		err = host->cqe_ops->cqe_enable(host, card);
 		if (!err) {
@@ -1161,7 +1161,7 @@ retry:
 		err = -EINVAL;
 		goto free_card;
 	}
-done:
+
 	host->card = card;
 	return 0;
 


