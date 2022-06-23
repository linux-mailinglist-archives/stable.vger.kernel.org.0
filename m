Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B53955815A
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiFWQ7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232867AbiFWQ44 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:56:56 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D4A4B403;
        Thu, 23 Jun 2022 09:52:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 68FC0CE25E4;
        Thu, 23 Jun 2022 16:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3026DC341C5;
        Thu, 23 Jun 2022 16:52:54 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="i9UlvD98"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656003172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lc4+yA8sbbcfkz4YSh6TP9qWPcsqLq7aPfv9CPguNkY=;
        b=i9UlvD989T4ixKP4ugaWpbhIrTIFH6MqY2PD1AMkoUXtE0WItjhezIw8yr85xPoWjE47RP
        19lNtmVxEQAkFs9s/hz/Ed6aX3ynCl0nROaVUb2qXlL6TUvHnAjgHB381407R+zeOBozH2
        E9l1ocNoTBZR/eSQ3yXCo8pib+SoZ78=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 75d9cfc3 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 23 Jun 2022 16:52:51 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-crypto@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [PATCH] timekeeping: contribute wall clock to rng on time change
Date:   Thu, 23 Jun 2022 18:52:26 +0200
Message-Id: <20220623165226.1335679-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The rng's random_init() function contributes the real time to the rng at
boot time, so that events can at least start in relation to something
particular in the real world. But this clock might not yet be set that
point in boot, so nothing is contributed. In addition, the relation
between minor clock changes from, say, NTP, and the cycle counter is
potentially useful entropic data.

This commit addresses this by mixing in a time stamp on calls to
settimeofday and adjtimex. No entropy is credited in doing so, so it
doesn't make initialization faster, but it is still useful input to
have.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 kernel/time/timekeeping.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 8e4b3c32fcf9..ad55da792f13 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1346,6 +1346,9 @@ int do_settimeofday64(const struct timespec64 *ts)
 	if (!ret)
 		audit_tk_injoffset(ts_delta);
 
+	ktime_get_real_ts64(&xt);
+	add_device_randomness(&xt, sizeof(xt));
+
 	return ret;
 }
 EXPORT_SYMBOL(do_settimeofday64);
@@ -2475,6 +2478,9 @@ int do_adjtimex(struct __kernel_timex *txc)
 
 	ntp_notify_cmos_timer();
 
+	ktime_get_real_ts64(&ts);
+	add_device_randomness(&ts, sizeof(ts));
+
 	return ret;
 }
 
-- 
2.35.1

