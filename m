Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D15657F91
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbiL1QGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233086AbiL1QGO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:06:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C996E3AD
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:06:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DB4061560
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F90C433D2;
        Wed, 28 Dec 2022 16:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243565;
        bh=D/0aBaHzn5SFB1NyUoKmFvLKw/eY2lz8Z++VcCbMTJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BRIupK5qH3fcDEVuwH0dYBL0ipinw4LalOi59LJ95OaPiu/OTPzv9kCoq8aD7mGtm
         ER5xkUfk3U4M07xB6iSebJ+aUDqEjp68YNfrpDxNM6hYZ1c3vlXUv6V6VDCGBSXeTO
         sEY1ybn2rAnm9YvydgbCTx6kCncvgyAtN+1HW6qI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhen Lei <thunder.leizhen@huawei.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0513/1146] mmc: core: Normalize the error handling branch in sd_read_ext_regs()
Date:   Wed, 28 Dec 2022 15:34:12 +0100
Message-Id: <20221228144344.109237786@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index 3662bf5320ce..72b664ed90cf 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -1259,7 +1259,7 @@ static int sd_read_ext_regs(struct mmc_card *card)
 	 */
 	err = sd_read_ext_reg(card, 0, 0, 0, 512, gen_info_buf);
 	if (err) {
-		pr_warn("%s: error %d reading general info of SD ext reg\n",
+		pr_err("%s: error %d reading general info of SD ext reg\n",
 			mmc_hostname(card->host), err);
 		goto out;
 	}
@@ -1273,7 +1273,12 @@ static int sd_read_ext_regs(struct mmc_card *card)
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
@@ -1288,7 +1293,7 @@ static int sd_read_ext_regs(struct mmc_card *card)
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



