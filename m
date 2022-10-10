Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBAC05F99D1
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbiJJHRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbiJJHRR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:17:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21DA95D0C0;
        Mon, 10 Oct 2022 00:11:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A198A60EAA;
        Mon, 10 Oct 2022 07:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24E6C433B5;
        Mon, 10 Oct 2022 07:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385744;
        bh=Y+U++6QDnIE7KxKB96bSJpMpiRYQxBJx6An03g7N+W0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NX+3JBz83uh7ZG50z0OPNE1xruhFatjuMs7f7UHmyvtSFQXFV0TVFxObHh7OiHqpP
         h6YIX4GTXKY0qmqqViEuE7x3Ug+ZalyI1kZLsQdvHBqoWqiB3fsbOzzdh6a7qcAz55
         8tNmGBSNEjlqUvJcsEjlS5vQlokITgBEgzkUtnJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ChanWoo Lee <cw9316.lee@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 28/37] mmc: core: Replace with already defined values for readability
Date:   Mon, 10 Oct 2022 09:05:47 +0200
Message-Id: <20221010070332.022671394@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070331.211113813@linuxfoundation.org>
References: <20221010070331.211113813@linuxfoundation.org>
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
index 7e8d4abed602..eaa2679b9466 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -863,7 +863,7 @@ int mmc_sd_get_cid(struct mmc_host *host, u32 ocr, u32 *cid, u32 *rocr)
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



