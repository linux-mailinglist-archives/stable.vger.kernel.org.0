Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 141824BE573
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351715AbiBUJuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:50:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352375AbiBUJrY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:47:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BE3424A3;
        Mon, 21 Feb 2022 01:19:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C567960F46;
        Mon, 21 Feb 2022 09:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC52FC340E9;
        Mon, 21 Feb 2022 09:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435176;
        bh=tn9KiBfIResCyFFjyiBMQXV3QP7d83OBpO7pCS0v74M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RbyAfB83apnkOCwvtIUnaQzWbJDxymuaZ0aiUFDtmMXKQ9Wd4U01/2afQnPhUfPng
         SGx3gZy6rpB8wwXlg3F98s9LB0sMY5125wha2T9APaPzBTI62PNp0dNgbeHcII4F8R
         0Lynwn/2/kdHpeQ4IJP+HxZpKIluFN0d+HeQH82E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 070/227] random: wake up /dev/random writers after zap
Date:   Mon, 21 Feb 2022 09:48:09 +0100
Message-Id: <20220221084937.205361841@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Jason A. Donenfeld <Jason@zx2c4.com>

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



