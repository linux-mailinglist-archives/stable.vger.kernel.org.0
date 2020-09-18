Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E56426F39C
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgIRDHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:07:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727121AbgIRCDk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:03:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22599235F9;
        Fri, 18 Sep 2020 02:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394615;
        bh=g0NxPaLUH25RIJMieX+Tqdsx/JOw+OMOnQXkcYKo0Y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kiTzZ1o68vi3z/K06KCo+BhYqajGi41zL4o2uwg5RSBRSh3wz0mztVptqgVA2lrrF
         40Ororr7ghQi5fA8V69EumLvmHOv21nOuCW0IhPv5uvke+aFgqS39U7L/zYukrvj9S
         YN1UgOtu3bmzjY9h4oZpbcXXXkTYz/GogkkPc0TI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trondmy@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "J . Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 118/330] nfsd: Fix a perf warning
Date:   Thu, 17 Sep 2020 21:57:38 -0400
Message-Id: <20200918020110.2063155-118-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

