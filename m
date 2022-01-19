Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D916F493208
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 01:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347857AbiASAww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 19:52:52 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:29359 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235175AbiASAww (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 19:52:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1642553572; x=1674089572;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SHSdIx8QqBjCi4aMuYs2meT2qK1VW4oEwDBhyWFk88A=;
  b=FPr9QzoZ0oWd+Qr5gQmlp/Lv8NXRSJgpH+1WQheSCp3Ztvwv602S9nbA
   wlzwS1NyWeMJf7xHmLxuC+U23Zq0PoAdotFaerwnEWB/NVDSAAie0BCTq
   oMq7WU6KQUlzGZ6YW7r5VMh8IBuE6KYFOVQ7xPOBnKa8W9PRRG0M13cp7
   E=;
X-IronPort-AV: E=Sophos;i="5.88,298,1635206400"; 
   d="scan'208";a="170765463"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-9ec26c6c.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 19 Jan 2022 00:52:51 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-9ec26c6c.us-west-2.amazon.com (Postfix) with ESMTPS id A28FD4161F;
        Wed, 19 Jan 2022 00:52:49 +0000 (UTC)
Received: from EX13D01UWA002.ant.amazon.com (10.43.160.74) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Wed, 19 Jan 2022 00:52:49 +0000
Received: from u46989501580c5c.ant.amazon.com (10.43.160.17) by
 EX13d01UWA002.ant.amazon.com (10.43.160.74) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Wed, 19 Jan 2022 00:52:48 +0000
From:   Samuel Mendoza-Jonas <samjonas@amazon.com>
To:     <stable@vger.kernel.org>
CC:     Miklos Szeredi <mszeredi@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 4.14 2/2] fuse: fix live lock in fuse_iget()
Date:   Tue, 18 Jan 2022 16:52:01 -0800
Message-ID: <20220119005201.130738-2-samjonas@amazon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220119005201.130738-1-samjonas@amazon.com>
References: <20220119005201.130738-1-samjonas@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.17]
X-ClientProxiedBy: EX13D17UWB004.ant.amazon.com (10.43.161.132) To
 EX13d01UWA002.ant.amazon.com (10.43.160.74)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

commit 775c5033a0d164622d9d10dd0f0a5531639ed3ed upstream.

Commit 5d069dbe8aaf ("fuse: fix bad inode") replaced make_bad_inode()
in fuse_iget() with a private implementation fuse_make_bad().

The private implementation fails to remove the bad inode from inode
cache, so the retry loop with iget5_locked() finds the same bad inode
and marks it bad forever.

kmsg snip:

[ ] rcu: INFO: rcu_sched self-detected stall on CPU
...
[ ]  ? bit_wait_io+0x50/0x50
[ ]  ? fuse_init_file_inode+0x70/0x70
[ ]  ? find_inode.isra.32+0x60/0xb0
[ ]  ? fuse_init_file_inode+0x70/0x70
[ ]  ilookup5_nowait+0x65/0x90
[ ]  ? fuse_init_file_inode+0x70/0x70
[ ]  ilookup5.part.36+0x2e/0x80
[ ]  ? fuse_init_file_inode+0x70/0x70
[ ]  ? fuse_inode_eq+0x20/0x20
[ ]  iget5_locked+0x21/0x80
[ ]  ? fuse_inode_eq+0x20/0x20
[ ]  fuse_iget+0x96/0x1b0

Fixes: 5d069dbe8aaf ("fuse: fix bad inode")
Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
---
No changes to this patch, included as a direct followup to the first
patch.

 fs/fuse/fuse_i.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 220960c9b96d..fac1f08dd32e 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -691,6 +691,7 @@ static inline u64 get_node_id(struct inode *inode)
 
 static inline void fuse_make_bad(struct inode *inode)
 {
+	remove_inode_hash(inode);
 	set_bit(FUSE_I_BAD, &get_fuse_inode(inode)->state);
 }
 
-- 
2.25.1

