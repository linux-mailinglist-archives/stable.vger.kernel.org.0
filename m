Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 163FF374399
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234974AbhEEQvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:51:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236110AbhEEQrk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:47:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0404F61946;
        Wed,  5 May 2021 16:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232612;
        bh=enR9fvpoMci803EPJsInd9Zej7fSXQVmWoPu6wDqnOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h+LS8p4+yls1dxTtCQjZb8gr3Rk5tlR7OCuMZxQOQBoqbpE7/2l+HpE/1cM+2EEgf
         jiOeslvLOhDjuDwHMuG4DG8BAe0WclzzIdC+8ST/LyG3dH94cJPsjhjuU7UH/XvM6/
         79sjfmGU75WRvflzGQChdqw1+ExWlPP0/ezc39SN7/bRFhu32ewxst+QlA5PX1Yv7g
         1fIlBbq0f6wx8PBOgmhLzDzB4nL/Xg3JyeXykisHJfxAvCGGxLt8z7gYcVqowthkok
         XgYDxpxFDHy7So4DRWSLnCkKQ3JogcGiqyGyvMj0wCAFBGSJYT8zQ9BixQkYyPtiq5
         iTNKeA0lSzleA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.10 02/85] fs: dlm: fix debugfs dump
Date:   Wed,  5 May 2021 12:35:25 -0400
Message-Id: <20210505163648.3462507-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
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

