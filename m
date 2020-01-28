Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E424914BA07
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgA1Oey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:34:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:49884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731316AbgA1OXi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:23:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA9C62071E;
        Tue, 28 Jan 2020 14:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221418;
        bh=8WJOEl1qWNSyxzfiwg8ltidaByHuIaW8yhNEakVLz/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ljb+Hrrp6LFiOlhLBFMkusFfSV/iMhh6n7vV3r1owc5aJ18IVGzhfLzrKG4j/+l6U
         qK5EQ5rctmVpl0BoWTEyhvBSZG4ubK6mSSsX0bSmus2nDbniRdZAcwUiTMUfykvljD
         Scx7ggzeRRRWwpF77pkjUjVcX7q1LtBGAED2PeHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, laokz <laokz@foxmail.com>,
        Stefani Seibold <stefani@seibold.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <greg@kroah.com>, Kees Cook <keescook@chromium.org>,
        Will Deacon <will@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 189/271] Partially revert "kfifo: fix kfifo_alloc() and kfifo_init()"
Date:   Tue, 28 Jan 2020 15:05:38 +0100
Message-Id: <20200128135906.639868056@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 90ba1eb1df06e..a94227c555510 100644
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



