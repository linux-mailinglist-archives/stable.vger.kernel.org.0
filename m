Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB32122FF
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 22:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbfEBUJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 16:09:09 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:36050 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfEBUJJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 16:09:09 -0400
Received: by mail-pg1-f202.google.com with SMTP id l13so1808408pgp.3
        for <stable@vger.kernel.org>; Thu, 02 May 2019 13:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ybRTyJtBXApIl4yXjoSrJV3yhQpiIq0fhWYqnNEgzIQ=;
        b=tQPSQA19CW9fimawq50GdgkxoHSAU1X8/5KprS0qxaalkY+Oqt4IiwaSj476gWvnzH
         CdzSr0rzQmjIJoxtVNzO+KyiDpBk6y16H1KfV0UAIxj3y3F1fYoBbYiqFAm7yDgoNMxe
         ME59YcdyH8pGSL7Avbi9BR+67ZDfauQ4srgClkTh9/Y5JUb8rYEu/r8twcI8HKck24D7
         kMgqgxBWM8juVKTdcnC4aGYsXJQ/2U6orFXV+WY8wXX3xq58CCAubuuy0X2gWFf6ZNQj
         KENL34+LaJQnBHMs+FUDFkaOn3fy5+nUSDlXdBlaPER2tnQGYFHyfhmR0xYmDmgWURUH
         okHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ybRTyJtBXApIl4yXjoSrJV3yhQpiIq0fhWYqnNEgzIQ=;
        b=ctcx7s9BcdOM8A4HXq1vt2hyIPnjvBBgoUOgHD7MDI8O834iZf5p9Z18ODSFzrX/WR
         Fs3bkwvNg+Hn4EjQBwXSQ+VFI7OGoFTtXXim3+pwNYJ8R7O00XEPWd1dTOmzO/jJ3X8L
         WSD2H1sKqiCVgcQ4F92tJby8D5tf7ssaL3aqhEBzHeLqzZhDromEqbVAkJNxeIwkJprK
         Z4xvZgWk27nZh/4+AlF/f+wN9JOt24yQ+otmEoXuXbtvKfynLauxCQbK9HYh429PnbQZ
         dfeTSQWp9lbGABioigUVK0P5WBQKKK3LZYKOghpVz/9/LGkL4ipTrOaWKGNk2KM5nRuz
         P9sg==
X-Gm-Message-State: APjAAAUXh7P7SxiZh7kL5ZJHYHvr1UlWrfi8zrwIUJOegN+E93jcR/vp
        8a09xgvYXJR1ZNCu9VfYVM94sFFrcCwdxrBbsicDEK2YUDu4l1ldROiaTqpcR/nNdlQgs3STfGI
        Av4aN+dksY/6prNfULl/OLDHZ2qxK89dxba/jhnUHHu2YNASjBdjbV1tM+wOO+v/CuR83E4EhXQ
        ==
X-Google-Smtp-Source: APXvYqzy98BDo1ZjElAaJ7XsMXlxmeun8/ZLIFvSs9QWn92BJ/S4D4Nu+M2yCAtukoQsZunQjUKT0XW+BCHmhsZSrg==
X-Received: by 2002:a65:5c82:: with SMTP id a2mr5996693pgt.378.1556827748039;
 Thu, 02 May 2019 13:09:08 -0700 (PDT)
Date:   Thu,  2 May 2019 13:09:05 -0700
Message-Id: <20190502200905.147551-1-rkolchmeyer@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
Subject: [PATCH] mm: do not stall register_shrinker()
From:   Robert Kolchmeyer <rkolchmeyer@google.com>
To:     stable@vger.kernel.org
Cc:     Minchan Kim <minchan@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Robert Kolchmeyer <rkolchmeyer@google.com>
Content-Type: text/plain; charset="UTF-8"
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
---
Backport of commit e496612c5130567fc9d5f1969ca4b86665aa3cbb upstream.
We would like to apply this to linux-4.14.y.
I needed to change the patch context for the patch to apply to linux-4.14.y.
The actual fix remains unchanged.

 mm/vmscan.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9734e62654fa..99837e931f53 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -502,6 +502,15 @@ static unsigned long shrink_slab(gfp_t gfp_mask, int nid,
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
-- 
2.21.0.593.g511ec345e18-goog

