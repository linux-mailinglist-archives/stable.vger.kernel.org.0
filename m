Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80BC2169329
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 03:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbgBWCVk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 21:21:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:50090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727584AbgBWCVk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Feb 2020 21:21:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F23E3214DB;
        Sun, 23 Feb 2020 02:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424499;
        bh=DlmwdQDlQ9+dL/5tK1OOSNXQg1vVFb3H4mk64k4cgLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d/wiWVxhT2D5Kpk8Pxkc8zwYBZaZsKY9DMopvXnX6xKznxw9/g85+6Cx9L0iChyge
         +lcsqQz0aJlMCABR4yJCQNF8XGeNc2Vj/K5Umj2zGCyWxuyL/3En45dzbwZOQM7vqD
         agb6TOXBzGKuv6TFei//1+/txFRQE8GKGNHs75V8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suren Baghdasaryan <surenb@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.5 16/58] sched/psi: Fix OOB write when writing 0 bytes to PSI files
Date:   Sat, 22 Feb 2020 21:20:37 -0500
Message-Id: <20200223022119.707-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022119.707-1-sashal@kernel.org>
References: <20200223022119.707-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suren Baghdasaryan <surenb@google.com>

[ Upstream commit 6fcca0fa48118e6d63733eb4644c6cd880c15b8f ]

Issuing write() with count parameter set to 0 on any file under
/proc/pressure/ will cause an OOB write because of the access to
buf[buf_size-1] when NUL-termination is performed. Fix this by checking
for buf_size to be non-zero.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Link: https://lkml.kernel.org/r/20200203212216.7076-1-surenb@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/psi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index ce8f6748678a2..9154e745f0978 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1199,6 +1199,9 @@ static ssize_t psi_write(struct file *file, const char __user *user_buf,
 	if (static_branch_likely(&psi_disabled))
 		return -EOPNOTSUPP;
 
+	if (!nbytes)
+		return -EINVAL;
+
 	buf_size = min(nbytes, sizeof(buf));
 	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
-- 
2.20.1

