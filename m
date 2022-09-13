Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1075B7488
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236027AbiIMPWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbiIMPWE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:22:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57AB7B7A0;
        Tue, 13 Sep 2022 07:36:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF807B80FA6;
        Tue, 13 Sep 2022 14:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A649C433D6;
        Tue, 13 Sep 2022 14:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078911;
        bh=lUDWtF7U9ywnCODZtv5uQR2taTIVyThCDhb0jCdN7jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/1AuThe4f+hx/cVTGdhM/4WETS8H98zrHgseZZhQvvH16attJe4QQkhQF1k84HR7
         ePWjdPE7fsGOdT8kW2cyZle4aUJpjh3z9P1mmkH1HZrUHx4HragRafY7lhELjK6VYh
         K1OLsDZZ0YWBZ8G/UJLJfQUqcS0WWIWSYLmao/4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rick Macklem <rmacklem@uoguelph.ca>,
        Chuck Lever <chuck.lever@oracle.com>,
        Michael Kochera <kochera@google.com>
Subject: [PATCH 5.10 01/79] NFSD: Fix verifier returned in stable WRITEs
Date:   Tue, 13 Sep 2022 16:04:06 +0200
Message-Id: <20220913140350.359903417@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
References: <20220913140350.291927556@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit f11ad7aa653130b71e2e89bed207f387718216d5 upstream.

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

[Removed down_write to fix the conflict in the cherry-pick. The
down_write functionality was no longer needed there. Upstream commit
555dbf1a9aac6d3150c8b52fa35f768a692f4eeb titled nfsd: Replace use of
rwsem with errseq_t removed those and replace it with new functionality
that was more scalable. This commit is already backported onto 5.10 and
so removing down_write ensures consistency with that change. Tested by
compiling and booting successfully. - kochera]

Reported-by: Rick Macklem <rmacklem@uoguelph.ca>
Link: https://lore.kernel.org/linux-nfs/YQXPR0101MB096857EEACF04A6DF1FC6D9BDD749@YQXPR0101MB0968.CANPRD01.PROD.OUTLOOK.COM/T/
Fixes: 19e0663ff9bc ("nfsd: Ensure sampling of the write verifier is atomic with the write")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Michael Kochera <kochera@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/vfs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1014,6 +1014,10 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 	iov_iter_kvec(&iter, WRITE, vec, vlen, *cnt);
 	since = READ_ONCE(file->f_wb_err);
 	if (flags & RWF_SYNC) {
+		if (verf)
+			nfsd_copy_boot_verifier(verf,
+					net_generic(SVC_NET(rqstp),
+					nfsd_net_id));
 		host_err = vfs_iter_write(file, &iter, &pos, flags);
 		if (host_err < 0)
 			nfsd_reset_boot_verifier(net_generic(SVC_NET(rqstp),


