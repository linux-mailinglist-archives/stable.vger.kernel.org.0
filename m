Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9F3257D94
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbgHaPiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:38:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728550AbgHaPaO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:30:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AC2B20767;
        Mon, 31 Aug 2020 15:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887814;
        bh=enPaakcvPoIVnN5PoXGGX7Ex4yMClA/+TEGHC+05xf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SpUsS9h59eRyWCiWfYxY1/llhcIZi+OTLbzc2BHD3mOaxPYzliIO4wMIjWYd3Yfwr
         aliK2vMe8VHdJ8doAltYZ8NVDC+1FdJGvDuglwX5XEbTUZsTmQGjG6TOXsPzvQ8UGN
         ZicyYFumvibmi+20QgZbdgvEq7OCAfjNCAKCC5Qw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 26/42] ceph: don't allow setlease on cephfs
Date:   Mon, 31 Aug 2020 11:29:18 -0400
Message-Id: <20200831152934.1023912-26-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831152934.1023912-1-sashal@kernel.org>
References: <20200831152934.1023912-1-sashal@kernel.org>
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
index 26172bb90a459..c53c1499f7c58 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2506,6 +2506,7 @@ const struct file_operations ceph_file_fops = {
 	.mmap = ceph_mmap,
 	.fsync = ceph_fsync,
 	.lock = ceph_lock,
+	.setlease = simple_nosetlease,
 	.flock = ceph_flock,
 	.splice_read = generic_file_splice_read,
 	.splice_write = iter_file_splice_write,
-- 
2.25.1

