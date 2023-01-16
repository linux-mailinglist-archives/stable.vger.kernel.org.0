Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D06AE66C4DA
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbjAPP67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbjAPP6y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:58:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275EA15543
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:58:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF910B81052
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B32C433D2;
        Mon, 16 Jan 2023 15:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884730;
        bh=x+CQql2uWkJfL8VXDIZHWModMjc+mIyKXvPR3o3/VaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bA4CJUS82DEIydAgDtTO8Dlxc9zTrifAUAzOTV05epWVE6GB10GiA2k8nN11jpyVI
         WTf9g1AgoOZTL86j19g2B8bsyLkYhjk7CcXZS9B/qHSjTwis7Jlaxi8A7olvBiMKG7
         O3L9BCqhqNvsuq8T96hAPIG5KaQ1HZr7shF4QKoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 118/183] NFSD: Add an nfsd_file_fsync tracepoint
Date:   Mon, 16 Jan 2023 16:50:41 +0100
Message-Id: <20230116154808.386509619@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit d7064eaf688cfe454c50db9f59298463d80d403c ]

Add a tracepoint to capture the number of filecache-triggered fsync
calls and which files needed it. Also, record when an fsync triggers
a write verifier reset.

Examples:

<...>-97    [007]   262.505611: nfsd_file_free:       inode=0xffff888171e08140 ref=0 flags=GC may=WRITE nf_file=0xffff8881373d2400
<...>-97    [007]   262.505612: nfsd_file_fsync:      inode=0xffff888171e08140 ref=0 flags=GC may=WRITE nf_file=0xffff8881373d2400 ret=0
<...>-97    [007]   262.505623: nfsd_file_free:       inode=0xffff888171e08dc0 ref=0 flags=GC may=WRITE nf_file=0xffff8881373d1e00
<...>-97    [007]   262.505624: nfsd_file_fsync:      inode=0xffff888171e08dc0 ref=0 flags=GC may=WRITE nf_file=0xffff8881373d1e00 ret=0

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Stable-dep-of: 0b3a551fa58b ("nfsd: fix handling of cached open files in nfsd4_open codepath")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c |  5 ++++-
 fs/nfsd/trace.h     | 31 +++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index f54dd6695741..7c673f98f95c 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -314,10 +314,13 @@ static void
 nfsd_file_fsync(struct nfsd_file *nf)
 {
 	struct file *file = nf->nf_file;
+	int ret;
 
 	if (!file || !(file->f_mode & FMODE_WRITE))
 		return;
-	if (vfs_fsync(file, 1) != 0)
+	ret = vfs_fsync(file, 1);
+	trace_nfsd_file_fsync(nf, ret);
+	if (ret)
 		nfsd_reset_write_verifier(net_generic(nf->nf_net, nfsd_net_id));
 }
 
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 55e9e19cb1ec..08e2738adf8f 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -1182,6 +1182,37 @@ DEFINE_EVENT(nfsd_file_lruwalk_class, name,				\
 DEFINE_NFSD_FILE_LRUWALK_EVENT(nfsd_file_gc_removed);
 DEFINE_NFSD_FILE_LRUWALK_EVENT(nfsd_file_shrinker_removed);
 
+TRACE_EVENT(nfsd_file_fsync,
+	TP_PROTO(
+		const struct nfsd_file *nf,
+		int ret
+	),
+	TP_ARGS(nf, ret),
+	TP_STRUCT__entry(
+		__field(void *, nf_inode)
+		__field(int, nf_ref)
+		__field(int, ret)
+		__field(unsigned long, nf_flags)
+		__field(unsigned char, nf_may)
+		__field(struct file *, nf_file)
+	),
+	TP_fast_assign(
+		__entry->nf_inode = nf->nf_inode;
+		__entry->nf_ref = refcount_read(&nf->nf_ref);
+		__entry->ret = ret;
+		__entry->nf_flags = nf->nf_flags;
+		__entry->nf_may = nf->nf_may;
+		__entry->nf_file = nf->nf_file;
+	),
+	TP_printk("inode=%p ref=%d flags=%s may=%s nf_file=%p ret=%d",
+		__entry->nf_inode,
+		__entry->nf_ref,
+		show_nf_flags(__entry->nf_flags),
+		show_nfsd_may_flags(__entry->nf_may),
+		__entry->nf_file, __entry->ret
+	)
+);
+
 #include "cache.h"
 
 TRACE_DEFINE_ENUM(RC_DROPIT);
-- 
2.35.1



