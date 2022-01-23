Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7F7496EAD
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 01:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235404AbiAWANp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 19:13:45 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:45850 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235421AbiAWAMm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 19:12:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B747ACE0AC0;
        Sun, 23 Jan 2022 00:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FE4C004E1;
        Sun, 23 Jan 2022 00:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896759;
        bh=HE1auXPAvotomIohwNjYUGvmFKANDR1XNJmuKVBzXmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WpRqLKvU2DdquQVHkO0JoqX9qGYI2W8gCkkv4HzBF0jFabB4If3wtSiZBZhhb23/o
         frI/syBhaHXSOEPpAb0ne0v2VD5ZnlMmoInqqsbtogWaV31UPfv3n4lTCw+4iPB9rx
         qlDz60ByOOtaaZO+wqJv55X3BVPespIGqgtyFcfLiY85Tv8IxHAtoIFP4QkQig2dzL
         k/itCQw8XijUE+WqxfUH/+yAZFMVT9FZ8PTghGZbpROuLvuLK9cVpfKBfJLB85TxDZ
         GzET8ljSypQ1HoVAz2IuRPBG1hWu1ahH75lFcgiOSTcnXSSb4GdBX9dkQI2i26R1fW
         UFCi+hdJocqmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Hu Weiwen <sehuww@mail.scut.edu.cn>,
        Luis Henriques <lhenriques@suse.de>,
        Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 08/16] ceph: don't check for quotas on MDS stray dirs
Date:   Sat, 22 Jan 2022 19:12:07 -0500
Message-Id: <20220123001216.2460383-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001216.2460383-1-sashal@kernel.org>
References: <20220123001216.2460383-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 0078ea3b0566e3da09ae8e1e4fbfd708702f2876 ]

玮文 胡 reported seeing the WARN_RATELIMIT pop when writing to an
inode that had been transplanted into the stray dir. The client was
trying to look up the quotarealm info from the parent and that tripped
the warning.

Change the ceph_vino_is_reserved helper to not throw a warning for
MDS stray directories (0x100 - 0x1ff), only for reserved dirs that
are not in that range.

Also, fix ceph_has_realms_with_quotas to return false when encountering
a reserved inode.

URL: https://tracker.ceph.com/issues/53180
Reported-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Luis Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/quota.c |  3 +++
 fs/ceph/super.h | 20 ++++++++++++--------
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
index 620c691af40e7..d1158c40bb0c6 100644
--- a/fs/ceph/quota.c
+++ b/fs/ceph/quota.c
@@ -30,6 +30,9 @@ static inline bool ceph_has_realms_with_quotas(struct inode *inode)
 	/* if root is the real CephFS root, we don't have quota realms */
 	if (root && ceph_ino(root) == CEPH_INO_ROOT)
 		return false;
+	/* MDS stray dirs have no quota realms */
+	if (ceph_vino_is_reserved(ceph_inode(inode)->i_vino))
+		return false;
 	/* otherwise, we can't know for sure */
 	return true;
 }
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 14f951cd5b61b..8cf4323d729cd 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -534,19 +534,23 @@ static inline int ceph_ino_compare(struct inode *inode, void *data)
  *
  * These come from src/mds/mdstypes.h in the ceph sources.
  */
-#define CEPH_MAX_MDS		0x100
-#define CEPH_NUM_STRAY		10
+#define CEPH_MAX_MDS			0x100
+#define CEPH_NUM_STRAY			10
 #define CEPH_MDS_INO_MDSDIR_OFFSET	(1 * CEPH_MAX_MDS)
+#define CEPH_MDS_INO_LOG_OFFSET		(2 * CEPH_MAX_MDS)
 #define CEPH_INO_SYSTEM_BASE		((6*CEPH_MAX_MDS) + (CEPH_MAX_MDS * CEPH_NUM_STRAY))
 
 static inline bool ceph_vino_is_reserved(const struct ceph_vino vino)
 {
-	if (vino.ino < CEPH_INO_SYSTEM_BASE &&
-	    vino.ino >= CEPH_MDS_INO_MDSDIR_OFFSET) {
-		WARN_RATELIMIT(1, "Attempt to access reserved inode number 0x%llx", vino.ino);
-		return true;
-	}
-	return false;
+	if (vino.ino >= CEPH_INO_SYSTEM_BASE ||
+	    vino.ino < CEPH_MDS_INO_MDSDIR_OFFSET)
+		return false;
+
+	/* Don't warn on mdsdirs */
+	WARN_RATELIMIT(vino.ino >= CEPH_MDS_INO_LOG_OFFSET,
+			"Attempt to access reserved inode number 0x%llx",
+			vino.ino);
+	return true;
 }
 
 static inline struct inode *ceph_find_inode(struct super_block *sb,
-- 
2.34.1

