Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B55C5AEBC4
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241659AbiIFOVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242260AbiIFOUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:20:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37EF32D9F;
        Tue,  6 Sep 2022 06:51:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 870ECB818D6;
        Tue,  6 Sep 2022 13:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D608CC433D6;
        Tue,  6 Sep 2022 13:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471899;
        bh=XLZAU+yWVD3tW1KrDP6Eg2rL0DPZXfjWp3mf4DblUoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oa1F8DiMTdLX4bszhB8CbjBMCIQWJTLRLoyjDiwFO59KPj1nl50LFAExJt/JJelpH
         06tvHcW8y9leR+n+yLtdbLVf9zqVqK86WVHD8hUPWpYmoQSVzY9DLupzIR1SHTuAPj
         huB+WcMpY9V9FAX/kDq1H+bUdA5Ckns4dfAK3lQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Seunghui Lee <sh043.lee@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.19 078/155] mmc: core: Fix UHS-I SD 1.8V workaround branch
Date:   Tue,  6 Sep 2022 15:30:26 +0200
Message-Id: <20220906132832.731829422@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/sd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -1498,7 +1498,7 @@ retry:
 					mmc_remove_card(card);
 				goto retry;
 			}
-			goto done;
+			goto cont;
 		}
 	}
 
@@ -1534,7 +1534,7 @@ retry:
 			mmc_set_bus_width(host, MMC_BUS_WIDTH_4);
 		}
 	}
-
+cont:
 	if (!oldcard) {
 		/* Read/parse the extension registers. */
 		err = sd_read_ext_regs(card);
@@ -1566,7 +1566,7 @@ retry:
 		err = -EINVAL;
 		goto free_card;
 	}
-done:
+
 	host->card = card;
 	return 0;
 


