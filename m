Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C83E47ADCF
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236397AbhLTOzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:55:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44772 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238343AbhLTOxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:53:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC27861141;
        Mon, 20 Dec 2021 14:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9AFBC36AE8;
        Mon, 20 Dec 2021 14:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012008;
        bh=RT4lIPufo8pYsTdPoG9GJYtnNV0RXYNOyNz4WbQZLpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zail3uIAb4BWXsIOtEVO8J4cF2alFZM4fqmit5qyRdUqIpMzVR6uqlX5e7fqf89zt
         nrRMMNf7bnKWcpFLQrbH945Nta2Qw+pPbWEfPBAAF9v4VXZwIEN2L8kTHw32iYVFBw
         UoIljCcrWkKvvafb5j/Ek9mLO80iKonrAUkIJXdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hu Weiwen <sehuww@mail.scut.edu.cn>,
        Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 048/177] ceph: fix duplicate increment of opened_inodes metric
Date:   Mon, 20 Dec 2021 15:33:18 +0100
Message-Id: <20211220143041.717884876@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hu Weiwen <sehuww@mail.scut.edu.cn>

[ Upstream commit 973e5245637accc4002843f6b888495a6a7762bc ]

opened_inodes is incremented twice when the same inode is opened twice
with O_RDONLY and O_WRONLY respectively.

To reproduce, run this python script, then check the metrics:

import os
for _ in range(10000):
    fd_r = os.open('a', os.O_RDONLY)
    fd_w = os.open('a', os.O_WRONLY)
    os.close(fd_r)
    os.close(fd_w)

Fixes: 1dd8d4708136 ("ceph: metrics for opened files, pinned caps and opened inodes")
Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 8f537f1d9d1d3..8be4da2e2b826 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4349,7 +4349,7 @@ void ceph_get_fmode(struct ceph_inode_info *ci, int fmode, int count)
 {
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(ci->vfs_inode.i_sb);
 	int bits = (fmode << 1) | 1;
-	bool is_opened = false;
+	bool already_opened = false;
 	int i;
 
 	if (count == 1)
@@ -4357,19 +4357,19 @@ void ceph_get_fmode(struct ceph_inode_info *ci, int fmode, int count)
 
 	spin_lock(&ci->i_ceph_lock);
 	for (i = 0; i < CEPH_FILE_MODE_BITS; i++) {
-		if (bits & (1 << i))
-			ci->i_nr_by_mode[i] += count;
-
 		/*
-		 * If any of the mode ref is larger than 1,
+		 * If any of the mode ref is larger than 0,
 		 * that means it has been already opened by
 		 * others. Just skip checking the PIN ref.
 		 */
-		if (i && ci->i_nr_by_mode[i] > 1)
-			is_opened = true;
+		if (i && ci->i_nr_by_mode[i])
+			already_opened = true;
+
+		if (bits & (1 << i))
+			ci->i_nr_by_mode[i] += count;
 	}
 
-	if (!is_opened)
+	if (!already_opened)
 		percpu_counter_inc(&mdsc->metric.opened_inodes);
 	spin_unlock(&ci->i_ceph_lock);
 }
-- 
2.33.0



