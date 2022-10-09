Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2965F91E8
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 00:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbiJIWmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 18:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbiJIWkl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 18:40:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3E6402ED;
        Sun,  9 Oct 2022 15:22:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D650FB80DDB;
        Sun,  9 Oct 2022 22:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FB8C4347C;
        Sun,  9 Oct 2022 22:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354131;
        bh=wzVrqqZRg7fswRLItuLjYSP7Zzpk6JKxUzObx4VK59E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AWfqKgZq9hWYfmkDzBFcYaT5x/+O4PqA6P0rSDl75hqRrH3MlHBa7rR06fOFhbQvX
         coYIm6jV4a5HtWnsa9JMnRrxtBBD+UwQgExEFoBL4zf6TLKm3nARFqHBOKXBAIJFKK
         zg78k4Yq62Gf7bU8pw3qrmPwW3fSKKLtS6eZq1Vg5u0Hf7r0uNMRD2Sg4UjuCXMLLw
         qU3Bn3LO5sRi4UKLe2nPbs9LAFG734cUD+ZnV7nJSHHntW8c9w0iM8pc5jF5Cd6iU1
         sFJMg+uz2PjXEwFd9n1RTN5O0Vr4L28F1DPa9NgoaTiWfEvYCnlRgyAJrAUrHzT0mo
         O1ygBEa9P0eUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Patrick Rudolph <patrick.rudolph@9elements.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com
Subject: [PATCH AUTOSEL 5.10 14/34] regulator: core: Prevent integer underflow
Date:   Sun,  9 Oct 2022 18:21:08 -0400
Message-Id: <20221009222129.1218277-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222129.1218277-1-sashal@kernel.org>
References: <20221009222129.1218277-1-sashal@kernel.org>
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

