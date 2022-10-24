Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A858C60A9DF
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbiJXN0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236151AbiJXNYd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:24:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9E19F74D;
        Mon, 24 Oct 2022 05:30:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1603D61331;
        Mon, 24 Oct 2022 12:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E6AC433C1;
        Mon, 24 Oct 2022 12:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614578;
        bh=wzVrqqZRg7fswRLItuLjYSP7Zzpk6JKxUzObx4VK59E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKteBCsP0Zvgn7dIgWAQ8cY00GKpm4GHiukRQmtP98tqhu6Mp8XZBEVxXyShRriSc
         JJWa6WSn6Q+W4b/TxF4KSyYi4Hte0DyKXFF3FxjfSgtHH6ocsXR5DK/KwaRBJW73Q/
         KkJF71Yeoz9k67RzZYMGvuYOX+vLupNd0D91hlRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Patrick Rudolph <patrick.rudolph@9elements.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 313/390] regulator: core: Prevent integer underflow
Date:   Mon, 24 Oct 2022 13:31:50 +0200
Message-Id: <20221024113036.294889422@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrick Rudolph <patrick.rudolph@9elements.com>

[ Upstream commit 8d8e16592022c9650df8aedfe6552ed478d7135b ]

By using a ratio of delay to poll_enabled_time that is not integer
time_remaining underflows and does not exit the loop as expected.
As delay could be derived from DT and poll_enabled_time is defined
in the driver this can easily happen.

Use a signed iterator to make sure that the loop exits once
the remaining time is negative.

Signed-off-by: Patrick Rudolph <patrick.rudolph@9elements.com>
Link: https://lore.kernel.org/r/20220909125954.577669-1-patrick.rudolph@9elements.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 317d701487ec..bf8ba73d6c7c 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2544,7 +2544,7 @@ static int _regulator_do_enable(struct regulator_dev *rdev)
 	 * expired, return -ETIMEDOUT.
 	 */
 	if (rdev->desc->poll_enabled_time) {
-		unsigned int time_remaining = delay;
+		int time_remaining = delay;
 
 		while (time_remaining > 0) {
 			_regulator_enable_delay(rdev->desc->poll_enabled_time);
-- 
2.35.1



