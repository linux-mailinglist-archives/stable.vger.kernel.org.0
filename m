Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D101DC3C6A
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 18:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729445AbfJAQvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:51:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733194AbfJAQoH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:44:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C46F2190F;
        Tue,  1 Oct 2019 16:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948246;
        bh=X3S8WQ7UT0+IkdAe8bBvvWbrx78vCKcUbqkRwP0+dPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CAhyeW6C2ERsXdRg96YOvDY0h9G6drhtS7Xb2yy557GcB8NZGyrzyGdRMJXkdmaxZ
         1zdgyPIbeZvoX7TWLp1x9h/hzNq48ijO8oIl4kL5ncUwOi2rK+t2NxjKYu0aQEKzjN
         tdTX6N4zIWB1H9JQ2dVv+JCOCxSu3yPJ6Nb1yGTg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        syzbot <syzbot+8ab2d0f39fb79fe6ca40@syzkaller.appspotmail.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, kexec@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 36/43] kexec: bail out upon SIGKILL when allocating memory.
Date:   Tue,  1 Oct 2019 12:43:04 -0400
Message-Id: <20191001164311.15993-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164311.15993-1-sashal@kernel.org>
References: <20191001164311.15993-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 7c3a6aedcd6aae0a32a527e68669f7dd667492d1 ]

syzbot found that a thread can stall for minutes inside kexec_load() after
that thread was killed by SIGKILL [1].  It turned out that the reproducer
was trying to allocate 2408MB of memory using kimage_alloc_page() from
kimage_load_normal_segment().  Let's check for SIGKILL before doing memory
allocation.

[1] https://syzkaller.appspot.com/bug?id=a0e3436829698d5824231251fad9d8e998f94f5e

Link: http://lkml.kernel.org/r/993c9185-d324-2640-d061-bed2dd18b1f7@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: syzbot <syzbot+8ab2d0f39fb79fe6ca40@syzkaller.appspotmail.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kexec_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index 23a83a4da38a1..f50b90d0d1c28 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -301,6 +301,8 @@ static struct page *kimage_alloc_pages(gfp_t gfp_mask, unsigned int order)
 {
 	struct page *pages;
 
+	if (fatal_signal_pending(current))
+		return NULL;
 	pages = alloc_pages(gfp_mask & ~__GFP_ZERO, order);
 	if (pages) {
 		unsigned int count, i;
-- 
2.20.1

