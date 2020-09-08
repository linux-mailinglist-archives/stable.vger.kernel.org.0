Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5719F261EF5
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732515AbgIHT5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:57:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730395AbgIHPfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:35:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E23D224DF;
        Tue,  8 Sep 2020 15:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579304;
        bh=0vtMZTzu1NrMLLIC1iLpFv/vqWhtJrj/0g35C6ArFy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2eGpcpywsmwLob4ix25t5dDnw3RX9f/39gmGVU/BMi/hsU7ol0rUUBQlWXCbsp8J
         KALpvP4bFJY6xA5W1HAcxuvZsXhPya5BtC5MpNVk3rx89TBCAQ8JIdmXm1SdAtZMwD
         awxu+BPOElm9p1LsJyvOzDo6jdGNjJYaP96kEBk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 022/186] ceph: dont allow setlease on cephfs
Date:   Tue,  8 Sep 2020 17:22:44 +0200
Message-Id: <20200908152242.732686168@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d51c3f2fdca02..327649883ec7c 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2507,6 +2507,7 @@ const struct file_operations ceph_file_fops = {
 	.mmap = ceph_mmap,
 	.fsync = ceph_fsync,
 	.lock = ceph_lock,
+	.setlease = simple_nosetlease,
 	.flock = ceph_flock,
 	.splice_read = generic_file_splice_read,
 	.splice_write = iter_file_splice_write,
-- 
2.25.1



