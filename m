Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85ADDFF2FA
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbfKPPnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:43:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:47162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728594AbfKPPnP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:43:15 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3AF82073B;
        Sat, 16 Nov 2019 15:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918995;
        bh=SeClWtWmu8SPnfl/B3POrVHkxrOYMl8AalQ0wd7UWY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJDBLU0BAn49GWFihmNuyHuxqtcmC37sIUvRg/xWEh0Glsp2MkTb5kBgxpVxHl7UW
         6LP1tCbxKMoxoq+tIhxK41GesFHT2Gooi/FsKnqYxfuMSk4xFejQ3+JXCpXVgwlkdg
         rLHK4DW8yNhUFI9MNXOrruCDLFJ55MoSnZhkalwo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Yan, Zheng" <zyan@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 098/237] ceph: fix dentry leak in ceph_readdir_prepopulate
Date:   Sat, 16 Nov 2019 10:38:53 -0500
Message-Id: <20191116154113.7417-98-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Yan, Zheng" <zyan@redhat.com>

[ Upstream commit c58f450bd61511d897efc2ea472c69630635b557 ]

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index acb70a6a82f0f..1e438e0faf77e 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1694,7 +1694,6 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 			if (IS_ERR(realdn)) {
 				err = PTR_ERR(realdn);
 				d_drop(dn);
-				dn = NULL;
 				goto next_item;
 			}
 			dn = realdn;
-- 
2.20.1

