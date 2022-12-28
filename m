Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F7D657A29
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbiL1PI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbiL1PIX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:08:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835AD13DC7
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:08:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 262F3B81716
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:08:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3BFC433D2;
        Wed, 28 Dec 2022 15:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240100;
        bh=ZfqrHiCEGiV7vExI9qbA+EiaJlDYqbhK+PQWPeueR1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DG3Y64RFleSX0myJJrk+JWxCsIN7iVOX55/og8bkHlGbqyuUvBDfJRRLrwyPSwsls
         HwaRHMyMJ/sWHCjS2F0mp2SC4+cI8xSE0808SRSoPQ7ORSWf3zbq4lz5aqiMRviFcN
         m43C1UqxRigQGKSUEYbUJXtQ5Q+BYhKDsiKI1j34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhen Lei <thunder.leizhen@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 309/731] mmc: core: Normalize the error handling branch in sd_read_ext_regs()
Date:   Wed, 28 Dec 2022 15:36:56 +0100
Message-Id: <20221228144305.534317948@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit fc02e2b52389c8fde02852b2f959c0b45f042bbd ]

Let's use pr_err() to output the error messages and let's extend a comment
to clarify why returning 0 (success) in one case make sense.

Fixes: c784f92769ae ("mmc: core: Read the SD function extension registers for power management")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
[Ulf: Clarified the comment and the commit-msg]
Link: https://lore.kernel.org/r/20221130134920.2109-1-thunder.leizhen@huawei.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/sd.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 86a8a1f56583..592166e53dce 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -1252,7 +1252,7 @@ static int sd_read_ext_regs(struct mmc_card *card)
 	 */
 	err = sd_read_ext_reg(card, 0, 0, 0, 512, gen_info_buf);
 	if (err) {
-		pr_warn("%s: error %d reading general info of SD ext reg\n",
+		pr_err("%s: error %d reading general info of SD ext reg\n",
 			mmc_hostname(card->host), err);
 		goto out;
 	}
@@ -1266,7 +1266,12 @@ static int sd_read_ext_regs(struct mmc_card *card)
 	/* Number of extensions to be find. */
 	num_ext = gen_info_buf[4];
 
-	/* We support revision 0, but limit it to 512 bytes for simplicity. */
+	/*
+	 * We only support revision 0 and limit it to 512 bytes for simplicity.
+	 * No matter what, let's return zero to allow us to continue using the
+	 * card, even if we can't support the features from the SD function
+	 * extensions registers.
+	 */
 	if (rev != 0 || len > 512) {
 		pr_warn("%s: non-supported SD ext reg layout\n",
 			mmc_hostname(card->host));
@@ -1281,7 +1286,7 @@ static int sd_read_ext_regs(struct mmc_card *card)
 	for (i = 0; i < num_ext; i++) {
 		err = sd_parse_ext_reg(card, gen_info_buf, &next_ext_addr);
 		if (err) {
-			pr_warn("%s: error %d parsing SD ext reg\n",
+			pr_err("%s: error %d parsing SD ext reg\n",
 				mmc_hostname(card->host), err);
 			goto out;
 		}
-- 
2.35.1



