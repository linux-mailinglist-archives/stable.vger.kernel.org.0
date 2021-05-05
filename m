Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3757374547
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237994AbhEEREf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 13:04:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:60708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237910AbhEERBj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 13:01:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61F2661A13;
        Wed,  5 May 2021 16:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232854;
        bh=lBp3f5LDs3ZwVf5n60dmCuEVqvWqm3314S221/UgQ5I=;
        h=From:To:Cc:Subject:Date:From;
        b=axHGQvGe3OdhGpIZi2stUkUb75eDrMuypL9Je9aKWH8wimpQyTu/E3N5XDiDdDl6M
         4dWkfWNkD2gudfBJIPN6+WQZZKJpdOFS+zlKNXHvVni0lCMTpU259aH8CaS8+aoo7p
         erCeHGtKOmcSFhNAk+kgFioZdFg+l/wypMXCXVy/a2ZN/u6SR0cAnObTYQ0WNcqprP
         Zgs2vkVilAnIPEwhtl9g2hA/Wa4LqreKAfLEJuQwVfaaok8InDj5zUcxEwc0SP1QBM
         L+bh2Vn5l5VjcA/kUtCibkFuQq5uDhIj8XCP0isD5mOp/cJ/J+UtYgwxkztK/YKtXz
         8OEslrfIjmCiw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 4.14 01/25] fs: dlm: fix debugfs dump
Date:   Wed,  5 May 2021 12:40:27 -0400
Message-Id: <20210505164051.3464020-1-sashal@kernel.org>
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
index fa08448e35dd..bb87dad03cd4 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -544,6 +544,7 @@ static void *table_seq_next(struct seq_file *seq, void *iter_ptr, loff_t *pos)
 
 		if (bucket >= ls->ls_rsbtbl_size) {
 			kfree(ri);
+			++*pos;
 			return NULL;
 		}
 		tree = toss ? &ls->ls_rsbtbl[bucket].toss : &ls->ls_rsbtbl[bucket].keep;
-- 
2.30.2

