Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38B8A5493B9
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385335AbiFMOuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385640AbiFMOrt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:47:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34851C046B;
        Mon, 13 Jun 2022 04:52:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CEEA614F1;
        Mon, 13 Jun 2022 11:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED14C34114;
        Mon, 13 Jun 2022 11:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655121159;
        bh=9uKvnoG4B7uUYhEFbCpI+laNOBVB1oTWCNAqi04Sf4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lbBSqBMGDA4n/Yg3s2MZKB9rRpujOFegRdAFEzwto2KlB70eL6BpO28WncSprIdTg
         NgVIJXQTw5Imlvnqx0POo6oSJMdp8GJa7poIzP9ONcyc/E3WesAfopNQ/WAH2jYvfj
         G0yixsn9lEf4m8OtzHp5GoFf6bLNvdGnub7Ky0fM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.17 270/298] mmc: block: Fix CQE recovery reset success
Date:   Mon, 13 Jun 2022 12:12:44 +0200
Message-Id: <20220613094933.260413408@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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


