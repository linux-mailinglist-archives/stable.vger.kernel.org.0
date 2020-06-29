Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E54820E84E
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388198AbgF2WFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:05:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgF2SfT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11381247BB;
        Mon, 29 Jun 2020 15:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444120;
        bh=Fo58XYYbLg0fR3AnA2QeKF2c5Xegrf9NXglg4qyGSC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QQfsjHEp8luhvfypCXXlcjytwztzMcm0KfId9l1dhjl45CmRKg5dEV8nT6AIfnOJB
         NpjN/fNVv3NaQEehMC55b2xLv22LKes8nofvHY9ACoaEsFIQImPH7+k8NI0LqYha9Y
         k5oM4nhBARToeYZw4NXhZz965kP07Eg3gfTDfzVE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Waiman Long <longman@redhat.com>, Michal Hocko <mhocko@suse.com>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Joe Perches <joe@perches.com>,
        Matthew Wilcox <willy@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 230/265] mm/slab: use memzero_explicit() in kzfree()
Date:   Mon, 29 Jun 2020 11:17:43 -0400
Message-Id: <20200629151818.2493727-231-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

commit 8982ae527fbef170ef298650c15d55a9ccd33973 upstream.

The kzfree() function is normally used to clear some sensitive
information, like encryption keys, in the buffer before freeing it back to
the pool.  Memset() is currently used for buffer clearing.  However
unlikely, there is still a non-zero probability that the compiler may
choose to optimize away the memory clearing especially if LTO is being
used in the future.

To make sure that this optimization will never happen,
memzero_explicit(), which is introduced in v3.18, is now used in
kzfree() to future-proof it.

Link: http://lkml.kernel.org/r/20200616154311.12314-2-longman@redhat.com
Fixes: 3ef0e5ba4673 ("slab: introduce kzfree()")
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Joe Perches <joe@perches.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slab_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 9e72ba2241750..37d48a56431d0 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1726,7 +1726,7 @@ void kzfree(const void *p)
 	if (unlikely(ZERO_OR_NULL_PTR(mem)))
 		return;
 	ks = ksize(mem);
-	memset(mem, 0, ks);
+	memzero_explicit(mem, ks);
 	kfree(mem);
 }
 EXPORT_SYMBOL(kzfree);
-- 
2.25.1

