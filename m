Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2731B7A95
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 17:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgDXPtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 11:49:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56256 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728110AbgDXPtj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 11:49:39 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jS0a8-0001hQ-NZ; Fri, 24 Apr 2020 16:49:36 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jS0a8-00FNGT-3o; Fri, 24 Apr 2020 16:49:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Rong Chen" <rong.a.chen@intel.com>, "Jann Horn" <jannh@google.com>
Date:   Fri, 24 Apr 2020 16:51:32 +0100
Message-ID: <lsq.1587743246.627531935@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 247/247] futex: Unbreak futex hashing
In-Reply-To: <lsq.1587743245.5555628@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc2 review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 8d67743653dce5a0e7aa500fcccb237cde7ad88e upstream.

The recent futex inode life time fix changed the ordering of the futex key
union struct members, but forgot to adjust the hash function accordingly,

As a result the hashing omits the leading 64bit and even hashes beyond the
futex key causing a bad hash distribution which led to a ~100% performance
regression.

Hand in the futex key pointer instead of a random struct member and make
the size calculation based of the struct offset.

Fixes: 8019ad13ef7f ("futex: Fix inode life-time issue")
Reported-by: Rong Chen <rong.a.chen@intel.com>
Decoded-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Rong Chen <rong.a.chen@intel.com>
Link: https://lkml.kernel.org/r/87h7yy90ve.fsf@nanos.tec.linutronix.de
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Jann Horn <jannh@google.com>
---
 kernel/futex.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -309,9 +309,9 @@ static inline int hb_waiters_pending(str
  */
 static struct futex_hash_bucket *hash_futex(union futex_key *key)
 {
-	u32 hash = jhash2((u32*)&key->both.word,
-			  (sizeof(key->both.word)+sizeof(key->both.ptr))/4,
+	u32 hash = jhash2((u32 *)key, offsetof(typeof(*key), both.offset) / 4,
 			  key->both.offset);
+
 	return &futex_queues[hash & (futex_hashsize - 1)];
 }
 

