Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A77A41A4174
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 06:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgDJDsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:48:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728308AbgDJDsl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:48:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FEFE20B1F;
        Fri, 10 Apr 2020 03:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490522;
        bh=Ip3KPfQ0SRI7lGjO5hzhDrLGc6+mzqfsJbkAD61X9t0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ixugN/J3gyTVi1R1SoexG8JFBX8A+6y6WSGvrRJdOebVXXW1Nf1w+CMF4uAvoMxb4
         eB5dZ+lZtF/PyeQjFHglhWCHYT0uyX8w/auMhpsdD1LHxbE9g721EcQHroxVLYoHSW
         yeFr7CkWYvb7EIY0trxHr905RwHJEaM1YxQJrLsM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.5 35/56] gfs2: Don't demote a glock until its revokes are written
Date:   Thu,  9 Apr 2020 23:47:39 -0400
Message-Id: <20200410034800.8381-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034800.8381-1-sashal@kernel.org>
References: <20200410034800.8381-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit df5db5f9ee112e76b5202fbc331f990a0fc316d6 ]

Before this patch, run_queue would demote glocks based on whether
there are any more holders. But if the glock has pending revokes that
haven't been written to the media, giving up the glock might end in
file system corruption if the revokes never get written due to
io errors, node crashes and fences, etc. In that case, another node
will replay the metadata blocks associated with the glock, but
because the revoke was never written, it could replay that block
even though the glock had since been granted to another node who
might have made changes.

This patch changes the logic in run_queue so that it never demotes
a glock until its count of pending revokes reaches zero.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index b7123de7c180e..a5e145d4e9916 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -645,6 +645,9 @@ __acquires(&gl->gl_lockref.lock)
 			goto out_unlock;
 		if (nonblock)
 			goto out_sched;
+		smp_mb();
+		if (atomic_read(&gl->gl_revokes) != 0)
+			goto out_sched;
 		set_bit(GLF_DEMOTE_IN_PROGRESS, &gl->gl_flags);
 		GLOCK_BUG_ON(gl, gl->gl_demote_state == LM_ST_EXCLUSIVE);
 		gl->gl_target = gl->gl_demote_state;
-- 
2.20.1

