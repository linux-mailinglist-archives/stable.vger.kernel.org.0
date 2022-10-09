Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E505F9006
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 00:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbiJIWUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 18:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbiJIWT1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 18:19:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35533CBD2;
        Sun,  9 Oct 2022 15:16:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F5C3B80DDC;
        Sun,  9 Oct 2022 22:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F485C433B5;
        Sun,  9 Oct 2022 22:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353454;
        bh=7+9iLh8rQ4HHyOSIN1Pqo+gNYTzhMkFpZiwMptBxaMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kf8M1s2QSpVqLGB8ksUz/OHQIstUakTC0kvGdXAvdbxKLuHpbzokMEzJ7PsF0C6et
         u2v4KDqA60ERmQcPzf/N84o7n1Mz9kCNIZVorJ8CfJSMEpPdki0ztB3OxHytvGgR/t
         LYzAFJH1RhoFeShKOTsGteUW5PyOwvIQYvr/xmP+DNpE4HM6cETPUP18yQJKoBxtFe
         v4+XOJtIGrRmpaafVE/RzPBrZKLEgTlwCpHZ+viPy+2IugqzX4lxk2M2V5RxwELeq4
         hFk7KUgZ1dpqpU/rki1pdnWuX1ZoUKjGItxH9xK5ky4vgFqTYloXayWdxAtu68vDT4
         wI5oiDzy3LCoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Patrick Rudolph <patrick.rudolph@9elements.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, lgirdwood@gmail.com
Subject: [PATCH AUTOSEL 6.0 39/77] regulator: core: Prevent integer underflow
Date:   Sun,  9 Oct 2022 18:07:16 -0400
Message-Id: <20221009220754.1214186-39-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009220754.1214186-1-sashal@kernel.org>
References: <20221009220754.1214186-1-sashal@kernel.org>
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
index d3e8dc32832d..c3871565fd7d 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2681,7 +2681,7 @@ static int _regulator_do_enable(struct regulator_dev *rdev)
 	 * return -ETIMEDOUT.
 	 */
 	if (rdev->desc->poll_enabled_time) {
-		unsigned int time_remaining = delay;
+		int time_remaining = delay;
 
 		while (time_remaining > 0) {
 			_regulator_delay_helper(rdev->desc->poll_enabled_time);
-- 
2.35.1

