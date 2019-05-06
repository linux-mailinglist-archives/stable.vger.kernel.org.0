Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0DB414E00
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbfEFOoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:44:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727259AbfEFOoX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:44:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB11721019;
        Mon,  6 May 2019 14:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153863;
        bh=R0OHY4dDdSHj3imxbYEZ9us7NW27oCdlDlgR1jrtXm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z+JK/ZYJRDR4GR6Ohj/Y8bvZtNLOLtWI7e0/viRlbtfOeJSTflWjep+DbkU2vgZBL
         ZBKNa6Pd8Un0gCS9Qg/MHhzM0YGjqUT4BBpNJDVATO5y+373PVJ/qWRCNdo2PUJwVk
         ge1se20w5isIa8AO3+pf6CMaPGUQRsqyM9GD2AKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Robert Kolchmeyer <rkolchmeyer@google.com>
Subject: [PATCH 4.14 24/75] mm: do not stall register_shrinker()
Date:   Mon,  6 May 2019 16:32:32 +0200
Message-Id: <20190506143055.350550574@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.287515952@linuxfoundation.org>
References: <20190506143053.287515952@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>

commit e496612c5130567fc9d5f1969ca4b86665aa3cbb upstream.

Shakeel Butt reported he has observed in production systems that the job
loader gets stuck for 10s of seconds while doing a mount operation.  It
turns out that it was stuck in register_shrinker() because some
unrelated job was under memory pressure and was spending time in
shrink_slab().  Machines have a lot of shrinkers registered and jobs
under memory pressure have to traverse all of those memcg-aware
shrinkers and affect unrelated jobs which want to register their own
shrinkers.

To solve the issue, this patch simply bails out slab shrinking if it is
found that someone wants to register a shrinker in parallel.  A downside
is it could cause unfair shrinking between shrinkers.  However, it
should be rare and we can add compilcated logic if we find it's not
enough.

[akpm@linux-foundation.org: tweak code comment]
Link: http://lkml.kernel.org/r/20171115005602.GB23810@bbox
Link: http://lkml.kernel.org/r/1511481899-20335-1-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reported-by: Shakeel Butt <shakeelb@google.com>
Tested-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[rkolchmeyer: Backported to 4.14: adjusted context]
Signed-off-by: Robert Kolchmeyer <rkolchmeyer@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -502,6 +502,15 @@ static unsigned long shrink_slab(gfp_t g
 			sc.nid = 0;
 
 		freed += do_shrink_slab(&sc, shrinker, nr_scanned, nr_eligible);
+		/*
+		 * Bail out if someone want to register a new shrinker to
+		 * prevent the regsitration from being stalled for long periods
+		 * by parallel ongoing shrinking.
+		 */
+		if (rwsem_is_contended(&shrinker_rwsem)) {
+			freed = freed ? : 1;
+			break;
+		}
 	}
 
 	up_read(&shrinker_rwsem);


