Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B2F1EACB5
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731759AbgFASii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:38:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731586AbgFASih (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:38:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4F582074B;
        Mon,  1 Jun 2020 18:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591036419;
        bh=qqYvGaidwfg4zvFMt8jOwZD5KqkfullPtDDFDko273A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qVJKIijzyzGRpGzCLLAUITptTuR+bjLvtTz+VO6ijadSfOqU/fdTLC1LchMO19OyV
         B/4U29h3XSdjBwIflvuLxS6wU6RbadyFVJWAapKz9879yF2Ez9biVqZwfIm1JRJAcM
         6y8aCwInHu++XA4IO/y1SznegAB7M2Rct41DyIPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Yan, Zheng" <zyan@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        =?UTF-8?q?Andrej=20Filip=C4=8Di=C4=8D?= <andrej.filipcic@ijs.si>
Subject: [PATCH 5.4 095/142] ceph: flush release queue when handling caps for unknown inode
Date:   Mon,  1 Jun 2020 19:54:13 +0200
Message-Id: <20200601174047.815799572@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit fb33c114d3ed5bdac230716f5b0a93b56b92a90d ]

It's possible for the VFS to completely forget about an inode, but for
it to still be sitting on the cap release queue. If the MDS sends the
client a cap message for such an inode, it just ignores it today, which
can lead to a stall of up to 5s until the cap release queue is flushed.

If we get a cap message for an inode that can't be located, then go
ahead and flush the cap release queue.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/45532
Fixes: 1e9c2eb6811e ("ceph: delete stale dentry when last reference is dropped")
Reported-and-Tested-by: Andrej Filipčič <andrej.filipcic@ijs.si>
Suggested-by: Yan, Zheng <zyan@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 2d602c2b0ff6..b2695919435e 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3938,7 +3938,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 			__ceph_queue_cap_release(session, cap);
 			spin_unlock(&session->s_cap_lock);
 		}
-		goto done;
+		goto flush_cap_releases;
 	}
 
 	/* these will work even if we don't have a cap yet */
-- 
2.25.1



