Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC6524F770
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgHXJOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:14:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730450AbgHXI4D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:56:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7F6B206F0;
        Mon, 24 Aug 2020 08:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259363;
        bh=0yGrpJu7gFKvvJbC+j+tbevmFHvNI47Gc6ry9YWKlB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KKYYEthWmWKbK0N/kyadIpxIUUhuLI740YrctfktHCbHEldckIKmWfVjL8mv5mgiY
         VINBcRaio6RQCXCVAAbyojuxi5pxlaLD6Vj07CnnkiBTZCxUZ+ZmVQV330bb0E/eFZ
         ceqVcDqpntND70/U/M2l+S28mqWR8WvccmULR1p8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b57f46d8d6ea51960b8c@syzkaller.appspotmail.com,
        Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 31/71] ceph: fix use-after-free for fsc->mdsc
Date:   Mon, 24 Aug 2020 10:31:22 +0200
Message-Id: <20200824082357.439672252@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082355.848475917@linuxfoundation.org>
References: <20200824082355.848475917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit a7caa88f8b72c136f9a401f498471b8a8e35370d ]

If the ceph_mdsc_init() fails, it will free the mdsc already.

Reported-by: syzbot+b57f46d8d6ea51960b8c@syzkaller.appspotmail.com
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index a2e903203bf9f..0fa14d8b9c64c 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3682,7 +3682,6 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 		return -ENOMEM;
 	}
 
-	fsc->mdsc = mdsc;
 	init_completion(&mdsc->safe_umount_waiters);
 	init_waitqueue_head(&mdsc->session_close_wq);
 	INIT_LIST_HEAD(&mdsc->waiting_for_map);
@@ -3723,6 +3722,8 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 
 	strscpy(mdsc->nodename, utsname()->nodename,
 		sizeof(mdsc->nodename));
+
+	fsc->mdsc = mdsc;
 	return 0;
 }
 
-- 
2.25.1



