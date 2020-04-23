Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4F21B67AB
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgDWXIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:08:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50990 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728667AbgDWXG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:59 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvl-0004yI-2a; Fri, 24 Apr 2020 00:06:53 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvg-00E72U-AT; Fri, 24 Apr 2020 00:06:48 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Lee Schermerhorn" <lee.schermerhorn@hp.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Entropy Moe" <3ntr0py1337@gmail.com>,
        "Randy Dunlap" <rdunlap@infradead.org>,
        syzbot+b055b1a6b2b958707a21@syzkaller.appspotmail.com
Date:   Fri, 24 Apr 2020 00:07:33 +0100
Message-ID: <lsq.1587683028.540912170@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 226/245] mm: mempolicy: require at least one nodeid
 for MPOL_PREFERRED
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

commit aa9f7d5172fac9bf1f09e678c35e287a40a7b7dd upstream.

Using an empty (malformed) nodelist that is not caught during mount option
parsing leads to a stack-out-of-bounds access.

The option string that was used was: "mpol=prefer:,".  However,
MPOL_PREFERRED requires a single node number, which is not being provided
here.

Add a check that 'nodes' is not empty after parsing for MPOL_PREFERRED's
nodeid.

Fixes: 095f1fc4ebf3 ("mempolicy: rework shmem mpol parsing and display")
Reported-by: Entropy Moe <3ntr0py1337@gmail.com>
Reported-by: syzbot+b055b1a6b2b958707a21@syzkaller.appspotmail.com
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: syzbot+b055b1a6b2b958707a21@syzkaller.appspotmail.com
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Link: http://lkml.kernel.org/r/89526377-7eb6-b662-e1d8-4430928abde9@infradead.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/mempolicy.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2711,7 +2711,9 @@ int mpol_parse_str(char *str, struct mem
 	switch (mode) {
 	case MPOL_PREFERRED:
 		/*
-		 * Insist on a nodelist of one node only
+		 * Insist on a nodelist of one node only, although later
+		 * we use first_node(nodes) to grab a single node, so here
+		 * nodelist (or nodes) cannot be empty.
 		 */
 		if (nodelist) {
 			char *rest = nodelist;
@@ -2719,6 +2721,8 @@ int mpol_parse_str(char *str, struct mem
 				rest++;
 			if (*rest)
 				goto out;
+			if (nodes_empty(nodes))
+				goto out;
 		}
 		break;
 	case MPOL_INTERLEAVE:

