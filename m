Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E011AA2D3
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897098AbgDOLf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:35:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408893AbgDOLfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:35:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9006B20737;
        Wed, 15 Apr 2020 11:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950550;
        bh=nSl82cjhWjTA2l0ExvViT8VlR3vIJzSYqkYo4UEfc7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LYA+w9keah0mVOldlZDFaQUHhTqPrw9o4qcpomBXibVkzAYCY4LP5xIFPx9q+F2iQ
         TOSqTk63sE8mjc0pkCi+MbIw1oWf2zBzT5uoMp4c8ZdTyRIdc0dpTpbsWaZORG0Phh
         WSKlO2+PjIR4s64CIr6amGNt9lF/gCxlA6tgdlAc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Liwei Song <liwei.song@windriver.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 056/129] nfsroot: set tcp as the default transport protocol
Date:   Wed, 15 Apr 2020 07:33:31 -0400
Message-Id: <20200415113445.11881-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liwei Song <liwei.song@windriver.com>

[ Upstream commit 89c8023fd46167a41246a56b31d1b3c9a20b6970 ]

UDP is disabled by default in commit b24ee6c64ca7 ("NFS: allow
deprecation of NFS UDP protocol"), but the default mount options
is still udp, change it to tcp to avoid the "Unsupported transport
protocol udp" error if no protocol is specified when mount nfs.

Fixes: b24ee6c64ca7 ("NFS: allow deprecation of NFS UDP protocol")
Signed-off-by: Liwei Song <liwei.song@windriver.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfsroot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/nfsroot.c b/fs/nfs/nfsroot.c
index effaa4247b912..8d32788056022 100644
--- a/fs/nfs/nfsroot.c
+++ b/fs/nfs/nfsroot.c
@@ -88,7 +88,7 @@
 #define NFS_ROOT		"/tftpboot/%s"
 
 /* Default NFSROOT mount options. */
-#define NFS_DEF_OPTIONS		"vers=2,udp,rsize=4096,wsize=4096"
+#define NFS_DEF_OPTIONS		"vers=2,tcp,rsize=4096,wsize=4096"
 
 /* Parameters passed from the kernel command line */
 static char nfs_root_parms[NFS_MAXPATHLEN + 1] __initdata = "";
-- 
2.20.1

