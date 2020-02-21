Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D67C167705
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730907AbgBUIB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:01:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:33716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731200AbgBUIB0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:01:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2D522073A;
        Fri, 21 Feb 2020 08:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272085;
        bh=hOuaW7/hKWZaEBAmeRmZWycGWtxt52azLEnrtlhg/2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UuSSGp81xMzqQMRbXBSKjylNlSQrGslXoXmQLNUtjiMlkuct51efW5lyhX+G+I/k7
         bG3kN9uI1S+eNKPSmmK/MmO45bQe9m+z8ORNu4tunWelbhmjO9mRle4fNANyGvoFOM
         PlfOW+g96W5t5uRiYwrk3L/IJJxY3gE8lTXZ3tsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 011/344] nfsd4: avoid NULL deference on strange COPY compounds
Date:   Fri, 21 Feb 2020 08:36:50 +0100
Message-Id: <20200221072350.280729321@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit d781e3df710745fbbaee4eb07fd5b64331a1b175 ]

With cross-server COPY we've introduced the possibility that the current
or saved filehandle might not have fh_dentry/fh_export filled in, but we
missed a place that assumed it was.  I think this could be triggered by
a compound like:

	PUTFH(foreign filehandle)
	GETATTR
	SAVEFH
	COPY

First, check_if_stalefh_allowed sets no_verify on the first (PUTFH) op.
Then op_func = nfsd4_putfh runs and leaves current_fh->fh_export NULL.
need_wrongsec_check returns true, since this PUTFH has OP_IS_PUTFH_LIKE
set and GETATTR does not have OP_HANDLES_WRONGSEC set.

We should probably also consider tightening the checks in
check_if_stalefh_allowed and double-checking that we don't assume the
filehandle is verified elsewhere in the compound.  But I think this
fixes the immediate issue.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 4e48f1cccab3 "NFSD: allow inter server COPY to have... "
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 4798667af647c..4d1d0bf8e385f 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -2025,7 +2025,8 @@ nfsd4_proc_compound(struct svc_rqst *rqstp)
 			if (op->opdesc->op_flags & OP_CLEAR_STATEID)
 				clear_current_stateid(cstate);
 
-			if (need_wrongsec_check(rqstp))
+			if (current_fh->fh_export &&
+					need_wrongsec_check(rqstp))
 				op->status = check_nfsd_access(current_fh->fh_export, rqstp);
 		}
 encode_op:
-- 
2.20.1



