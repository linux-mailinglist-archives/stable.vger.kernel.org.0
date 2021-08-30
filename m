Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A553FB509
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 14:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236776AbhH3MBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 08:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236656AbhH3MAu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Aug 2021 08:00:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30E2561154;
        Mon, 30 Aug 2021 11:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324797;
        bh=/ZGPNzesN7UW9RKJpx+09WsM1M2dCjeqPfbNV4s6zb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iCDgfqy7ngAYr0398/pvqHHQQD6P0AXMfLKNzajX9C6Kn3c4sVFCjL2Ac6PjgCpI8
         hvXyle4LClaj+YNmt2ZLIhYwgy/WNrIA49UeZBeZbyGbm0D48qHhpQ0XOTMKZPjPzm
         PjePZbt7WH9eDr4Rp47iVWzeiSIrdBm1fz0OC+em1CXDUG0ZwSTtsyorjsHn0VBxdB
         v5Snxalsk+905S51kFjcXOMmj6LxG3ZM4YUGGInVAsnTCLnCFC4dLQO4td1hkfAB14
         aJeDjJoHpQV+ZG/WXoZywH+CBLERxUE+oWdkjjfuJeB4fNUzKcqj4wIR87r2PH+gBW
         KoIHWtiK0zYsg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tuo Li <islituo@gmail.com>, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 10/14] ceph: fix possible null-pointer dereference in ceph_mdsmap_decode()
Date:   Mon, 30 Aug 2021 07:59:38 -0400
Message-Id: <20210830115942.1017300-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210830115942.1017300-1-sashal@kernel.org>
References: <20210830115942.1017300-1-sashal@kernel.org>
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
index abd9af7727ad..3c444b9cb17b 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -394,9 +394,11 @@ void ceph_mdsmap_destroy(struct ceph_mdsmap *m)
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

