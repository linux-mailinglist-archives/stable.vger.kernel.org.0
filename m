Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5E72A51B8
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729989AbgKCUn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:43:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:57060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729975AbgKCUn0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:43:26 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3795223BD;
        Tue,  3 Nov 2020 20:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436205;
        bh=zK8AFSQCnRbeuUx9B08AYtNjuUAlRHYtfJ1bJH3r/F8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c5eMu782RG6/vipVhR1+hFh1vuuJ7mhVuxZdbsuGzXAscCrb+uexfzoNStFwTIqIS
         hgxr2m3JnHZ3S1P1jeW8vvHI0iwiqlqdC/Dw/PVj+Y5CPiGbDfTMmU98CrjxJYRbKG
         vPFtHCHqg+n1lVk9helFicjwCli7NDYgSyR13eXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Hou Tao <houtao1@huawei.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 149/391] nfsd: rename delegation related tracepoints to make them less confusing
Date:   Tue,  3 Nov 2020 21:33:20 +0100
Message-Id: <20201103203356.885885454@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 3caf91757ced158e6c4a44d8b105bd7b3e1767d8 ]

Now when a read delegation is given, two delegation related traces
will be printed:

    nfsd_deleg_open: client 5f45b854:e6058001 stateid 00000030:00000001
    nfsd_deleg_none: client 5f45b854:e6058001 stateid 0000002f:00000001

Although the intention is to let developers know two stateid are
returned, the traces are confusing about whether or not a read delegation
is handled out. So renaming trace_nfsd_deleg_none() to trace_nfsd_open()
and trace_nfsd_deleg_open() to trace_nfsd_deleg_read() to make
the intension clearer.

The patched traces will be:

    nfsd_deleg_read: client 5f48a967:b55b21cd stateid 00000003:00000001
    nfsd_open: client 5f48a967:b55b21cd stateid 00000002:00000001

Suggested-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 4 ++--
 fs/nfsd/trace.h     | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index c09a2a4281ec9..0525acfe31314 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5126,7 +5126,7 @@ nfs4_open_delegation(struct svc_fh *fh, struct nfsd4_open *open,
 
 	memcpy(&open->op_delegate_stateid, &dp->dl_stid.sc_stateid, sizeof(dp->dl_stid.sc_stateid));
 
-	trace_nfsd_deleg_open(&dp->dl_stid.sc_stateid);
+	trace_nfsd_deleg_read(&dp->dl_stid.sc_stateid);
 	open->op_delegate_type = NFS4_OPEN_DELEGATE_READ;
 	nfs4_put_stid(&dp->dl_stid);
 	return;
@@ -5243,7 +5243,7 @@ nfsd4_process_open2(struct svc_rqst *rqstp, struct svc_fh *current_fh, struct nf
 	nfs4_open_delegation(current_fh, open, stp);
 nodeleg:
 	status = nfs_ok;
-	trace_nfsd_deleg_none(&stp->st_stid.sc_stateid);
+	trace_nfsd_open(&stp->st_stid.sc_stateid);
 out:
 	/* 4.1 client trying to upgrade/downgrade delegation? */
 	if (open->op_delegate_type == NFS4_OPEN_DELEGATE_NONE && dp &&
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 1861db1bdc670..99bf07800cd09 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -289,8 +289,8 @@ DEFINE_STATEID_EVENT(layout_recall_done);
 DEFINE_STATEID_EVENT(layout_recall_fail);
 DEFINE_STATEID_EVENT(layout_recall_release);
 
-DEFINE_STATEID_EVENT(deleg_open);
-DEFINE_STATEID_EVENT(deleg_none);
+DEFINE_STATEID_EVENT(open);
+DEFINE_STATEID_EVENT(deleg_read);
 DEFINE_STATEID_EVENT(deleg_break);
 DEFINE_STATEID_EVENT(deleg_recall);
 
-- 
2.27.0



