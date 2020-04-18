Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61551AEDA5
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 15:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgDRNxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 09:53:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbgDRNsb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 09:48:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B015E2220A;
        Sat, 18 Apr 2020 13:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587217711;
        bh=9sDGtt4AzKAVwBWf89jS6ybRmtp4c5IDIplgFw7is60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=td6gFUZV2tRq8Np7gC9LRJPjVEdkCKHmoxneKRDvkfwHzTL8KpsUhtwbAuFuptnu1
         2Zx6jq4TLigN/iviWhwwiOijazKZgHsKc3Mkdr7AlbUEE33y8nMfrIETJriju8YNUt
         SJof1PXrEUw2Adfdso9SVRd8jM6bd5Vl1xneIUio=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiujun Huang <hqjagain@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 13/73] ceph: return ceph_mdsc_do_request() errors from __get_parent()
Date:   Sat, 18 Apr 2020 09:47:15 -0400
Message-Id: <20200418134815.6519-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418134815.6519-1-sashal@kernel.org>
References: <20200418134815.6519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiujun Huang <hqjagain@gmail.com>

[ Upstream commit c6d50296032f0b97473eb2e274dc7cc5d0173847 ]

Return the error returned by ceph_mdsc_do_request(). Otherwise,
r_target_inode ends up being NULL this ends up returning ENOENT
regardless of the error.

Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/export.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index b6bfa94332c30..79dc06881e78e 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -315,6 +315,11 @@ static struct dentry *__get_parent(struct super_block *sb,
 
 	req->r_num_caps = 1;
 	err = ceph_mdsc_do_request(mdsc, NULL, req);
+	if (err) {
+		ceph_mdsc_put_request(req);
+		return ERR_PTR(err);
+	}
+
 	inode = req->r_target_inode;
 	if (inode)
 		ihold(inode);
-- 
2.20.1

