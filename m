Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B53AC13EB83
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394323AbgAPRuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:50:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:38164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406531AbgAPRpw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:45:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3717246A7;
        Thu, 16 Jan 2020 17:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196751;
        bh=NH7YmaENed7733PiOVCPiTH7DV/SfeLsD2y7DmbM7Ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bc35I8PM30FnKztSBDxfYPmzHG5MG1SLjU9D5o3ir8lzPupNzP2vV6NVoTUAcbcso
         M7fWiFSFDbKSCfYZIPX6HkQD9/515vBEcjEzJkJr6Qd1ynrpWz9fp/G1xuDR3rsq6r
         rd0wSA2ufUvxiQDi3nKlIS0BobL33Z8mckyTCBAE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        laokz <laokz@foxmail.com>, Stefani Seibold <stefani@seibold.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <greg@kroah.com>, Kees Cook <keescook@chromium.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 128/174] Partially revert "kfifo: fix kfifo_alloc() and kfifo_init()"
Date:   Thu, 16 Jan 2020 12:42:05 -0500
Message-Id: <20200116174251.24326-128-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit ab9bb6318b0967671e0c9b6537c1537d51ca4f45 ]

Commit dfe2a77fd243 ("kfifo: fix kfifo_alloc() and kfifo_init()") made
the kfifo code round the number of elements up.  That was good for
__kfifo_alloc(), but it's actually wrong for __kfifo_init().

The difference? __kfifo_alloc() will allocate the rounded-up number of
elements, but __kfifo_init() uses an allocation done by the caller.  We
can't just say "use more elements than the caller allocated", and have
to round down.

The good news? All the normal cases will be using power-of-two arrays
anyway, and most users of kfifo's don't use kfifo_init() at all, but one
of the helper macros to declare a KFIFO that enforce the proper
power-of-two behavior.  But it looks like at least ibmvscsis might be
affected.

The bad news? Will Deacon refers to an old thread and points points out
that the memory ordering in kfifo's is questionable.  See

  https://lore.kernel.org/lkml/20181211034032.32338-1-yuleixzhang@tencent.com/

for more.

Fixes: dfe2a77fd243 ("kfifo: fix kfifo_alloc() and kfifo_init()")
Reported-by: laokz <laokz@foxmail.com>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kfifo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/kfifo.c b/lib/kfifo.c
index 90ba1eb1df06..a94227c55551 100644
--- a/lib/kfifo.c
+++ b/lib/kfifo.c
@@ -82,7 +82,8 @@ int __kfifo_init(struct __kfifo *fifo, void *buffer,
 {
 	size /= esize;
 
-	size = roundup_pow_of_two(size);
+	if (!is_power_of_2(size))
+		size = rounddown_pow_of_two(size);
 
 	fifo->in = 0;
 	fifo->out = 0;
-- 
2.20.1

