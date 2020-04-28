Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7F21BC7DD
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbgD1S1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:27:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728598AbgD1S1Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:27:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5CBE208E0;
        Tue, 28 Apr 2020 18:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098444;
        bh=9sDGtt4AzKAVwBWf89jS6ybRmtp4c5IDIplgFw7is60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dSM5dA9R1lRePDDu3yTlKg9mzc2GQ5YKsDktE4UVWYidS/eXBCqRjs9eGOZnMasbb
         ICOlDC/v05EvuC3d3zq/++2RTO64iNz6dMtUM1BWsQdKoxE19KQwtW8SkZh0eE0ST3
         kqfUkB7v05k0Q1yOuDSBr/FjVAkoJPyBEA6iNwdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 009/167] ceph: return ceph_mdsc_do_request() errors from __get_parent()
Date:   Tue, 28 Apr 2020 20:23:05 +0200
Message-Id: <20200428182226.411615774@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



