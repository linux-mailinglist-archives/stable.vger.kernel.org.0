Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14403145532
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbgAVNTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:19:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:35656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728811AbgAVNTl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:19:41 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE3A62467E;
        Wed, 22 Jan 2020 13:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699180;
        bh=gmGK9lkkptqNYlJQsr4NkvPPXlub+fNWnEWdTp6g9Gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fgrJwao8olqlDMXBKaCdaBt9khykdLigSkIWDWx96U1zLmHACW4pBLXPNIKfYHZ7t
         o2eU2ZAjFu88gJFVoKkqwjrfgJNDTSat6uoS8Uqxcuprgej7ShP0cpBFWxCgUCxJOH
         I7PFLc8WJh4oV0o68AWVTVTI50JBDKPoPZjmM89Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Waiman Long <longman@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 064/222] locking/rwsem: Fix kernel crash when spinning on RWSEM_OWNER_UNKNOWN
Date:   Wed, 22 Jan 2020 10:27:30 +0100
Message-Id: <20200122092838.302318765@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

commit 39e7234f00bc93613c086ae42d852d5f4147120a upstream.

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
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200115154336.8679-1-longman@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/locking/rwsem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1226,8 +1226,8 @@ wait:
 		 * In this case, we attempt to acquire the lock again
 		 * without sleeping.
 		 */
-		if ((wstate == WRITER_HANDOFF) &&
-		    (rwsem_spin_on_owner(sem, 0) == OWNER_NULL))
+		if (wstate == WRITER_HANDOFF &&
+		    rwsem_spin_on_owner(sem, RWSEM_NONSPINNABLE) == OWNER_NULL)
 			goto trylock_again;
 
 		/* Block until there are no active lockers. */


