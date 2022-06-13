Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9823548B7B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359022AbiFMNVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377030AbiFMNT4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:19:56 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8270E694B0;
        Mon, 13 Jun 2022 04:23:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7C32DCE118D;
        Mon, 13 Jun 2022 11:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA99C34114;
        Mon, 13 Jun 2022 11:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119349;
        bh=9uKvnoG4B7uUYhEFbCpI+laNOBVB1oTWCNAqi04Sf4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBse8UTQcdzoZJFjUZC51Q1j4h7Gy4KQ5xiBYxcBUGR3q/ugXbuVejv6yEvSw5yn4
         xhkMGGA3o0wBTAE9QfV1Lx6cbYvqc7onizF45hHutMP9OBf+UIpxH0cSZ6DZqoVcAu
         zu8BWdr24A9YI//aWw+0oB9qpzaIpAx6LBAXhT/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 223/247] mmc: block: Fix CQE recovery reset success
Date:   Mon, 13 Jun 2022 12:12:05 +0200
Message-Id: <20220613094929.709034893@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit a051246b786af7e4a9d9219cc7038a6e8a411531 upstream.

The intention of the use of mmc_blk_reset_success() in
mmc_blk_cqe_recovery() was to prevent repeated resets when retrying and
getting the same error. However, that may not be the case - any amount
of time and I/O may pass before another recovery is needed, in which
case there would be no reason to deny it the opportunity to recover via
a reset if necessary. CQE recovery is expected seldom and failure to
recover (if the clear tasks command fails), even more seldom, so it is
better to allow the reset always, which can be done by calling
mmc_blk_reset_success() always.

Fixes: 1e8e55b67030c6 ("mmc: block: Add CQE support")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20220531171922.76080-1-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1482,8 +1482,7 @@ void mmc_blk_cqe_recovery(struct mmc_que
 	err = mmc_cqe_recovery(host);
 	if (err)
 		mmc_blk_reset(mq->blkdata, host, MMC_BLK_CQE_RECOVERY);
-	else
-		mmc_blk_reset_success(mq->blkdata, MMC_BLK_CQE_RECOVERY);
+	mmc_blk_reset_success(mq->blkdata, MMC_BLK_CQE_RECOVERY);
 
 	pr_debug("%s: CQE recovery done\n", mmc_hostname(host));
 }


