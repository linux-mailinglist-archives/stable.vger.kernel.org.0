Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFF8373FE2
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbhEEQcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:32:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234123AbhEEQc0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:32:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CBCD610A1;
        Wed,  5 May 2021 16:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232289;
        bh=enR9fvpoMci803EPJsInd9Zej7fSXQVmWoPu6wDqnOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NNp/KAEPS61wfZKj8dRbR/ssJU1CKxKXOf8h7vEsmbhVm2HZrOtzXeQ4wn6GAamh4
         bS6zmpjbSzYwx9zwL5H0PRMBmqH7KbWOn3V+qfgf5thXnul0r3iCkvuOyjKqGjJgP2
         Wj1YWlZ9GJbHa4PCaI5lE9KRBHnQyD4yDD8uqbsjCwKMueROmoivxGqnMpfOwrz/F2
         5GiH5K2PjvAiJlrdWx64m2z/rljowjENvd2VgKHjrEW6YUbs4moW8UdAy1aEQMCdsr
         uuG+lZ+86Bbfdm6YicM5cN+weJyktzADX3FcmOOgG/JZ+/W6d9jZrVhpBms78PDMr2
         8l/ravlGzb7GQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.12 003/116] fs: dlm: fix debugfs dump
Date:   Wed,  5 May 2021 12:29:31 -0400
Message-Id: <20210505163125.3460440-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
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

