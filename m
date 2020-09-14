Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98B34268DC5
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 16:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgINOcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 10:32:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:32960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726653AbgINNGA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 09:06:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E091B221E2;
        Mon, 14 Sep 2020 13:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088711;
        bh=/+g3tl0tKR2B1dR6A3fWUZXSKcXBlnnKwUTXG4CoPQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kuzZvJ0xFgYjt+E6AyTaWiHHCD68YRdtEy73mmd9HNMiamjBCJXo9BQpYqhw9bi1F
         40QpgzlNla9dUWV8uAfK+QpULXXdnr5W85N6PvXR7HzKCL+V1wk9ID9NIs7BdV88dS
         IcepsSZselDht3RpkLPvHU3FuQV11jI4lg28zAbE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/19] NFS: Zero-stateid SETATTR should first return delegation
Date:   Mon, 14 Sep 2020 09:04:50 -0400
Message-Id: <20200914130502.1804708-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130502.1804708-1-sashal@kernel.org>
References: <20200914130502.1804708-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 644c9f40cf71969f29add32f32349e71d4995c0b ]

If a write delegation isn't available, the Linux NFS client uses
a zero-stateid when performing a SETATTR.

NFSv4.0 provides no mechanism for an NFS server to match such a
request to a particular client. It recalls all delegations for that
file, even delegations held by the client issuing the request. If
that client happens to hold a read delegation, the server will
recall it immediately, resulting in an NFS4ERR_DELAY/CB_RECALL/
DELEGRETURN sequence.

Optimize out this pipeline bubble by having the client return any
delegations it may hold on a file before it issues a
SETATTR(zero-stateid) on that file.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 929f1d72bfd39..b2a2ff3f22a46 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3129,8 +3129,10 @@ static int _nfs4_do_setattr(struct inode *inode,
 
 	/* Servers should only apply open mode checks for file size changes */
 	truncate = (arg->iap->ia_valid & ATTR_SIZE) ? true : false;
-	if (!truncate)
+	if (!truncate) {
+		nfs4_inode_make_writeable(inode);
 		goto zero_stateid;
+	}
 
 	if (nfs4_copy_delegation_stateid(inode, FMODE_WRITE, &arg->stateid, &delegation_cred)) {
 		/* Use that stateid */
-- 
2.25.1

