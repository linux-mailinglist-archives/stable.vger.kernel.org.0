Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9643C299F9A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410378AbgJZXyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:54:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410368AbgJZXyO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:54:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1923E221F8;
        Mon, 26 Oct 2020 23:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756453;
        bh=/yDi3gbshJFjAfad5LA1t5ZG6Qb0CXX2KU/HWcpfXSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zWAnFK+HLO2+hJ+SYWlpEHncHAzcZfGKYTb++laeeN3tNBdwFBxvbjb8QTysDz+SF
         TPI7fgoq/BgFT3HH8Vg8L7J8H9Wl1Pop5+askc0axtuc6El06PRm9hkmdZcgIgo++a
         S45fNMhH3o9x1iWDuxZK0YJKfDTzBcoqJnI1ts5I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hou Tao <houtao1@huawei.com>, Chuck Lever <chuck.lever@oracle.com>,
        "J . Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 104/132] nfsd: rename delegation related tracepoints to make them less confusing
Date:   Mon, 26 Oct 2020 19:51:36 -0400
Message-Id: <20201026235205.1023962-104-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index cea682ce8aa12..2d568d0e55f78 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5100,7 +5100,7 @@ nfs4_open_delegation(struct svc_fh *fh, struct nfsd4_open *open,
 
 	memcpy(&open->op_delegate_stateid, &dp->dl_stid.sc_stateid, sizeof(dp->dl_stid.sc_stateid));
 
-	trace_nfsd_deleg_open(&dp->dl_stid.sc_stateid);
+	trace_nfsd_deleg_read(&dp->dl_stid.sc_stateid);
 	open->op_delegate_type = NFS4_OPEN_DELEGATE_READ;
 	nfs4_put_stid(&dp->dl_stid);
 	return;
@@ -5217,7 +5217,7 @@ nfsd4_process_open2(struct svc_rqst *rqstp, struct svc_fh *current_fh, struct nf
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
2.25.1

