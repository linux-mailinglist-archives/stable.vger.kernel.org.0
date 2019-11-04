Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 182C3EEC70
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388525AbfKDV5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:57:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:53014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388522AbfKDV5E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:57:04 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B078217F4;
        Mon,  4 Nov 2019 21:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904624;
        bh=zVWc36t1YQ5i5dLYsdN3Ycb+XDGeIMymeTrjmDPd9qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yKjXgDvoC8C+4ZdysWzcyLbUPwHeNVS3//6YNMJm6r3MNVaUocaFawP5Xw8HSqwwu
         sx8tRqtfrGjoFlGZ6NM1DUNB0h6PfJ0T9VF/nFa0uSdtH6Qs2O+CNHRx58spT2wcoN
         tvUGS1MNtGvkB/wYDb2hs79eeqVoAtBNM84RaCR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 013/149] f2fs: fix to recover inodes i_gc_failures during POR
Date:   Mon,  4 Nov 2019 22:43:26 +0100
Message-Id: <20191104212133.227576779@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 7de36cf3e4087207f42a88992f8cb615a1bd902e ]

inode.i_gc_failures is used to indicate that skip count of migrating
on blocks of inode, we should guarantee it can be recovered in sudden
power-off case.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/recovery.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 0b224f4a4a656..281ba46b5b359 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -226,6 +226,8 @@ static void recover_inode(struct inode *inode, struct page *page)
 
 	F2FS_I(inode)->i_advise = raw->i_advise;
 	F2FS_I(inode)->i_flags = le32_to_cpu(raw->i_flags);
+	F2FS_I(inode)->i_gc_failures[GC_FAILURE_PIN] =
+				le16_to_cpu(raw->i_gc_failures);
 
 	recover_inline_flags(inode, raw);
 
-- 
2.20.1



