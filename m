Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140944AFB14
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239806AbiBISlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240543AbiBISlS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:41:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46EFC050CDC;
        Wed,  9 Feb 2022 10:40:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 508B160918;
        Wed,  9 Feb 2022 18:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24DD2C340F1;
        Wed,  9 Feb 2022 18:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644432058;
        bh=uRlHFpIsQzxqllfbzfwzAuNa6lQoro19ri1Ycsapu8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dUUZnQhxaYWbvFU7mq8uYwPYyz3e/yxx2aj1B15UKcHbxfaGqzvVroA15oFKBIs9z
         ivUhJP69kHWoZg8ZJ946EdaJxhOF2ZGveE/zxwoCYzz7Zf4cRrecvWr4rtCpbqo41P
         KpCAvVJO7zbhmWRGa+RLKNOnkgTARLAPFIs7XQqJeO0BwZQQIlCcT+fEaE/N5knFNH
         +k8zvcV0pb9hxTH6K0+0sdQcxJuqWjtmayiAqGrpgXSQ8Bi1Owo6bngOvacHf74x+B
         5FMxSA97Tpt9fLzMlidvtHLiHmwVUedWQOpb4p85Yv+FFEoe86MI0mjo9EcCcCm5il
         q3igt+5hxKenQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Sasha Levin <sashal@kernel.org>, tytso@mit.edu
Subject: [PATCH AUTOSEL 5.15 36/36] random: wake up /dev/random writers after zap
Date:   Wed,  9 Feb 2022 13:37:59 -0500
Message-Id: <20220209183759.47134-36-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209183759.47134-1-sashal@kernel.org>
References: <20220209183759.47134-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit 042e293e16e3aa9794ce60c29f5b7b0c8170f933 ]

When account() is called, and the amount of entropy dips below
random_write_wakeup_bits, we wake up the random writers, so that they
can write some more in. However, the RNDZAPENTCNT/RNDCLEARPOOL ioctl
sets the entropy count to zero -- a potential reduction just like
account() -- but does not unblock writers. This commit adds the missing
logic to that ioctl to unblock waiting writers.

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/random.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index a27ae3999ff32..ebe86de9d0acc 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1963,7 +1963,10 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 		 */
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
-		input_pool.entropy_count = 0;
+		if (xchg(&input_pool.entropy_count, 0) && random_write_wakeup_bits) {
+			wake_up_interruptible(&random_write_wait);
+			kill_fasync(&fasync, SIGIO, POLL_OUT);
+		}
 		return 0;
 	case RNDRESEEDCRNG:
 		if (!capable(CAP_SYS_ADMIN))
-- 
2.34.1

