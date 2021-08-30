Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D363FB593
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 14:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236795AbhH3MGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 08:06:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236760AbhH3MBH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Aug 2021 08:01:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B28661166;
        Mon, 30 Aug 2021 12:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324812;
        bh=J1D+vVYM1Bp+6Auu1hyBHhe7tty7N/sPZrHc+DcdPgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jzGu74nDD3yKmdrbLXPsXn5RKnebxjT/mBYxY2HfJMoLfvbimKSITFG+xRO66n5fg
         CU9OX+dHUsrXOTSTpFf092JDpfiMvaizg0bI4xXXqW71ERNsEXhjHFvq5ryMIrPEjm
         FMUSELF83ypnJr5u9BtW08ftoQxfOzoWfmh85gqTtBmo6hN0R4UvPRU+s00hwxdknl
         s5WXBStQT/F69Ab5dTVTSoDDqX1Lsw9PZud4+iGWo0flviB8uG7Q2M3cQ0ysz1KKfn
         VJdAiq4f1DfB5RsM+P3T/WsnzUzEspoFn90iwynGZTMCAvOSUOjYFcmDSbtyJKXbyo
         i6zdEkTj/wLTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tuo Li <islituo@gmail.com>, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 07/11] ceph: fix possible null-pointer dereference in ceph_mdsmap_decode()
Date:   Mon, 30 Aug 2021 07:59:58 -0400
Message-Id: <20210830120002.1017700-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210830120002.1017700-1-sashal@kernel.org>
References: <20210830120002.1017700-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tuo Li <islituo@gmail.com>

[ Upstream commit a9e6ffbc5b7324b6639ee89028908b1e91ceed51 ]

kcalloc() is called to allocate memory for m->m_info, and if it fails,
ceph_mdsmap_destroy() behind the label out_err will be called:
  ceph_mdsmap_destroy(m);

In ceph_mdsmap_destroy(), m->m_info is dereferenced through:
  kfree(m->m_info[i].export_targets);

To fix this possible null-pointer dereference, check m->m_info before the
for loop to free m->m_info[i].export_targets.

[ jlayton: fix up whitespace damage
	   only kfree(m->m_info) if it's non-NULL ]

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mdsmap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 1096d1d3a84c..47f2903bacb9 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -393,9 +393,11 @@ void ceph_mdsmap_destroy(struct ceph_mdsmap *m)
 {
 	int i;
 
-	for (i = 0; i < m->possible_max_rank; i++)
-		kfree(m->m_info[i].export_targets);
-	kfree(m->m_info);
+	if (m->m_info) {
+		for (i = 0; i < m->possible_max_rank; i++)
+			kfree(m->m_info[i].export_targets);
+		kfree(m->m_info);
+	}
 	kfree(m->m_data_pg_pools);
 	kfree(m);
 }
-- 
2.30.2

