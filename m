Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF44C40E5AE
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241097AbhIPROC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:14:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350670AbhIPRLz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:11:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1B5A61A04;
        Thu, 16 Sep 2021 16:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810295;
        bh=4S6YWeWKhBwOazdOKmO1UNOsM3JmweC9T2VmwCcFtqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mhk7jfvsxobgBmtD0do1vij5NK0Tg6JJX+kbtCudeCCCr93mFcCyLtZy9NWGLq6Ud
         469gfSa1TG1YYBNNNwYpT0SrnYl0JYpTSAvZKOfR2oVJWpopY1TEYWz5TZ10PK7m8f
         M7HdOxELnHE2AEmJGnh/mS7v6Pvlq8hN5zvoHzko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 087/432] f2fs: do not submit NEW_ADDR to read node block
Date:   Thu, 16 Sep 2021 17:57:16 +0200
Message-Id: <20210916155813.735871818@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit b7ec2061737f12c33e45beeb967d17f31abc1ada ]

After the below patch, give cp is errored, we drop dirty node pages. This
can give NEW_ADDR to read node pages. Don't do WARN_ON() which gives
generic/475 failure.

Fixes: 28607bf3aa6f ("f2fs: drop dirty node pages when cp is in error status")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 0be9e2d7120e..1b0fe6e64b7d 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1321,7 +1321,8 @@ static int read_node_page(struct page *page, int op_flags)
 	if (err)
 		return err;
 
-	if (unlikely(ni.blk_addr == NULL_ADDR) ||
+	/* NEW_ADDR can be seen, after cp_error drops some dirty node pages */
+	if (unlikely(ni.blk_addr == NULL_ADDR || ni.blk_addr == NEW_ADDR) ||
 			is_sbi_flag_set(sbi, SBI_IS_SHUTDOWN)) {
 		ClearPageUptodate(page);
 		return -ENOENT;
-- 
2.30.2



