Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9D4257D08
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbgHaPdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:33:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728064AbgHaPb5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:31:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80C1E214D8;
        Mon, 31 Aug 2020 15:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887917;
        bh=eySNeSs6dVycPr5WJLZaEg/u4b3EQfaJkXxHGmlbQGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L7j6HfL+aopmKHvDTubocV9DZ36iZcoxuRxikgTMlTfgF+d4OL2EvRnMnzkEOdthj
         /5IgF+sPLkYD4KbvWmf5UtEnFNPfqHLoxiav91UsLVjIrZ1Bv+DV3s/l8EiAN/sCHJ
         V1vJV3vBagyk6XXAejxpkGLMl9wHrzB2GKBlxcdk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 4/6] ceph: don't allow setlease on cephfs
Date:   Mon, 31 Aug 2020 11:31:47 -0400
Message-Id: <20200831153150.1024799-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831153150.1024799-1-sashal@kernel.org>
References: <20200831153150.1024799-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 496ceaf12432b3d136dcdec48424312e71359ea7 ]

Leases don't currently work correctly on kcephfs, as they are not broken
when caps are revoked. They could eventually be implemented similarly to
how we did them in libcephfs, but for now don't allow them.

[ idryomov: no need for simple_nosetlease() in ceph_dir_fops and
  ceph_snapdir_fops ]

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index e7ddb23d9bb73..e818344a052cb 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1773,6 +1773,7 @@ const struct file_operations ceph_file_fops = {
 	.mmap = ceph_mmap,
 	.fsync = ceph_fsync,
 	.lock = ceph_lock,
+	.setlease = simple_nosetlease,
 	.flock = ceph_flock,
 	.splice_write = iter_file_splice_write,
 	.unlocked_ioctl = ceph_ioctl,
-- 
2.25.1

