Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D242C13B28D
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 20:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgANTD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 14:03:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28334 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726053AbgANTDZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 14:03:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579028604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=jy6AijxJ55wWFabYljRF3pNlKGJ/aiUdxGzD9Bf9mNg=;
        b=ZpX1kLj5As+VOJrC0cal2qJ7ifI95K2pTrMPsmvZYCcFzQIdLzdeTthaclYq/16QfGbtcw
        Ku882YGV/Vc0ZBg2Or6LL6jMWCgCUaGbwblG8iUJ1gOU9JhySY4ogd+qTMl5LL/cfI1dvY
        zW3XhpUgjH9ZYvo9RuXfbaAOpGR6dPU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-hYl4xuRHM42uQRHtahVQQA-1; Tue, 14 Jan 2020 14:03:23 -0500
X-MC-Unique: hYl4xuRHM42uQRHtahVQQA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1AAB8802B93;
        Tue, 14 Jan 2020 19:03:22 +0000 (UTC)
Received: from llong.com (ovpn-122-218.rdu2.redhat.com [10.10.122.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCB1E5DA32;
        Tue, 14 Jan 2020 19:03:18 +0000 (UTC)
From:   Waiman Long <longman@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Will Deacon <will.deacon@arm.com>
Cc:     linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>
Subject: [PATCH] locking/rwsem: Fix kernel crash when spinning on RWSEM_OWNER_UNKNOWN
Date:   Tue, 14 Jan 2020 14:03:03 -0500
Message-Id: <20200114190303.5778-1-longman@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The commit 91d2a812dfb9 ("locking/rwsem: Make handoff writer
optimistically spin on owner") will allow a recently woken up waiting
writer to spin on the owner. Unfortunately, if the owner happens to be
RWSEM_OWNER_UNKNOWN, the code will incorrectly spin on it leading to a
kernel crash. This is fixed by passing the proper non-spinnable bits
to rwsem_spin_on_owner() so that RWSEM_OWNER_UNKNOWN will be treated
as a non-spinnable target.

Fixes: 91d2a812dfb9 ("locking/rwsem: Make handoff writer optimistically spin on owner")

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/locking/rwsem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 44e68761f432..1dd3d53f43c3 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1227,7 +1227,7 @@ rwsem_down_write_slowpath(struct rw_semaphore *sem, int state)
 		 * without sleeping.
 		 */
 		if ((wstate == WRITER_HANDOFF) &&
-		    (rwsem_spin_on_owner(sem, 0) == OWNER_NULL))
+		    rwsem_spin_on_owner(sem, RWSEM_NONSPINNABLE) == OWNER_NULL)
 			goto trylock_again;
 
 		/* Block until there are no active lockers. */
-- 
2.18.1

