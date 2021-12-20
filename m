Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6426247ADEC
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239599AbhLTO4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237836AbhLTOwz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:52:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37944C0619D9;
        Mon, 20 Dec 2021 06:47:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 045C9B80EF6;
        Mon, 20 Dec 2021 14:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D74C36AE7;
        Mon, 20 Dec 2021 14:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011649;
        bh=VmA3UfF2NkwyX3nlb3C8VvSIwSL8ovIrP+8XMtW2vqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bd7/T83BHTp6tWBczYuEZqVACGnpBr9dmQWtFBS4X72MURCmrG5ZwYbR9Ggw3YIxn
         rHZEPQ8dpJIEKIXdDVmJOEBDePkuruLYM4XSWQ3Y2FsmxS0l4Q8kaaYoCImSfuSgpg
         ZndD4Ufqgk1iPFQyqK8bRJMnxHCeiewQHe/Y4KW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hu Weiwen <sehuww@mail.scut.edu.cn>,
        Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 25/99] ceph: fix duplicate increment of opened_inodes metric
Date:   Mon, 20 Dec 2021 15:33:58 +0100
Message-Id: <20211220143030.197502732@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
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
index 676f551953060..d3f67271d3c72 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4359,7 +4359,7 @@ void ceph_get_fmode(struct ceph_inode_info *ci, int fmode, int count)
 {
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(ci->vfs_inode.i_sb);
 	int bits = (fmode << 1) | 1;
-	bool is_opened = false;
+	bool already_opened = false;
 	int i;
 
 	if (count == 1)
@@ -4367,19 +4367,19 @@ void ceph_get_fmode(struct ceph_inode_info *ci, int fmode, int count)
 
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



