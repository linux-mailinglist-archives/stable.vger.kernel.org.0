Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4372427CCFA
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733246AbgI2Mkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:40:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729401AbgI2LOP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:14:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C3DB221EC;
        Tue, 29 Sep 2020 11:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378054;
        bh=Tp7YaKR66qnz472Pvf8IC6ILZsObjrxW4B9MHocF3Bg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1r6RYZJZ5XXdqXjNcN1oZIWzs8ee4JIiml+50CKS82ndwXKscnl5CFTd+1ixShxL1
         GJNMjNdGKQDTa6Vri3OSBapbjdPUtCoFtrDdt3vU2tBj0Fk8tkUVm/Jotrv828+Ebr
         BFbdTgPV3zwxQaPQdQNHVaHVq8l0AFnx70ZPA7dY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Elver <elver@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 045/166] seqlock: Require WRITE_ONCE surrounding raw_seqcount_barrier
Date:   Tue, 29 Sep 2020 12:59:17 +0200
Message-Id: <20200929105937.456046687@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

[ Upstream commit bf07132f96d426bcbf2098227fb680915cf44498 ]

This patch proposes to require marked atomic accesses surrounding
raw_write_seqcount_barrier. We reason that otherwise there is no way to
guarantee propagation nor atomicity of writes before/after the barrier
[1]. For example, consider the compiler tears stores either before or
after the barrier; in this case, readers may observe a partial value,
and because readers are unaware that writes are going on (writes are not
in a seq-writer critical section), will complete the seq-reader critical
section while having observed some partial state.
[1] https://lwn.net/Articles/793253/

This came up when designing and implementing KCSAN, because KCSAN would
flag these accesses as data-races. After careful analysis, our reasoning
as above led us to conclude that the best thing to do is to propose an
amendment to the raw_seqcount_barrier usage.

Signed-off-by: Marco Elver <elver@google.com>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/seqlock.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index f189a8a3bbb88..7b3b5d05ab0de 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -243,6 +243,13 @@ static inline void raw_write_seqcount_end(seqcount_t *s)
  * usual consistency guarantee. It is one wmb cheaper, because we can
  * collapse the two back-to-back wmb()s.
  *
+ * Note that, writes surrounding the barrier should be declared atomic (e.g.
+ * via WRITE_ONCE): a) to ensure the writes become visible to other threads
+ * atomically, avoiding compiler optimizations; b) to document which writes are
+ * meant to propagate to the reader critical section. This is necessary because
+ * neither writes before and after the barrier are enclosed in a seq-writer
+ * critical section that would ensure readers are aware of ongoing writes.
+ *
  *      seqcount_t seq;
  *      bool X = true, Y = false;
  *
@@ -262,11 +269,11 @@ static inline void raw_write_seqcount_end(seqcount_t *s)
  *
  *      void write(void)
  *      {
- *              Y = true;
+ *              WRITE_ONCE(Y, true);
  *
  *              raw_write_seqcount_barrier(seq);
  *
- *              X = false;
+ *              WRITE_ONCE(X, false);
  *      }
  */
 static inline void raw_write_seqcount_barrier(seqcount_t *s)
-- 
2.25.1



