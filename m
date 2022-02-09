Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4724AFB60
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240581AbiBISpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240639AbiBISpS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:45:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C407C014F38;
        Wed,  9 Feb 2022 10:43:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2291D60AF2;
        Wed,  9 Feb 2022 18:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB52BC340EE;
        Wed,  9 Feb 2022 18:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644432180;
        bh=Hoe3hbDIhOIeCzH4DhlqDkPDZL1ybNeNyJFFty6aEqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oNKEWpjpcGaTgEYuWsTsUodZTITewLgCDFYZ7J86cMW95RvoosYO8NhugDxirIUQ0
         FWQtHWLyrmraac1mkUefjhb2GFVbjqYSDPybUpKj0Fpiq8i1buIByNAjX0eDNPJcoL
         dUoK0LsqUvJwhS6a3DSwSgsH92b770rYbs71cTvZxfWAZIhYvN5HdwaxJKGpPyaUih
         74ruyxNFXCjKY1JLb7uetoXg1o1ZNjyv/ig6B1PUgJb64N3G8iNH+ye0uvnGgcZAE3
         aeZ7RaO738kZ6W4LMR3bqHMnUscB9AGv2Dr05TCEEQxL8znbMUKbhQrvMJ+/miBZnz
         kq4f4eHg/wCSA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Sasha Levin <sashal@kernel.org>, tytso@mit.edu
Subject: [PATCH AUTOSEL 5.10 27/27] random: wake up /dev/random writers after zap
Date:   Wed,  9 Feb 2022 13:41:03 -0500
Message-Id: <20220209184103.47635-27-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209184103.47635-1-sashal@kernel.org>
References: <20220209184103.47635-1-sashal@kernel.org>
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
index 5444206f35e22..5f541c9465598 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1987,7 +1987,10 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
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

