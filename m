Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B4827C984
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731981AbgI2MLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730170AbgI2Lhe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E32B823BCC;
        Tue, 29 Sep 2020 11:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379325;
        bh=g0NxPaLUH25RIJMieX+Tqdsx/JOw+OMOnQXkcYKo0Y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H+a4T9+RbssAY/fiyMv/JTdi6RyoS7iTj6gsXwfClkQ+++tvd6PlEXXiCNnsh0jx2
         gZSStoM9DkZqT+HmBUj2ZOaX+1/6xGD1nfp/QvZW3rDXsSlNMLVRnpN1PFEPyN2rjP
         Smm1lIh5jfIuaZBfnCp8Zh9xg1ec/OSYxTI/Mers=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 112/388] nfsd: Fix a perf warning
Date:   Tue, 29 Sep 2020 12:57:23 +0200
Message-Id: <20200929110015.899018811@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

[ Upstream commit a9ceb060b3cf37987b6162223575eaf4f4e0fc36 ]

perf does not know how to deal with a __builtin_bswap32() call, and
complains. All other functions just store the xid etc in host endian
form, so let's do that in the tracepoint for nfsd_file_acquire too.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/trace.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index ffc78a0e28b24..b073bdc2e6e89 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -228,7 +228,7 @@ TRACE_EVENT(nfsd_file_acquire,
 	TP_ARGS(rqstp, hash, inode, may_flags, nf, status),
 
 	TP_STRUCT__entry(
-		__field(__be32, xid)
+		__field(u32, xid)
 		__field(unsigned int, hash)
 		__field(void *, inode)
 		__field(unsigned int, may_flags)
@@ -236,11 +236,11 @@ TRACE_EVENT(nfsd_file_acquire,
 		__field(unsigned long, nf_flags)
 		__field(unsigned char, nf_may)
 		__field(struct file *, nf_file)
-		__field(__be32, status)
+		__field(u32, status)
 	),
 
 	TP_fast_assign(
-		__entry->xid = rqstp->rq_xid;
+		__entry->xid = be32_to_cpu(rqstp->rq_xid);
 		__entry->hash = hash;
 		__entry->inode = inode;
 		__entry->may_flags = may_flags;
@@ -248,15 +248,15 @@ TRACE_EVENT(nfsd_file_acquire,
 		__entry->nf_flags = nf ? nf->nf_flags : 0;
 		__entry->nf_may = nf ? nf->nf_may : 0;
 		__entry->nf_file = nf ? nf->nf_file : NULL;
-		__entry->status = status;
+		__entry->status = be32_to_cpu(status);
 	),
 
 	TP_printk("xid=0x%x hash=0x%x inode=0x%p may_flags=%s ref=%d nf_flags=%s nf_may=%s nf_file=0x%p status=%u",
-			be32_to_cpu(__entry->xid), __entry->hash, __entry->inode,
+			__entry->xid, __entry->hash, __entry->inode,
 			show_nf_may(__entry->may_flags), __entry->nf_ref,
 			show_nf_flags(__entry->nf_flags),
 			show_nf_may(__entry->nf_may), __entry->nf_file,
-			be32_to_cpu(__entry->status))
+			__entry->status)
 );
 
 DECLARE_EVENT_CLASS(nfsd_file_search_class,
-- 
2.25.1



