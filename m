Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB370417428
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344871AbhIXNDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:03:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345559AbhIXNB1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:01:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DAAA613D3;
        Fri, 24 Sep 2021 12:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488054;
        bh=X96bRYIxw77buI3zQeVzwxE2EOopD+hiC35xqrOPDpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ipNXe0E3rVbJ6uIJMr7KUFqulCoxCMV+HtwaIUcVz/gDBAqBRXKFrsEUxwQ6VRBzx
         taro0RNHiRioQrEo11MPagFXUr71PkxHdoxNxBd609eV7tiLnsucVA5e5OK2mwGQBg
         xy0fmNqYsPbQbAVSe/ukNH3Xn+n3g7hw/3GCxQRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 064/100] ceph: fix memory leak on decode error in ceph_handle_caps
Date:   Fri, 24 Sep 2021 14:44:13 +0200
Message-Id: <20210924124343.568443191@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 2ad32cf09bd28a21e6ad1595355a023ed631b529 ]

If we hit a decoding error late in the frame, then we might exit the
function without putting the pool_ns string. Ensure that we always put
that reference on the way out of the function.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index ba562efdf07b..1f3d67133958 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4137,8 +4137,9 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 done:
 	mutex_unlock(&session->s_mutex);
 done_unlocked:
-	ceph_put_string(extra_info.pool_ns);
 	iput(inode);
+out:
+	ceph_put_string(extra_info.pool_ns);
 	return;
 
 flush_cap_releases:
@@ -4153,7 +4154,7 @@ flush_cap_releases:
 bad:
 	pr_err("ceph_handle_caps: corrupt message\n");
 	ceph_msg_dump(msg);
-	return;
+	goto out;
 }
 
 /*
-- 
2.33.0



