Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31B37EB3FC
	for <lists+stable@lfdr.de>; Thu, 31 Oct 2019 16:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbfJaPdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Oct 2019 11:33:54 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33877 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728364AbfJaPdy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Oct 2019 11:33:54 -0400
Received: by mail-wr1-f66.google.com with SMTP id e6so4900553wrw.1
        for <stable@vger.kernel.org>; Thu, 31 Oct 2019 08:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=10iZotRkPPB+Bl6Qq9FKmahaoAujw2ACb9/np+86ATA=;
        b=AqBEvENrF03L/YR6YSvTdPpjtcEFc2FzD5OQbnzQUpGuIee4q+qr0z48JXToGNkLAg
         qeCKFrrHRnLD+t3x7ZQjMu5IFB58ZHIYWRbItT3DKudGCwUYFTdOBqDJXlN+tC97B0Uo
         GqJYagkPLYKdSKTF9pjdEuWQTC4FZrIS1dZ39N4pQDyQR+d3cIdmh86RuRximlwCkTh2
         Hgol8kwVFRCFloXaRmkg+ioMUGEWaekm5d1RGwUtrAeTAwIlJNTgQlduWFGzOkbUPoAw
         ksh1CeBdNgaPcxb7FCCNcRDmTQ1wW3q5e0iYItRuAdbHh+VXErmD2egvC+CrVdPedtwv
         zNAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=10iZotRkPPB+Bl6Qq9FKmahaoAujw2ACb9/np+86ATA=;
        b=sMe1ldXMrVA4qYXJyQjp5RsZQBue/o5QUbPRqjBsh7KoT7jHFCYTVBn22GXBy1EHSZ
         pZa48T+QymC/sEQWscKgRDCjvzcXAEMwGZXOr8BsOXJs68viiEa0gj+kjSvDHnYXbtx7
         mJfaZhcZ9NfzKm4B5ro0juRH53g5Apc0wtogW6rO3+GdTs9tSctRN/MfWEnyZ7zKnCLf
         S4uaePGaSTfTolQv2rGq89bSEtgwMQ0tGfn0fvgMdLeIJDKfvN7K0c//zDm2vKYbwrli
         K9pZa/ZvOm28GNUfQzE+8DzIbeU7VKLe9DjieyZ283plM2iuMk7PJs8QA03LUN4Q4G5+
         JWhQ==
X-Gm-Message-State: APjAAAX6FRoQttvdZxKkHUJX0pLUNRuX8ksGTc7CJLn6LWDyLSF1N0h5
        ybvWxUWYW3E78ifQW8wQAOFvOw==
X-Google-Smtp-Source: APXvYqySDt0VYQaHand/6CjAXdfICJFIX0ffuL2AMbdbgXJ2cPjCFdCeJfGpJh+hV6GaNaMP+BmUeA==
X-Received: by 2002:a5d:4403:: with SMTP id z3mr371813wrq.44.1572536030398;
        Thu, 31 Oct 2019 08:33:50 -0700 (PDT)
Received: from localhost.localdomain ([82.166.81.77])
        by smtp.gmail.com with ESMTPSA id q15sm4293006wrr.82.2019.10.31.08.33.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 31 Oct 2019 08:33:49 -0700 (PDT)
From:   Alex Lyakas <alex@zadara.com>
To:     linux-xfs@vger.kernel.org, stable@vger.kernel.org
Cc:     vbendel@redhat.com, bfoster@redhat.com, hch@lst.de,
        darrick.wong@oracle.com, Alex Lyakas <alex@zadara.com>
Subject: [STABLE-PATCH] xfs: Correctly invert xfs_buftarg LRU isolation logic
Date:   Thu, 31 Oct 2019 17:32:55 +0200
Message-Id: <1572535975-32634-1-git-send-email-alex@zadara.com>
X-Mailer: git-send-email 1.9.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vratislav Bendel <vbendel@redhat.com>

[upstream commit 19957a181608d25c8f4136652d0ea00b3738972d]

Due to an inverted logic mistake in xfs_buftarg_isolate()
the xfs_buffers with zero b_lru_ref will take another trip
around LRU, while isolating buffers with non-zero b_lru_ref.

Additionally those isolated buffers end up right back on the LRU
once they are released, because b_lru_ref remains elevated.

Fix that circuitous route by leaving them on the LRU
as originally intended.

[Additional description for the issue]

Due to this issue, buffers will spend one cycle less in
the LRU than intended. If we initialize b_lru_ref to X, we intend the
buffer to survive X shrinker calls, and on the X+1'th call to be taken
off the LRU (and maybe freed). But with this issue, the buffer will be
taken off the LRU and immediately re-added back. But this will happen
X-1 times, because on the X'th time the b_lru_ref will be 0, and the
buffer will not be re-added to the LRU. So the buffer will survive X-1
shrinker calls and not X as intended.

Furthermore, if somehow we end up with the buffer sitting on the LRU
and having b_lru_ref==0, this buffer will never be taken off the LRU,
due to the bug. Not sure that this can happen, because by default
b_lru_ref is set to 1.

This issue existed since the introduction of lru in XFS buffer cache
in commit
"430cbeb86fdcbbdabea7d4aa65307de8de425350 xfs: add a lru to the XFS buffer cache".

However, the integration with the "list_lru" insfrastructure was done in kernel 3.12,
in commit
"e80dfa19976b884db1ac2bc5d7d6ca0a4027bd1c xfs: convert buftarg LRU to generic code"

Therefore this patch is relevant for all kernels from 3.12 to 4.15
(upstream fix was made in 4.16).

Signed-off-by: Alex Lyakas <alex@zadara.com>
Signed-off-by: Vratislav Bendel <vbendel@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
(cherry picked from commit 19957a181608d25c8f4136652d0ea00b3738972d)
---
 fs/xfs/xfs_buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 16f93d7..e4a6239 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1702,7 +1702,7 @@ struct xfs_buf *
 	 * zero. If the value is already zero, we need to reclaim the
 	 * buffer, otherwise it gets another trip through the LRU.
 	 */
-	if (!atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
+	if (atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
 		spin_unlock(&bp->b_lock);
 		return LRU_ROTATE;
 	}
-- 
1.9.1

