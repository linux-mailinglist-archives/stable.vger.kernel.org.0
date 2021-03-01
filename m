Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853BB328B89
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbhCASgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:36:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:44816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240121AbhCAS2y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:28:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9242B651FA;
        Mon,  1 Mar 2021 17:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619216;
        bh=iujoRJMg7WqCX5LMPn89HXegUXUu0a01+lL15SPLMRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKxG7yLJBk0YuyQOcUYpmUN1NreV3sT2e4vNUEG3QWG502zcOCeKJe2+gssp0qIFP
         Obiq5UU+xzmAoG7MOu4EzUIsW+JX0f+FtlguZjBCKAX8uh7GMDXQiGE3rKJu/1lpCN
         bCaKdq6FhVK/Bt2x7zCxhCFXYmfmGqLPaE0uDmUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 375/663] ceph: fix flush_snap logic after putting caps
Date:   Mon,  1 Mar 2021 17:10:23 +0100
Message-Id: <20210301161200.407130471@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 64f36da5625f7f9853b86750eaa89d499d16a2e9 ]

A primary reason for skipping ceph_check_caps after putting the
references was to avoid the locking in ceph_check_caps during a
reconnect. __ceph_put_cap_refs can still call ceph_flush_snaps in that
case though, and that takes many of the same inconvenient locks.

Fix the logic in __ceph_put_cap_refs to skip flushing snaps when the
skip_checking_caps flag is set.

Fixes: e64f44a88465 ("ceph: skip checking caps when session reconnecting and releasing reqs")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 2b200b5a44c3a..576d01275bbd7 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3092,10 +3092,12 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
 	dout("put_cap_refs %p had %s%s%s\n", inode, ceph_cap_string(had),
 	     last ? " last" : "", put ? " put" : "");
 
-	if (last && !skip_checking_caps)
-		ceph_check_caps(ci, 0, NULL);
-	else if (flushsnaps)
-		ceph_flush_snaps(ci, NULL);
+	if (!skip_checking_caps) {
+		if (last)
+			ceph_check_caps(ci, 0, NULL);
+		else if (flushsnaps)
+			ceph_flush_snaps(ci, NULL);
+	}
 	if (wake)
 		wake_up_all(&ci->i_cap_wq);
 	while (put-- > 0)
-- 
2.27.0



