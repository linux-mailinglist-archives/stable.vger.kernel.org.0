Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69B13A98BA
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 05:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731064AbfIEDHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 23:07:45 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36058 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729919AbfIEDHp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 23:07:45 -0400
Received: by mail-pf1-f194.google.com with SMTP id y22so758574pfr.3
        for <stable@vger.kernel.org>; Wed, 04 Sep 2019 20:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bv8aLyZNsRQTuIGo9WBDbNKWSEWFm7lp2gBa2Tmb/+Y=;
        b=dJ/kcZiLoIWOyyw6EfFPZeTXLsTZNg9iDTuBuXEqB+kjja/lH3LAkPeOLFJAsOWKCc
         C/z6F3GUxZ/IB7EDbx9Q1NptWBRZprPFMK5DtN2adq5zQx7CI500p6v2GhBCDewaN/05
         GM3lH33ZsVbgMrZZVG7Bp2m/1UrW4z8G9ztPyacNo9gFE1b5xSmhBxudlHqFKmPtOldy
         IoCm5mHDORE/jjJKkueXfSaUX72IOBNrHiwt63UBkSpiASgBZkMzI2rpreM5GrrxVkGa
         flKKFL1ofwgPuI9Ap/pt1WBEWqVlX4gFTOGVEeJUxSVIbk9YhecfTtoYN4CrlRp3uy9X
         h9ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bv8aLyZNsRQTuIGo9WBDbNKWSEWFm7lp2gBa2Tmb/+Y=;
        b=rq566btQ9/0KfVve+c1n7gexQRGvSXObFE4Rqpi7Um5Srze5Mg9Cb4WwyTpnLyNz0q
         G/zd9Np/EDtrqgd8RjRMaCXMBfu5EkBTkhPnpjFM4rGJtfL/CUrH1/qEZ+6WWKJKUR8Y
         r2E4yy7FlL1t7pAiSXifwW/NnhQ5yxVjho8gaAg0vZO0NTzbBYng829u3sI3yZTnrHg1
         J+06ppYw/h8b3SlvPBr5byWxj45M2vjipmYQTYr15OZ5o60iSZ79owKUYVnLU59xQuGT
         dflnHxpNmPN7KbP/W4NcbHk1poU1W0kGFb2wrIbIQ9NfKw/V3ODITeG+1WDKXEONMR5c
         QtcA==
X-Gm-Message-State: APjAAAVVNCtKQsWaydMDBIXtvWz4HpOlCOJBN6YNBU+kUw6XjckRAkPY
        mxntDQxMOEkGPWm+i3jNDVDNK9YPuWkqig==
X-Google-Smtp-Source: APXvYqyrb1FUlMJrBM7epNFloFgKYqsJf+HLa9tMPIRmvfvzIaUcesBgOzq7JDUpTYhk02fyisWnxg==
X-Received: by 2002:aa7:8d12:: with SMTP id j18mr1128275pfe.33.1567652864452;
        Wed, 04 Sep 2019 20:07:44 -0700 (PDT)
Received: from baolinwangubtpc.spreadtrum.com ([117.18.48.82])
        by smtp.gmail.com with ESMTPSA id x9sm425686pgp.75.2019.09.04.20.07.41
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 04 Sep 2019 20:07:43 -0700 (PDT)
From:   Baolin Wang <baolin.wang@linaro.org>
To:     stable@vger.kernel.org, peterz@infradead.org, mingo@redhat.com
Cc:     longman@redhat.com, arnd@arndb.de, baolin.wang@linaro.org,
        orsonzhai@gmail.com, vincent.guittot@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [BACKPORT 4.14.y v2 2/6] locking/lockdep: Add debug_locks check in __lock_downgrade()
Date:   Thu,  5 Sep 2019 11:07:14 +0800
Message-Id: <7d3d221015cd343df47de4a68ed4776aca2ca0ab.1567649729.git.baolin.wang@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1567649728.git.baolin.wang@linaro.org>
References: <cover.1567649728.git.baolin.wang@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[Upstream commit 513e1073d52e55b8024b4f238a48de7587c64ccf]

Tetsuo Handa had reported he saw an incorrect "downgrading a read lock"
warning right after a previous lockdep warning. It is likely that the
previous warning turned off lock debugging causing the lockdep to have
inconsistency states leading to the lock downgrade warning.

Fix that by add a check for debug_locks at the beginning of
__lock_downgrade().

Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Reported-by: syzbot+53383ae265fb161ef488@syzkaller.appspotmail.com
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Link: https://lkml.kernel.org/r/1547093005-26085-1-git-send-email-longman@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 kernel/locking/lockdep.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 565005a..5c370c6 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3650,6 +3650,9 @@ static int reacquire_held_locks(struct task_struct *curr, unsigned int depth,
 	unsigned int depth;
 	int i;
 
+	if (unlikely(!debug_locks))
+		return 0;
+
 	depth = curr->lockdep_depth;
 	/*
 	 * This function is about (re)setting the class of a held lock,
-- 
1.7.9.5

