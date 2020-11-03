Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D082A57FB
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731907AbgKCUvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:51:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731885AbgKCUvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:51:05 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B37A22404;
        Tue,  3 Nov 2020 20:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436664;
        bh=105FLhEB9Fme2C0x7n+BQeqVTD7Pll903VhnJOdLitM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v+XSZYQzxXEc9SpqFIvaAkhWNg062vKpKljNmrbUM61xr26hDggihTIG8B6U6IbPT
         RnOMMO1D0hmG6ird5QOQ9Egf6+UZ6EqA7NsmrjiSCC+99jlOQBuOPqtkaC+vyWpFdk
         +RFuHI+TC5J9lYhHtFhguuR4kdjtjGhlfHsqPhx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.9 301/391] NFSv4.2: support EXCHGID4_FLAG_SUPP_FENCE_OPS 4.2 EXCHANGE_ID flag
Date:   Tue,  3 Nov 2020 21:35:52 +0100
Message-Id: <20201103203407.397104235@linuxfoundation.org>
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

From: Olga Kornievskaia <kolga@netapp.com>

commit 8c39076c276be0b31982e44654e2c2357473258a upstream.

RFC 7862 introduced a new flag that either client or server is
allowed to set: EXCHGID4_FLAG_SUPP_FENCE_OPS.

Client needs to update its bitmask to allow for this flag value.

v2: changed minor version argument to unsigned int

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
CC: <stable@vger.kernel.org>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c         |    9 ++++++---
 include/uapi/linux/nfs4.h |    3 +++
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -8052,9 +8052,11 @@ int nfs4_proc_secinfo(struct inode *dir,
  * both PNFS and NON_PNFS flags set, and not having one of NON_PNFS, PNFS, or
  * DS flags set.
  */
-static int nfs4_check_cl_exchange_flags(u32 flags)
+static int nfs4_check_cl_exchange_flags(u32 flags, u32 version)
 {
-	if (flags & ~EXCHGID4_FLAG_MASK_R)
+	if (version >= 2 && (flags & ~EXCHGID4_2_FLAG_MASK_R))
+		goto out_inval;
+	else if (version < 2 && (flags & ~EXCHGID4_FLAG_MASK_R))
 		goto out_inval;
 	if ((flags & EXCHGID4_FLAG_USE_PNFS_MDS) &&
 	    (flags & EXCHGID4_FLAG_USE_NON_PNFS))
@@ -8467,7 +8469,8 @@ static int _nfs4_proc_exchange_id(struct
 	if (status  != 0)
 		goto out;
 
-	status = nfs4_check_cl_exchange_flags(resp->flags);
+	status = nfs4_check_cl_exchange_flags(resp->flags,
+			clp->cl_mvops->minor_version);
 	if (status  != 0)
 		goto out;
 
--- a/include/uapi/linux/nfs4.h
+++ b/include/uapi/linux/nfs4.h
@@ -139,6 +139,8 @@
 
 #define EXCHGID4_FLAG_UPD_CONFIRMED_REC_A	0x40000000
 #define EXCHGID4_FLAG_CONFIRMED_R		0x80000000
+
+#define EXCHGID4_FLAG_SUPP_FENCE_OPS		0x00000004
 /*
  * Since the validity of these bits depends on whether
  * they're set in the argument or response, have separate
@@ -146,6 +148,7 @@
  */
 #define EXCHGID4_FLAG_MASK_A			0x40070103
 #define EXCHGID4_FLAG_MASK_R			0x80070103
+#define EXCHGID4_2_FLAG_MASK_R			0x80070107
 
 #define SEQ4_STATUS_CB_PATH_DOWN		0x00000001
 #define SEQ4_STATUS_CB_GSS_CONTEXTS_EXPIRING	0x00000002


