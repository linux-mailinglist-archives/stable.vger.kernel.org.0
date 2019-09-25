Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00115BDBAC
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 12:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387619AbfIYKB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 06:01:56 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34782 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387523AbfIYKB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Sep 2019 06:01:56 -0400
Received: by mail-pg1-f194.google.com with SMTP id y35so2939607pgl.1
        for <stable@vger.kernel.org>; Wed, 25 Sep 2019 03:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bv8aLyZNsRQTuIGo9WBDbNKWSEWFm7lp2gBa2Tmb/+Y=;
        b=fgZbG64IXUHsvM7TRcuP1teXZYFqfqW0l7SKxCbGRJ2bNJ7G8EpFcfSrax7r7CdozP
         BXABVYGo2CR6D7Kkw4DVVdg474IKzw+R/pjsSnecWmnrGWxcJIMEYZ/++gMw9Idhwayu
         KCu7xK+zUn8yzhG++1aJwt2wXHOFVUz8LaagufwcDMk+08VxWMdzBibttTcqMYfRFoK+
         rS/LwlpKsMDnOodWs+bKhJf6aKTdIapjDcd/xKx8DoXFGOZncOcYpM8kybdG8Qve6P41
         j1jqedeNLtUzS/caYff3jb/HZHZj/vdy4Z9vKf31CSU1jaih7Ergo6ZtzgZlJ0Ima141
         GGTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bv8aLyZNsRQTuIGo9WBDbNKWSEWFm7lp2gBa2Tmb/+Y=;
        b=JuEqOuTYMANU/kb2WYps2igKGVH/MDoNkPEBl2k3NO8k82///RUO3mZwbF9cJdMYtF
         AJwkfobZxUOOnxYNiUyxoQxnbus6oAk2MAG81S8kuCkObvC/tEAcEigb0kW4EbQEMYi8
         lYwCWw/OOrPCs9Y5U85J6Ep4HSyWazdpQCPxKlK9389yMBP4v2Ito81tx/KcKhN4DsTb
         D0MwmQ1wqc5x3TlGaqXswHWxAThBDXYMQvVAUyGzijy8reXrgdZ+NIxDGu8RJz7XKz18
         ZHFQ8bkLg5jZGgW+0SpZ1LIxBTHuyHpZOBOL0/C7f8dfxXvMuF5HFdfo+by6+tc06GCr
         kRgg==
X-Gm-Message-State: APjAAAVKYTfgUQSuUO0y3KGiwCulgMWODyTnRqHLD4Arp34A2reXYIcC
        ixTAu07os7QwSe8An50Xf8iTwO9HJ7lpaA==
X-Google-Smtp-Source: APXvYqz1ZgFQDN16xAbbsdfj62tKetgZ9mscXJAIscYubJyORuZLYzLchR9KEqqZ2QP5ApzRZjofFQ==
X-Received: by 2002:a62:7710:: with SMTP id s16mr8743537pfc.139.1569405715384;
        Wed, 25 Sep 2019 03:01:55 -0700 (PDT)
Received: from baolinwangubtpc.spreadtrum.com ([117.18.48.82])
        by smtp.gmail.com with ESMTPSA id l6sm3847418pje.28.2019.09.25.03.01.52
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 25 Sep 2019 03:01:54 -0700 (PDT)
From:   Baolin Wang <baolin.wang@linaro.org>
To:     stable@vger.kernel.org, peterz@infradead.org, mingo@redhat.com
Cc:     longman@redhat.com, arnd@arndb.de, baolin.wang@linaro.org,
        orsonzhai@gmail.com, vincent.guittot@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [BACKPORT 4.14.y v3 1/3] locking/lockdep: Add debug_locks check in __lock_downgrade()
Date:   Wed, 25 Sep 2019 18:01:36 +0800
Message-Id: <4ac2e84637ceaf5ec67cfc11ad58c489778693a8.1569405445.git.baolin.wang@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1569405445.git.baolin.wang@linaro.org>
References: <cover.1569405445.git.baolin.wang@linaro.org>
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

