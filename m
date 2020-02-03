Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEFCD150E11
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgBCQZx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:25:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728696AbgBCQZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:25:52 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12BB22051A;
        Mon,  3 Feb 2020 16:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747152;
        bh=ofE24FEm24Fj4Yoj4e8H0j42Zj6pFD1BXUp2hpaZBMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UxSpx69vkcDtwvtU+bvWl5H+KrBa2I5WE6N5vloUgW5G7TSp3IBeuFu9q3Y6vkDbh
         2vjFeJQLdRoqh9TwLMNgtpAl8XzDl1iLKe5xUtARTdq4qjQ9F4tRQbXY298/CCWGNI
         6S/AK+NWgIdYtsc3q7zoLW6ZT2irONV7cjynPsm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e64a13c5369a194d67df@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@kernel.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 32/68] mm/mempolicy.c: fix out of bounds write in mpol_parse_str()
Date:   Mon,  3 Feb 2020 16:19:28 +0000
Message-Id: <20200203161910.254070896@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161904.705434837@linuxfoundation.org>
References: <20200203161904.705434837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit c7a91bc7c2e17e0a9c8b9745a2cb118891218fd1 upstream.

What we are trying to do is change the '=' character to a NUL terminator
and then at the end of the function we restore it back to an '='.  The
problem is there are two error paths where we jump to the end of the
function before we have replaced the '=' with NUL.

We end up putting the '=' in the wrong place (possibly one element
before the start of the buffer).

Link: http://lkml.kernel.org/r/20200115055426.vdjwvry44nfug7yy@kili.mountain
Reported-by: syzbot+e64a13c5369a194d67df@syzkaller.appspotmail.com
Fixes: 095f1fc4ebf3 ("mempolicy: rework shmem mpol parsing and display")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Dmitry Vyukov <dvyukov@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/mempolicy.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2744,6 +2744,9 @@ int mpol_parse_str(char *str, struct mem
 	char *flags = strchr(str, '=');
 	int err = 1;
 
+	if (flags)
+		*flags++ = '\0';	/* terminate mode string */
+
 	if (nodelist) {
 		/* NUL-terminate mode or flags string */
 		*nodelist++ = '\0';
@@ -2754,9 +2757,6 @@ int mpol_parse_str(char *str, struct mem
 	} else
 		nodes_clear(nodes);
 
-	if (flags)
-		*flags++ = '\0';	/* terminate mode string */
-
 	for (mode = 0; mode < MPOL_MAX; mode++) {
 		if (!strcmp(str, policy_modes[mode])) {
 			break;


