Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D272B6381
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732489AbgKQNik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:38:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:47932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732853AbgKQNgz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:36:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C624120780;
        Tue, 17 Nov 2020 13:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620215;
        bh=5chNI52tjZEY8XlpZjeJ7rSm/KurCIeRPXa6E6EFi/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bkbEwXrl2pyK3SzmSDQ/FBgHC/ARHOk81UyQZqvHjETzmyWr4k6lgngA/nMSRTX9W
         Za65Syk+IgkIqTtyLphVDpdLiBanGCP/+FKoJNVo4vDyWHKAzs9q8iGXCg2agEBs8P
         cWlFaxecIT6TFlHsX72Spz2JpC8WMqYTADNqV+JI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dai Ngo <dai.ngo@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 144/255] NFSD: Fix use-after-free warning when doing inter-server copy
Date:   Tue, 17 Nov 2020 14:04:44 +0100
Message-Id: <20201117122145.959037674@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 36e1e5ba90fb3fba6888fae26e4dfc28bf70aaf1 ]

The source file nfsd_file is not constructed the same as other
nfsd_file's via nfsd_file_alloc. nfsd_file_put should not be
called to free the object; nfsd_file_put is not the inverse of
kzalloc, instead kfree is called by nfsd4_do_async_copy when done.

Fixes: ce0887ac96d3 ("NFSD add nfs4 inter ssc to nfsd4_copy")
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 84e10aef14175..80effaa18b7b2 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1299,7 +1299,7 @@ nfsd4_cleanup_inter_ssc(struct vfsmount *ss_mnt, struct nfsd_file *src,
 			struct nfsd_file *dst)
 {
 	nfs42_ssc_close(src->nf_file);
-	nfsd_file_put(src);
+	/* 'src' is freed by nfsd4_do_async_copy */
 	nfsd_file_put(dst);
 	mntput(ss_mnt);
 }
-- 
2.27.0



