Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52CF726EDAF
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgIRCWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:22:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729481AbgIRCRC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:17:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FECC235F7;
        Fri, 18 Sep 2020 02:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395421;
        bh=XucjYxT23gDFq10RI6iHaJ6MMhwQHTgnQ83PmElYOTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2k6YMMNnWWhjKAfFWKOxamJSUBi7ZgmtZh4uaarMrX9HNp973Omn6U2NIKjPDfcYz
         ZEzCfjyBIkqfdRbJud7wJIJzSnse0aojqI7zFRLsQeAA1Iy0F9JQ7WTJU/4JmT6z83
         A11Ubh95np4SobKWSWlpUW5a1DvqN0ECtRsfKaGE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Elver <elver@google.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 15/64] seqlock: Require WRITE_ONCE surrounding raw_seqcount_barrier
Date:   Thu, 17 Sep 2020 22:15:54 -0400
Message-Id: <20200918021643.2067895-15-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021643.2067895-1-sashal@kernel.org>
References: <20200918021643.2067895-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index e0582106ef4fa..a10f363784178 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -242,6 +242,13 @@ static inline void raw_write_seqcount_end(seqcount_t *s)
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
@@ -261,11 +268,11 @@ static inline void raw_write_seqcount_end(seqcount_t *s)
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

