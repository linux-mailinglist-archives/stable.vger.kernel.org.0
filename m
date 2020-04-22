Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE5F1B3F08
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730451AbgDVKds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:33:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:33070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730442AbgDVKYj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:24:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9EBC2076B;
        Wed, 22 Apr 2020 10:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551079;
        bh=nSl82cjhWjTA2l0ExvViT8VlR3vIJzSYqkYo4UEfc7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VbalytijCIGa1NMsDWsQ7PrkghfjQ5CIiQcHcto3a+rWTaGmiB+2ibZN/xDMsG0sx
         GVHhLL/JVL87/1crP5uzJI0yWTlZqDq19+c6n0mVk8qCo2xC9lMU9fQtM3dIhdhnBD
         U76Q8xG/pdlr+7UhFiGQfd/yxK1qUDHHEIL/iu9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liwei Song <liwei.song@windriver.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 092/166] nfsroot: set tcp as the default transport protocol
Date:   Wed, 22 Apr 2020 11:56:59 +0200
Message-Id: <20200422095058.585634101@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



