Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC4B715EAC8
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391870AbgBNQLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:11:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:38886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391582AbgBNQLx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:11:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E19B246A2;
        Fri, 14 Feb 2020 16:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696712;
        bh=+NmEuyq8mQFGbLYQc1FS3z+h4kYdwClNqmJPSq+cznk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JHHKm5D2ZIZ8eMhRmjK3JxaCxi7zdswDBHOerAUN1RrbkgulFFEzIaxoGvWYaEeiU
         H1Aj+/gLMEe3rSP/RoYZbwGAs78Rv7ChuB7N1uEA36UoDhAyYBmXK6uO1JhQE4LBV6
         8VMhV9KsYoLWTc24VMBhajEGDUBT0yXuRNTMiMsE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "J. Bruce Fields" <bfields@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 003/252] nfsd4: avoid NULL deference on strange COPY compounds
Date:   Fri, 14 Feb 2020 11:07:38 -0500
Message-Id: <20200214161147.15842-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

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
index f35aa9f88b5ec..895123518fd42 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1789,7 +1789,8 @@ nfsd4_proc_compound(struct svc_rqst *rqstp)
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

