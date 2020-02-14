Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D81815E635
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392934AbgBNQV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:21:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:55882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405375AbgBNQV0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:21:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DDFE246AE;
        Fri, 14 Feb 2020 16:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697285;
        bh=r6PZK6eZxmiLBusEq9dbpk9JS+rlZUqk08fcxqmtm2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rBu/0/HEb0Qh+ud/eOGcejSXFeczjskyzV9JC6LXHcDMf4+6Yae0LcL5H/zkQxbaF
         vKX8n/oGawTeDhhKYbtyBstWRL+48MZFhaB8yQFgXHBgupHF04eAP9Imq3DSeQHuhj
         Rdl8Mjg+e+NHX/PZglVJc/7XpJEABG5TcjRCkbaw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "J. Bruce Fields" <bfields@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 002/141] nfsd4: avoid NULL deference on strange COPY compounds
Date:   Fri, 14 Feb 2020 11:19:02 -0500
Message-Id: <20200214162122.19794-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162122.19794-1-sashal@kernel.org>
References: <20200214162122.19794-1-sashal@kernel.org>
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
index 66985a6a7047b..33537bbb70b36 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1800,7 +1800,8 @@ nfsd4_proc_compound(struct svc_rqst *rqstp,
 			if (opdesc->op_flags & OP_CLEAR_STATEID)
 				clear_current_stateid(cstate);
 
-			if (need_wrongsec_check(rqstp))
+			if (current_fh->fh_export &&
+					need_wrongsec_check(rqstp))
 				op->status = check_nfsd_access(current_fh->fh_export, rqstp);
 		}
 encode_op:
-- 
2.20.1

