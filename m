Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDA614BAAC
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730052AbgA1OPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:15:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:37724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730047AbgA1OPL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:15:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EFB224681;
        Tue, 28 Jan 2020 14:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220910;
        bh=AZ+KTiH2AuAuxd2VCt7KSBWdxt9JsjHbNKgEjirdV1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jpxu+yk9kIUVSoax6Nc7TH/p82smhzClTluCJSzSeQxZboisKdAq3EVY77WzPvDvT
         VWUS9ETSCmG6hn8sMdHtYv/D7JNvbNDqDdAWCgmAZMVrVZ57yFNCVLnaKQ0DJR2Atz
         sBOJh9R9AoxeavGyIPicE6B/9Z9n27mJjHWdsSMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 013/271] exportfs: fix passing zero to ERR_PTR() warning
Date:   Tue, 28 Jan 2020 15:02:42 +0100
Message-Id: <20200128135853.452724759@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 909e22e05353a783c526829427e9a8de122fba9c ]

Fix a static code checker warning:
  fs/exportfs/expfs.c:171 reconnect_one() warn: passing zero to 'ERR_PTR'

The error path for lookup_one_len_unlocked failure
should set err to PTR_ERR.

Fixes: bbf7a8a3562f ("exportfs: move most of reconnect_path to helper function")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exportfs/expfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index 3706939e5dd5e..1730122b10e06 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -146,6 +146,7 @@ static struct dentry *reconnect_one(struct vfsmount *mnt,
 	tmp = lookup_one_len_unlocked(nbuf, parent, strlen(nbuf));
 	if (IS_ERR(tmp)) {
 		dprintk("%s: lookup failed: %d\n", __func__, PTR_ERR(tmp));
+		err = PTR_ERR(tmp);
 		goto out_err;
 	}
 	if (tmp != dentry) {
-- 
2.20.1



