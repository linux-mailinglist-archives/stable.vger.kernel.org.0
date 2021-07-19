Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714FC3CE556
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347760AbhGSPsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:48:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349683AbhGSPpS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7D5A6113B;
        Mon, 19 Jul 2021 16:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711957;
        bh=5CmuSDw8H3Y/kWPK6OVMprudBgeLmsfWjMqzjc9fq14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p+1w72cdaODxQSM05r19wlErFaN8E9bOpnEW1HSLDU1ZHljUUrF43uGv4Xp1LQK0E
         URsYy9Mq0+VFgG7ens30ZLCHShSrVzu12z4DfZxmbIs0FOtjgmzBmOLaGybMEqLagW
         AeObeHdfw8CGqPun/KSRI2GfpqXj3xfVscO8lZI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 188/292] ubifs: journal: Fix error return code in ubifs_jnl_write_inode()
Date:   Mon, 19 Jul 2021 16:54:10 +0200
Message-Id: <20210719144948.671831249@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
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
index 2857e64d673d..230717384a38 100644
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



