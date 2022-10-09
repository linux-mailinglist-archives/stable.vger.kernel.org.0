Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3D05F90D3
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 00:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbiJIW1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 18:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbiJIW0C (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 18:26:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F421A3DBF2;
        Sun,  9 Oct 2022 15:18:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6577B80E07;
        Sun,  9 Oct 2022 22:17:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89BCC433D6;
        Sun,  9 Oct 2022 22:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353837;
        bh=e69ynLJuqC7qhUEJrETi/PJwrTuWrNPBE7bGAuEbq7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YPVcpICMDhDg7kyqFYyfs5MEwip1H7kk/euv8Y16PdoXwv6+7EJ0wVVg8YN2XIqgK
         cBvzLMXftlgGHV33QsysdMXZoDYNHEK2ZdokwEaJkLIxdIyj+4C8KTeR2YvsFOuL/G
         //8ZUPjTc8P5vLKAbDLx6cRkI5fJUORxfkG/GSaGVvE3j/JEo1U0wdYoqDH14K2Xdy
         1TqG8IW1yLWwJtQh+pmiErXhOQwztjpCNCyZMRAdT0T4/60kcXfLtY10oTnTuo/OXC
         +A5xlQDkvDCU2CTTH0rmaBjbrDzbZjV2ANjJPPjOqSW5VcRwhEujYROHXAhTsGWg5B
         zWvrTeZdgMSzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Patrick Rudolph <patrick.rudolph@9elements.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com
Subject: [PATCH AUTOSEL 5.19 36/73] regulator: core: Prevent integer underflow
Date:   Sun,  9 Oct 2022 18:14:14 -0400
Message-Id: <20221009221453.1216158-36-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221453.1216158-1-sashal@kernel.org>
References: <20221009221453.1216158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index a9daaf4d5aaa..9567d2fc3f00 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2680,7 +2680,7 @@ static int _regulator_do_enable(struct regulator_dev *rdev)
 	 * return -ETIMEDOUT.
 	 */
 	if (rdev->desc->poll_enabled_time) {
-		unsigned int time_remaining = delay;
+		int time_remaining = delay;
 
 		while (time_remaining > 0) {
 			_regulator_delay_helper(rdev->desc->poll_enabled_time);
-- 
2.35.1

