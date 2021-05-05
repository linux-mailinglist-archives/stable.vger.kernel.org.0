Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE14E3745C4
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236807AbhEERHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 13:07:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237785AbhEEREU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 13:04:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81AA461C23;
        Wed,  5 May 2021 16:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232925;
        bh=K4Gxbu8Li8VuMOhLddDQQmmtlV8IRL45B30dXYpG75g=;
        h=From:To:Cc:Subject:Date:From;
        b=OdVskZVsRuA54joeHUqmIv1XAuK+985z9RokP02XAp3B6Ys2sLcNJ/GohXLCcqnG+
         I7ORvCQ6CK8prPuTkc9BD9V2vuZvvhbWyWioeWHmeU54Xt2WQ7rgGmzV09b7CFzW42
         s4A4iMaWsY1kw/Vq3rGP3JQkaTaWxr50L1YMI4CmRscA2yy0tRihFlXG8auNTzwotP
         BwxzanmK5Ql5ipUjLFwQoFVagkADM8+fIUXHlRe7cq7v8mjHej9MupX6t89jwmSWMq
         vIXZytPcO88zwKkr0L1KVVnKu2qemPookp4N3uSXIR7+SmwQUbYqlxFZMvQwttxuj3
         7vfQA51JxInpg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.4 01/19] fs: dlm: fix debugfs dump
Date:   Wed,  5 May 2021 12:41:44 -0400
Message-Id: <20210505164203.3464510-1-sashal@kernel.org>
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
index eea64912c9c0..3b79c0284a30 100644
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

