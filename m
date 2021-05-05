Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B5F3745D2
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236537AbhEERIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 13:08:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234636AbhEERCM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 13:02:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61ED661C1C;
        Wed,  5 May 2021 16:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232892;
        bh=rkX6z2dPoS2cqSstGb9735JhgAFXr7gdHa10h8sCZ04=;
        h=From:To:Cc:Subject:Date:From;
        b=KLGeeYlHewDDM6ZgIze1SwCWwf3zOUNTj+lQ2+rB2cQ1LKZC1Q9TR3ThYx+CsF3O/
         UfbLXYF4PT2swE2rEVKf/7me3TY3iApEWoqxixbdIhxHwiJyn/QZihIGzevsfSdz8o
         HHi8nKyNd3krlDKA9eFIcqYYlN9SR1Uc6SFshvD1gHUqHFjPB7gFlDt7Ty6/QM75x/
         eRe5pqzLXoTN386ZstXUWjauB56fK0Mr6Pq/GuSkuf5jVbWvClXIO/8ObwM0SjKpFp
         HvS4obM15LlvI7s1qJvKhkHv1/5PSGcNmR59zm39S7PyJ9zgAIyx0fwIeHgjtEV1FV
         r6TlpiytG7lrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.9 01/22] fs: dlm: fix debugfs dump
Date:   Wed,  5 May 2021 12:41:08 -0400
Message-Id: <20210505164129.3464277-1-sashal@kernel.org>
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
index 466f7d60edc2..fabce23fdbac 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -545,6 +545,7 @@ static void *table_seq_next(struct seq_file *seq, void *iter_ptr, loff_t *pos)
 
 		if (bucket >= ls->ls_rsbtbl_size) {
 			kfree(ri);
+			++*pos;
 			return NULL;
 		}
 		tree = toss ? &ls->ls_rsbtbl[bucket].toss : &ls->ls_rsbtbl[bucket].keep;
-- 
2.30.2

