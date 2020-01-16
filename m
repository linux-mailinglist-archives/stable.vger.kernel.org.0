Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E01713F444
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389886AbgAPSsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:48:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:46272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389735AbgAPRJo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:09:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88C0B2468D;
        Thu, 16 Jan 2020 17:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194584;
        bh=2dxMZ0XX0ymzZ5ZeO57n1kVvU7HDxLY2QeDz4UF2+DY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1bI8rzPfR7afFsmovSB974vyQWrF9q3hTaiU/PYdPxWY5YjFKwHyUhCBRyHA/IVyx
         wafS1u18xADnsPCKCN5x/biCU0xT3LisHEvSTkKQc/A7opUtOpDHzUcmJc95p/DDWr
         RBd5Zj1BW6yJu8gcaOk/bu1yBFOkSt4MFre4iCVs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Disseldorp <ddiss@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 457/671] ceph: fix "ceph.dir.rctime" vxattr value
Date:   Thu, 16 Jan 2020 12:01:35 -0500
Message-Id: <20200116170509.12787-194-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Disseldorp <ddiss@suse.de>

[ Upstream commit 718807289d4130be1fe13f24f018733116958070 ]

The vxattr value incorrectly places a "09" prefix to the nanoseconds
field, instead of providing it as a zero-pad width specifier after '%'.

Fixes: 3489b42a72a4 ("ceph: fix three bugs, two in ceph_vxattrcb_file_layout()")
Link: https://tracker.ceph.com/issues/39943
Signed-off-by: David Disseldorp <ddiss@suse.de>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 5e4f3f833e85..a09ce27ab220 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -221,7 +221,7 @@ static size_t ceph_vxattrcb_dir_rbytes(struct ceph_inode_info *ci, char *val,
 static size_t ceph_vxattrcb_dir_rctime(struct ceph_inode_info *ci, char *val,
 				       size_t size)
 {
-	return snprintf(val, size, "%lld.09%ld", ci->i_rctime.tv_sec,
+	return snprintf(val, size, "%lld.%09ld", ci->i_rctime.tv_sec,
 			ci->i_rctime.tv_nsec);
 }
 
-- 
2.20.1

