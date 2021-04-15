Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37902360BC2
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbhDOO0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:26:46 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:8912 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbhDOO0p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 10:26:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1618496783; x=1650032783;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IYYHQjQUEYAY07onLm8+SW69KoZR6LGzsTny098YXCM=;
  b=pkywBVSSCtzez1EwimJgHNgqqyUseCYCUr2FgrOofQdfsBYBpZUSHMZY
   J/0rss4MsxurG6wYT2euQxNcZNwY2GOHQftiy2epJ+3pCB38pU0yKlDJQ
   okTstUqtUdYQgkJR3crt7VSL8y5sgHpeEjjBVgWdYuJxj+K7Xic3vnokG
   Q=;
X-IronPort-AV: E=Sophos;i="5.82,225,1613433600"; 
   d="scan'208";a="107687805"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 15 Apr 2021 14:26:22 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-303d0b0e.us-east-1.amazon.com (Postfix) with ESMTPS id C7BC0A1E7F;
        Thu, 15 Apr 2021 14:26:18 +0000 (UTC)
Received: from EX13D02UWB002.ant.amazon.com (10.43.161.160) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 15 Apr 2021 14:26:17 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D02UWB002.ant.amazon.com (10.43.161.160) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 15 Apr 2021 14:26:17 +0000
Received: from dev-dsk-alisaidi-i31e-9f3421fe.us-east-1.amazon.com
 (10.200.138.153) by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP
 Server id 15.0.1497.2 via Frontend Transport; Thu, 15 Apr 2021 14:26:17 +0000
Received: by dev-dsk-alisaidi-i31e-9f3421fe.us-east-1.amazon.com (Postfix, from userid 5131138)
        id 65A02228E4; Thu, 15 Apr 2021 14:26:17 +0000 (UTC)
From:   Ali Saidi <alisaidi@amazon.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <alisaidi@amazon.com>, <catalin.marinas@arm.com>,
        <steve.capper@arm.com>, <benh@kernel.crashing.org>,
        <stable@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: [PATCH] locking/qrwlock: Fix ordering in queued_write_lock_slowpath
Date:   Thu, 15 Apr 2021 14:25:52 +0000
Message-ID: <20210415142552.30916-1-alisaidi@amazon.com>
X-Mailer: git-send-email 2.24.4.AMZN
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While this code is executed with the wait_lock held, a reader can
acquire the lock without holding wait_lock.  The writer side loops
checking the value with the atomic_cond_read_acquire(), but only truly
acquires the lock when the compare-and-exchange is completed
successfully which isn’t ordered. The other atomic operations from this
point are release-ordered and thus reads after the lock acquisition can
be completed before the lock is truly acquired which violates the
guarantees the lock should be making.

Fixes: b519b56e378ee ("locking/qrwlock: Use atomic_cond_read_acquire() when spinning in qrwloc")
Signed-off-by: Ali Saidi <alisaidi@amazon.com>
Cc: stable@vger.kernel.org
---
 kernel/locking/qrwlock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/qrwlock.c b/kernel/locking/qrwlock.c
index 4786dd271b45..10770f6ac4d9 100644
--- a/kernel/locking/qrwlock.c
+++ b/kernel/locking/qrwlock.c
@@ -73,8 +73,8 @@ void queued_write_lock_slowpath(struct qrwlock *lock)
 
 	/* When no more readers or writers, set the locked flag */
 	do {
-		atomic_cond_read_acquire(&lock->cnts, VAL == _QW_WAITING);
-	} while (atomic_cmpxchg_relaxed(&lock->cnts, _QW_WAITING,
+		atomic_cond_read_relaxed(&lock->cnts, VAL == _QW_WAITING);
+	} while (atomic_cmpxchg_acquire(&lock->cnts, _QW_WAITING,
 					_QW_LOCKED) != _QW_WAITING);
 unlock:
 	arch_spin_unlock(&lock->wait_lock);
-- 
2.24.4.AMZN

