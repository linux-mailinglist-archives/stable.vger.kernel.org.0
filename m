Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9938456AED5
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 01:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236763AbiGGXIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 19:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236533AbiGGXIT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 19:08:19 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED37510FFB;
        Thu,  7 Jul 2022 16:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657235299; x=1688771299;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BZUSo8zL8IjB95QmzdXoVQEVWKVqu0Qf0g8IoUOX6Zg=;
  b=nCeRv3Va4kMi4yYfV2qYGMW63V9gN3V4G2eAppLuSu+jcXwor2c+X6KX
   kv6iAV3JQAYFQCwP9LUuE7DSX2smnRWvLrv9UYjm6uXxwr2pYVFioSViL
   lS5s4j2lb/76doq6Bwloau0Xc1UQmUCL11CuC0rpPH82ZuGnh6hoQYw/q
   o=;
X-IronPort-AV: E=Sophos;i="5.92,253,1650931200"; 
   d="scan'208";a="215935675"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-1c3c2014.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 07 Jul 2022 23:08:08 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-1c3c2014.us-east-1.amazon.com (Postfix) with ESMTPS id 90C96CAEB9;
        Thu,  7 Jul 2022 23:08:06 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Thu, 7 Jul 2022 23:08:05 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.50) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Thu, 7 Jul 2022 23:08:02 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <stable@vger.kernel.org>, <linux-xfs@vger.kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>, Ke Xu <kkexu@amazon.com>,
        "Ayushman Dutta" <ayudutta@amazon.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH stable 4.9, 4.14, 4.19, 5.4, 5.10] xfs: remove incorrect ASSERT in xfs_rename
Date:   Thu, 7 Jul 2022 16:07:53 -0700
Message-ID: <20220707230753.32743-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.50]
X-ClientProxiedBy: EX13D24UWB004.ant.amazon.com (10.43.161.4) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

commit e445976537ad139162980bee015b7364e5b64fff upstream.

Ayushman Dutta reported our 5.10 kernel hit the warning.  It was because
the original commit misses a Fixes tag and was not backported to the stable
tree.  The fix is merged in 5.16, but it conflicts in 4.9 - 5.10 because
of the idmapped mount changes:

  ++<<<<<<< HEAD
   +      ASSERT(!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)));
   +      error = xfs_rename_alloc_whiteout(target_dp, &wip);
  ++=======
  +       error = xfs_rename_alloc_whiteout(mnt_userns, target_dp, &wip);
  ++>>>>>>> e445976537ad (xfs: remove incorrect ASSERT in xfs_rename)

We can resolve this by removing mnt_userns from the argument.

This ASSERT in xfs_rename is a) incorrect, because
(RENAME_WHITEOUT|RENAME_NOREPLACE) is a valid combination, and
b) unnecessary, because actual invalid flag combinations are already
handled at the vfs level in do_renameat2() before we get called.
So, remove it.

Reported-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Fixes: 7dcf5c3e4527 ("xfs: add RENAME_WHITEOUT support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
I confirmed this can be applied cleanly on the latest 4.9 - 5.10 stable
branch, but if there is any problem, please let me know.
---
 fs/xfs/xfs_inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e958b1c74561..03497741aef7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3170,7 +3170,6 @@ xfs_rename(
 	 * appropriately.
 	 */
 	if (flags & RENAME_WHITEOUT) {
-		ASSERT(!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)));
 		error = xfs_rename_alloc_whiteout(target_dp, &wip);
 		if (error)
 			return error;
-- 
2.30.2

