Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52BF11C12E1
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbgEANZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:25:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728969AbgEANZK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:25:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A13920757;
        Fri,  1 May 2020 13:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339509;
        bh=x2nQX49DejcTSMkqKDh8blNT4ob6Yff8fCJ441kAin0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IMiz5EtC8gflX1pFyl0HKdrxaOldzt8ihKRGvrCJe3zUL+foni6mF96mp4epmS2H4
         vj6uYwHUsUfUVW+EvCBeMv3g7rlf8nDPEMlf9RJq51yNXZ9T8dJHV0nM5byCOL5VOP
         xZB/BjLIL04lCqiWnBUGQwKQiY8DwpkenxruFzdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 08/70] ceph: return ceph_mdsc_do_request() errors from __get_parent()
Date:   Fri,  1 May 2020 15:20:56 +0200
Message-Id: <20200501131515.096286832@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.302599262@linuxfoundation.org>
References: <20200501131513.302599262@linuxfoundation.org>
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
index fe02ae7f056a3..ff9e60daf086b 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -146,6 +146,11 @@ static struct dentry *__get_parent(struct super_block *sb,
 	}
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



