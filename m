Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0104C56AEC6
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 00:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236533AbiGGW7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 18:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236448AbiGGW7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 18:59:09 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14EA233E10;
        Thu,  7 Jul 2022 15:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657234749; x=1688770749;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=i69OQc7duTnbbrsH+fvE+dP30QLFj5YmKyjTFRIu1oA=;
  b=Of02fV/AIrqlDnruQlfiWk7PRQoRPqlUQcuxBFstO2xCtvCf6BNPAoP7
   PUQvoe96GgGyV+g1eozjkQohd7+cWO12wz/0IeInHc1///RLNSSXgPhjW
   qNd+CtcWFSZrACz437MoIhPS/ze67OrHCNsQ3zWH5YnvBrVSd+wHkca0A
   U=;
X-IronPort-AV: E=Sophos;i="5.92,253,1650931200"; 
   d="scan'208";a="105981962"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-2520d768.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 07 Jul 2022 22:58:51 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-2520d768.us-west-2.amazon.com (Postfix) with ESMTPS id D155442BCC;
        Thu,  7 Jul 2022 22:58:50 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Thu, 7 Jul 2022 22:58:49 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.50) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Thu, 7 Jul 2022 22:58:47 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <stable@vger.kernel.org>, <linux-xfs@vger.kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>, Ke Xu <kkexu@amazon.com>,
        "Ayushman Dutta" <ayudutta@amazon.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH stable 5.15] xfs: remove incorrect ASSERT in xfs_rename
Date:   Thu, 7 Jul 2022 15:58:35 -0700
Message-ID: <20220707225835.32094-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.50]
X-ClientProxiedBy: EX13D14UWB002.ant.amazon.com (10.43.161.216) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

commit e445976537ad139162980bee015b7364e5b64fff upstream.

Ayushman Dutta reported our 5.10 kernel hit the warning.  It was because
the original commit misses a Fixes tag and was not backported to the stable
tree.  The fix is merged in 5.16, so please backport it to 5.15 first.

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
Reported-by: Ayushman Dutta <ayudutta@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
I will send another patch for 4.9 - 5.4 because of a conflict with idmapped
mount changes.
---
 fs/xfs/xfs_inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2477e301fa82..c19f3ca605af 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3128,7 +3128,6 @@ xfs_rename(
 	 * appropriately.
 	 */
 	if (flags & RENAME_WHITEOUT) {
-		ASSERT(!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)));
 		error = xfs_rename_alloc_whiteout(mnt_userns, target_dp, &wip);
 		if (error)
 			return error;
-- 
2.30.2

