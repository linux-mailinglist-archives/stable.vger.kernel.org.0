Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6BA5B12F6
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 05:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiIHDbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 23:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiIHDbh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 23:31:37 -0400
Received: from mail-ot1-x34a.google.com (mail-ot1-x34a.google.com [IPv6:2607:f8b0:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C41C7433
        for <stable@vger.kernel.org>; Wed,  7 Sep 2022 20:31:36 -0700 (PDT)
Received: by mail-ot1-x34a.google.com with SMTP id p7-20020a9d4547000000b00638eab81488so8951589oti.16
        for <stable@vger.kernel.org>; Wed, 07 Sep 2022 20:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date;
        bh=N49jjBonQ7lb355AKsT1JfpCf3E9KLVmnhlKuufGYLI=;
        b=hpHfrqBf3NQLtQnTVxsUlyMe5Vp9CvI/CxFhKlhX4lEZDzzRP1L/Cpv5ldzz9sNtkf
         QOx9Wapda3R6lG+t5ALzOTVDeBdhOYoNEs1wv9fTu6FWq9R8C6Jvirbrc9FXlOWRCTV1
         VzrZbSCwj6ZRUnbPDgL9f8uXiFjP4vFp+r9lqLUdhIyqaP4+e9u49qZHEN4LxhmUbGIJ
         fwlIdWccSdzZ+rRfzMruZppUHYQYrl6kZtkh6Wl7BO7j5vGao2Kb642bhsbqJBXTWM3H
         S+EMdivN2TLd6GxReHPJANF/lnzQfgk9tF9J25orPRSykfjOz7y43z/L19FVkTKW6/rV
         mE2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date;
        bh=N49jjBonQ7lb355AKsT1JfpCf3E9KLVmnhlKuufGYLI=;
        b=OZNFW6TF6Fe6+j2AyqxesvI8a6lTzcw8l8oYLcVZPeasCo+vExBv0DMu2BZBaj8Pxp
         FqC/UnCx+pKTkT7fy2AI5El42cYxnngF+JY/RI0X7msbquKHMIbzzZ3OZb9piXG3lt6g
         Ha6Xwo5xZtCq8Lar9Gnx/gTXoO53giLOd0EiOHUCgGwYJEdpI6Z2dC2J2DAHXPnB44x5
         MmZnQvKC5vETK2bJrXOFcSYNZQHFmP88ePZz5zrkY19pR6bmFvZtgS1apEV4qd84G0oJ
         EPfvcSOLVLX0FWty1cHIXbRPS+dZ751lH1Bka5osTn8nNxVetYpZr3guMW96wX5fm9Ni
         okdA==
X-Gm-Message-State: ACgBeo1L/fKQ8Nh7rrmFaAAB6lHSsUU4H/l7z2spa5/xDxCC3rkLzWzL
        o7smjSMOWigTTCzONDRxBnM/XL+BXS2wOC/o71KTsVieri3LKhNVNghMjxAit4eO78g59eYh9LF
        MaBRKy7hzAsWsjf73lkNmpRfZhCX0rSSjMXZqyYARWkSef+DSf/cGwFIE1ScVni9j
X-Google-Smtp-Source: AA6agR6CnTD7H471VXCn/ogoPgR9jdDS9GwBjnCyq6S2dfz9ADE1VqWooyxndUZufwXU60s5afQYeezatyNB
X-Received: from kochera.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:ac4])
 (user=kochera job=sendgmr) by 2002:aca:3ac3:0:b0:344:821:525f with SMTP id
 h186-20020aca3ac3000000b003440821525fmr610913oia.63.1662607895640; Wed, 07
 Sep 2022 20:31:35 -0700 (PDT)
Date:   Thu,  8 Sep 2022 03:31:26 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220908033126.2095119-1-kochera@google.com>
Subject: [PATCH 5.10] NFSD: Fix verifier returned in stable WRITEs
From:   Michael Kochera <kochera@google.com>
To:     stable@vger.kernel.org
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Rick Macklem <rmacklem@uoguelph.ca>,
        Michael Kochera <kochera@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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

Reported-by: Rick Macklem <rmacklem@uoguelph.ca>
Link: https://lore.kernel.org/linux-nfs/YQXPR0101MB096857EEACF04A6DF1FC6D9B=
DD749@YQXPR0101MB0968.CANPRD01.PROD.OUTLOOK.COM/T/
Fixes: 19e0663ff9bc ("nfsd: Ensure sampling of the write verifier is atomic=
 with the write")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Michael Kochera <kochera@google.com>
---
Removed down_write to fix the conflict in the cherry-pick. The down_write f=
unctionality was no longer needed there. Upstream commit 555dbf1a9aac6d3150=
c8b52fa35f768a692f4eeb titled nfsd: Replace use of rwsem with errseq_t remo=
ved those and replace it with new functionality that was more scalable. Thi=
s commit is already backported onto 5.10 and so removing down_write ensures=
 consistency with that change. Tested by compiling and booting successfully=
.

 fs/nfsd/vfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index c852bb5ff212..a4ae1fcd2ab1 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1014,6 +1014,10 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh=
 *fhp, struct nfsd_file *nf,
 	iov_iter_kvec(&iter, WRITE, vec, vlen, *cnt);
 	since =3D READ_ONCE(file->f_wb_err);
 	if (flags & RWF_SYNC) {
+		if (verf)
+			nfsd_copy_boot_verifier(verf,
+					net_generic(SVC_NET(rqstp),
+					nfsd_net_id));
 		host_err =3D vfs_iter_write(file, &iter, &pos, flags);
 		if (host_err < 0)
 			nfsd_reset_boot_verifier(net_generic(SVC_NET(rqstp),
--=20
2.37.2.789.g6183377224-goog

