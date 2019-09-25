Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB5EEBDB7F
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 11:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbfIYJxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 05:53:42 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37561 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730524AbfIYJxk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Sep 2019 05:53:40 -0400
Received: by mail-pf1-f194.google.com with SMTP id y5so3085335pfo.4
        for <stable@vger.kernel.org>; Wed, 25 Sep 2019 02:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=D6PfaOSiK5wWk46TCo3+Vx3pnanuAKuyWAXUeX0igJw=;
        b=lBYt+7KM1phKd/Mg67rR70qFXk2fx7VgIHTfyDK91GSNr5+6CQr8bQQ8hg1pR0ghSQ
         diNdvPjQuTEZKaYUFJDoVmaAHayHS5MvLuFY41wN5GYGxJ9Pv+vWBnifx+bbo+H+tybk
         Wkr1cUhcOEX9ry9+GkXxBMN43P2uS599c3QQY9kXnOtsolhtsp4K/lpktiWOUy29grOv
         scjYue4zUnGohWsIl5saJX7Qe0dNfkgKFqbtnkgdJSxph/T0pG9kIlYfvFqLkVouEkWi
         ysHoDOujZOGOpOE3V1A8LL4rAqDj8GG+pb90xKe+Ms9qcDWM2AJGzxAArEKGb89rkdUD
         VCyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=D6PfaOSiK5wWk46TCo3+Vx3pnanuAKuyWAXUeX0igJw=;
        b=kSJeUY0kgy+YkjrGyK6V/NIm5O7s0CkGkUPxQ+Fpjb1mVv5eGi9H3gv5iP5ANCIoCv
         UWiprNm/Q5a75PMMI0M2tOuHQ+8n9smVv5OQwfgYnWcs49ojbRJKXd6yvdAugsHFLStW
         8wkf3FQDIyc3QJ3sHHfAvz6G3Hyl3rGQLFR+Bt3hlFrGNgDedf4EPIb9JsFdbAthml17
         v4YLbgsIT1KCUg3NDQoQzG9Oj6U2zJS4USti9+/VkDoHlWOa6aSiv/sAbu7jcy0fW7Xl
         JBTHMh1WXh3K2hLm/JvrbFZSMLBzByWj8E+30TQXI05TEt1e3KiOQzaq2xn4WXRgTpu+
         nQtQ==
X-Gm-Message-State: APjAAAVl1wbUdystpNORxHxPea8589121pkPm641gsHs0CL0XBsNyL4z
        gswGkllRoc/7tsHlj6pio9EsKXU6WyJWLw==
X-Google-Smtp-Source: APXvYqxbVjV5AmvZqut4T5QmI3bPQX3yF5rfLsFCtqvBpMj+7SH3qabraNlwOSv6MDthH4WDd9C+vA==
X-Received: by 2002:aa7:8bcc:: with SMTP id s12mr8722557pfd.93.1569405219091;
        Wed, 25 Sep 2019 02:53:39 -0700 (PDT)
Received: from baolinwangubtpc.spreadtrum.com ([117.18.48.82])
        by smtp.gmail.com with ESMTPSA id 197sm5054282pge.39.2019.09.25.02.53.35
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 25 Sep 2019 02:53:38 -0700 (PDT)
From:   Baolin Wang <baolin.wang@linaro.org>
To:     stable@vger.kernel.org, peterz@infradead.org, mingo@redhat.com
Cc:     longman@redhat.com, arnd@arndb.de, baolin.wang@linaro.org,
        orsonzhai@gmail.com, vincent.guittot@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [BACKPORT 4.19.y 1/3] locking/lockdep: Add debug_locks check in __lock_downgrade()
Date:   Wed, 25 Sep 2019 17:53:12 +0800
Message-Id: <ee8b45ecc3060ea0e00ba8015dcd6073496ceb6d.1569404757.git.baolin.wang@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1569404757.git.baolin.wang@linaro.org>
References: <cover.1569404757.git.baolin.wang@linaro.org>
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
index e810e8c..1e272f6 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3605,6 +3605,9 @@ static int __lock_downgrade(struct lockdep_map *lock, unsigned long ip)
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

