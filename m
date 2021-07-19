Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEA93CE2F8
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235879AbhGSPdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:33:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347522AbhGSPTb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:19:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4A3361415;
        Mon, 19 Jul 2021 15:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710301;
        bh=E2RmQRbNJXBzx2Ef1fGcsPlJ5wyQTnwudubQj9I9VXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oLHl5tNk/VQjOkkeHZafLSeff/lxMYTDD76U8gQaGCCTzGqr5EAMqnyPvBOPu0OOh
         w+I3dodxPSIF/xv+iQDoEt53oVSenkKK6kU5VcdFqwu9hRm/iLoA+2Mmqv4vwgdeG8
         d0kLN1ASL16YYY10BctnXEl6f184AuDZhYPx41qk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 160/243] ubifs: journal: Fix error return code in ubifs_jnl_write_inode()
Date:   Mon, 19 Jul 2021 16:53:09 +0200
Message-Id: <20210719144946.068152235@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit a2c2a622d41168f9fea2aa3f76b9fbaa88531aac ]

Fix to return a negative error code from the error handling case instead
of 0, as done elsewhere in this function.

Fixes: 9ca2d7326444 ("ubifs: Limit number of xattrs per inode")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/journal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index 7927dea2baba..7274bd23881b 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -882,6 +882,7 @@ int ubifs_jnl_write_inode(struct ubifs_info *c, const struct inode *inode)
 		struct ubifs_dent_node *xent, *pxent = NULL;
 
 		if (ui->xattr_cnt > ubifs_xattr_max_cnt(c)) {
+			err = -EPERM;
 			ubifs_err(c, "Cannot delete inode, it has too much xattrs!");
 			goto out_release;
 		}
-- 
2.30.2



