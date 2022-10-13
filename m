Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA295FE00D
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiJMSDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbiJMSCz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:02:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE3816F429;
        Thu, 13 Oct 2022 11:02:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14C5A6190C;
        Thu, 13 Oct 2022 17:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210FDC433C1;
        Thu, 13 Oct 2022 17:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665683726;
        bh=2swSttbWyE/EMdRGTQ4BtEFhtKWKbDYZ8JrOfdawUHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vhmjFGVEuyyf3l0G6Ov9r6GmVTbtSQJDXTBI2nDU6gB6o1LkzkxkyZX/OJDRt+NUY
         JNbPcOl4tfME+8LBab7BL5Zxp5p6L+msi10vEpozRMSfHO9a1cV8KGctEtZKPC9TdA
         +5RvSrMUsuYcs3GJ3W8acyo2IZ3m7lYY/llmR39M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ChanWoo Lee <cw9316.lee@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 29/54] mmc: core: Replace with already defined values for readability
Date:   Thu, 13 Oct 2022 19:52:23 +0200
Message-Id: <20221013175148.062841812@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175147.337501757@linuxfoundation.org>
References: <20221013175147.337501757@linuxfoundation.org>
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

From: ChanWoo Lee <cw9316.lee@samsung.com>

[ Upstream commit e427266460826bea21b70f9b2bb29decfb2c2620 ]

SD_ROCR_S18A is already defined and is used to check the rocr value, so
let's replace with already defined values for readability.

Signed-off-by: ChanWoo Lee <cw9316.lee@samsung.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20220706004840.24812-1-cw9316.lee@samsung.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: e9233917a7e5 ("mmc: core: Terminate infinite loop in SD-UHS voltage switch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 899768ed1688..e2c34aa390f1 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -853,7 +853,7 @@ int mmc_sd_get_cid(struct mmc_host *host, u32 ocr, u32 *cid, u32 *rocr)
 	 * the CCS bit is set as well. We deliberately deviate from the spec in
 	 * regards to this, which allows UHS-I to be supported for SDSC cards.
 	 */
-	if (!mmc_host_is_spi(host) && rocr && (*rocr & 0x01000000)) {
+	if (!mmc_host_is_spi(host) && rocr && (*rocr & SD_ROCR_S18A)) {
 		err = mmc_set_uhs_voltage(host, pocr);
 		if (err == -EAGAIN) {
 			retries--;
-- 
2.35.1



