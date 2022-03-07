Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0D54CF6E8
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238323AbiCGJnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240902AbiCGJlk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150A16B093;
        Mon,  7 Mar 2022 01:38:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A7E861052;
        Mon,  7 Mar 2022 09:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C43C340E9;
        Mon,  7 Mar 2022 09:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645916;
        bh=cyWzbIxql255JUsXipN0FGy6Xn/m+PPh2sgzaVi+aJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uC4KOyf2PRbMu4mPH4xX8j97UXlHJbUdeg1Al6iWZVHHScEUcnsZN5shIwG7y4riK
         iJSjn0Fid1HvmkIyjsPH5nkor8Ln4DQl1bzFAgMMqydQ1CNBVYm5Jh9g/3bMcgHcpJ
         fluUEmxE2Yts7hgbOUdq981uosUUyha0qtbqEIeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rick Macklem <rmacklem@uoguelph.ca>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/262] NFSD: Fix verifier returned in stable WRITEs
Date:   Mon,  7 Mar 2022 10:16:59 +0100
Message-Id: <20220307091704.611403510@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 78df038434124..271f7c15d6e52 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -993,6 +993,10 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
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



