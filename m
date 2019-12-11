Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0BB11B26F
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387687AbfLKPgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:36:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:45330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733101AbfLKPf4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:35:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 376C52464B;
        Wed, 11 Dec 2019 15:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078556;
        bh=dIfCz3Zt8PohvxBeJBhWjWv+5k+mpJwXkU+kG+LB/LA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1e/J80Nd9RpM8lLA5qmyuZkc0N3RB/DGiQONXnef4ay88+DanFiVY7gwRdbkUOIZx
         NZ86XjKVAE1kWDd9ELP5SkyR4xuF7MlU2YHg0yTEEDVzYj2auTa+XvVnJJwkdA37XQ
         kvHs3Jqj/13345/5nrH+Lv4ysnuZWFJVTQtnILoA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Chris Down <chris@chrisdown.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 42/42] kernel: sysctl: make drop_caches write-only
Date:   Wed, 11 Dec 2019 10:35:10 -0500
Message-Id: <20191211153510.23861-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211153510.23861-1-sashal@kernel.org>
References: <20191211153510.23861-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

[ Upstream commit 204cb79ad42f015312a5bbd7012d09c93d9b46fb ]

Currently, the drop_caches proc file and sysctl read back the last value
written, suggesting this is somehow a stateful setting instead of a
one-time command.  Make it write-only, like e.g.  compact_memory.

While mitigating a VM problem at scale in our fleet, there was confusion
about whether writing to this file will permanently switch the kernel into
a non-caching mode.  This influences the decision making in a tense
situation, where tens of people are trying to fix tens of thousands of
affected machines: Do we need a rollback strategy?  What are the
performance implications of operating in a non-caching state for several
days?  It also caused confusion when the kernel team said we may need to
write the file several times to make sure it's effective ("But it already
reads back 3?").

Link: http://lkml.kernel.org/r/20191031221602.9375-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sysctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 6af1ac551ea3a..34449ec0689d0 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1398,7 +1398,7 @@ static struct ctl_table vm_table[] = {
 		.procname	= "drop_caches",
 		.data		= &sysctl_drop_caches,
 		.maxlen		= sizeof(int),
-		.mode		= 0644,
+		.mode		= 0200,
 		.proc_handler	= drop_caches_sysctl_handler,
 		.extra1		= &one,
 		.extra2		= &four,
-- 
2.20.1

