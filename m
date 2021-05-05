Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE1C374495
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237146AbhEEQ6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:58:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233946AbhEEQzn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:55:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C356613EB;
        Wed,  5 May 2021 16:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232739;
        bh=enR9fvpoMci803EPJsInd9Zej7fSXQVmWoPu6wDqnOw=;
        h=From:To:Cc:Subject:Date:From;
        b=Jv9f5wTYz2wbS4fyFX6TUWnONqJrsH9LhBru8zPC3JJS2LN4oRO0CpT8V0bkp8BRY
         aZ7pT1RRmvabK31x8UrONrjtpKBa1Yo3HWEeg4R31fP2t4MywLq/u+NJmK1DSUkZ8w
         nTSF+qkdOLveSP2iyLQRZGjznFgm5j0hZ5e/M/wsArH1Aad4X9IAdx1Lgl0FYn58/w
         178Qp3I4gX2e6NEQ4W3DP8CVjt5rNqMyhNwYLRnkOdunitFi2+LkCnqdsQDyBVDzf2
         BIIjy8CKzL20/kLTG53CD/TMsKh+zvG8txdkIZsYJG5Eyhw5putiR+v18ek4Xe+13U
         5fpVJcjcclNgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.4 01/46] fs: dlm: fix debugfs dump
Date:   Wed,  5 May 2021 12:38:11 -0400
Message-Id: <20210505163856.3463279-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 92c48950b43f4a767388cf87709d8687151a641f ]

This patch fixes the following message which randomly pops up during
glocktop call:

seq_file: buggy .next function table_seq_next did not update position index

The issue is that seq_read_iter() in fs/seq_file.c also needs an
increment of the index in an non next record case as well which this
patch fixes otherwise seq_read_iter() will print out the above message.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/debug_fs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index d6bbccb0ed15..d5bd990bcab8 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -542,6 +542,7 @@ static void *table_seq_next(struct seq_file *seq, void *iter_ptr, loff_t *pos)
 
 		if (bucket >= ls->ls_rsbtbl_size) {
 			kfree(ri);
+			++*pos;
 			return NULL;
 		}
 		tree = toss ? &ls->ls_rsbtbl[bucket].toss : &ls->ls_rsbtbl[bucket].keep;
-- 
2.30.2

