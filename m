Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A18499A6E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378830AbiAXVoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:44:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46694 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454734AbiAXVdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:33:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06320B81057;
        Mon, 24 Jan 2022 21:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380ECC340E4;
        Mon, 24 Jan 2022 21:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060008;
        bh=7OxJk9zzdj4xIrQaDWWQlHUaJmsfEp+0ewrq52q3dwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SCxHRnJphGOsgIL8RQBFCmTPaf+otoHnubVjKI9dlYZsE6VHKTWkWrNcZ5eQ5qsfq
         VMjBSQeOhZQul+mFnIIimqYY7rNAZ7G8cCNVCxIO7bj1iO2CroMrCbYq5fz2CT2eXg
         VPRy+/O9LqtfGSPEjhlY+JGs1VJyGNQT7reZYqzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rick Macklem <rmacklem@uoguelph.ca>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0809/1039] NFSD: Fix verifier returned in stable WRITEs
Date:   Mon, 24 Jan 2022 19:43:18 +0100
Message-Id: <20220124184152.507995571@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit f11ad7aa653130b71e2e89bed207f387718216d5 ]

RFC 8881 explains the purpose of the write verifier this way:

> The final portion of the result is the field writeverf. This field
> is the write verifier and is a cookie that the client can use to
> determine whether a server has changed instance state (e.g., server
> restart) between a call to WRITE and a subsequent call to either
> WRITE or COMMIT.

But then it says:

> This cookie MUST be unchanged during a single instance of the
> NFSv4.1 server and MUST be unique between instances of the NFSv4.1
> server. If the cookie changes, then the client MUST assume that
> any data written with an UNSTABLE4 value for committed and an old
> writeverf in the reply has been lost and will need to be
> recovered.

RFC 1813 has similar language for NFSv3. NFSv2 does not have a write
verifier since it doesn't implement the COMMIT procedure.

Since commit 19e0663ff9bc ("nfsd: Ensure sampling of the write
verifier is atomic with the write"), the Linux NFS server has
returned a boot-time-based verifier for UNSTABLE WRITEs, but a zero
verifier for FILE_SYNC and DATA_SYNC WRITEs. FILE_SYNC and DATA_SYNC
WRITEs are not followed up with a COMMIT, so there's no need for
clients to compare verifiers for stable writes.

However, by returning a different verifier for stable and unstable
writes, the above commit puts the Linux NFS server a step farther
out of compliance with the first MUST above. At least one NFS client
(FreeBSD) noticed the difference, making this a potential
regression.

Reported-by: Rick Macklem <rmacklem@uoguelph.ca>
Link: https://lore.kernel.org/linux-nfs/YQXPR0101MB096857EEACF04A6DF1FC6D9BDD749@YQXPR0101MB0968.CANPRD01.PROD.OUTLOOK.COM/T/
Fixes: 19e0663ff9bc ("nfsd: Ensure sampling of the write verifier is atomic with the write")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index c99857689e2c2..7f2472e4b88f9 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -987,6 +987,10 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 	iov_iter_kvec(&iter, WRITE, vec, vlen, *cnt);
 	if (flags & RWF_SYNC) {
 		down_write(&nf->nf_rwsem);
+		if (verf)
+			nfsd_copy_boot_verifier(verf,
+					net_generic(SVC_NET(rqstp),
+					nfsd_net_id));
 		host_err = vfs_iter_write(file, &iter, &pos, flags);
 		if (host_err < 0)
 			nfsd_reset_boot_verifier(net_generic(SVC_NET(rqstp),
-- 
2.34.1



