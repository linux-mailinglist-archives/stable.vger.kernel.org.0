Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7881630BC
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 20:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgBRT4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 14:56:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:32928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbgBRT4B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 14:56:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D9C624654;
        Tue, 18 Feb 2020 19:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582055760;
        bh=EwYfUOnmtfFffy16it4zCFunWeADkB2Shz4MSOMEUtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PdKELo90mNYYxPPqHSGRxthlvU8eskUZk0+FqtLNaURKCatbB9n3nuSFiL9cFfDh9
         3K8yF4U4213dIRkwWNePG4YGSDRRtQxPywZ+Lc46/1EOzSFEePXbOG+Ojoe+HLxOmk
         GnqB5lWW+JG/tbdeJQSdta0pmCchcgpLK8Xh4288=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.19 11/38] ext4: dont assume that mmp_nodename/bdevname have NUL
Date:   Tue, 18 Feb 2020 20:54:57 +0100
Message-Id: <20200218190419.890176107@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190418.536430858@linuxfoundation.org>
References: <20200218190418.536430858@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Dilger <adilger@dilger.ca>

commit 14c9ca0583eee8df285d68a0e6ec71053efd2228 upstream.

Don't assume that the mmp_nodename and mmp_bdevname strings are NUL
terminated, since they are filled in by snprintf(), which is not
guaranteed to do so.

Link: https://lore.kernel.org/r/1580076215-1048-1-git-send-email-adilger@dilger.ca
Signed-off-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/mmp.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -120,10 +120,10 @@ void __dump_mmp_msg(struct super_block *
 {
 	__ext4_warning(sb, function, line, "%s", msg);
 	__ext4_warning(sb, function, line,
-		       "MMP failure info: last update time: %llu, last update "
-		       "node: %s, last update device: %s",
-		       (long long unsigned int) le64_to_cpu(mmp->mmp_time),
-		       mmp->mmp_nodename, mmp->mmp_bdevname);
+		       "MMP failure info: last update time: %llu, last update node: %.*s, last update device: %.*s",
+		       (unsigned long long)le64_to_cpu(mmp->mmp_time),
+		       (int)sizeof(mmp->mmp_nodename), mmp->mmp_nodename,
+		       (int)sizeof(mmp->mmp_bdevname), mmp->mmp_bdevname);
 }
 
 /*
@@ -154,6 +154,7 @@ static int kmmpd(void *data)
 	mmp_check_interval = max(EXT4_MMP_CHECK_MULT * mmp_update_interval,
 				 EXT4_MMP_MIN_CHECK_INTERVAL);
 	mmp->mmp_check_interval = cpu_to_le16(mmp_check_interval);
+	BUILD_BUG_ON(sizeof(mmp->mmp_bdevname) < BDEVNAME_SIZE);
 	bdevname(bh->b_bdev, mmp->mmp_bdevname);
 
 	memcpy(mmp->mmp_nodename, init_utsname()->nodename,
@@ -375,7 +376,8 @@ skip:
 	/*
 	 * Start a kernel thread to update the MMP block periodically.
 	 */
-	EXT4_SB(sb)->s_mmp_tsk = kthread_run(kmmpd, mmpd_data, "kmmpd-%s",
+	EXT4_SB(sb)->s_mmp_tsk = kthread_run(kmmpd, mmpd_data, "kmmpd-%.*s",
+					     (int)sizeof(mmp->mmp_bdevname),
 					     bdevname(bh->b_bdev,
 						      mmp->mmp_bdevname));
 	if (IS_ERR(EXT4_SB(sb)->s_mmp_tsk)) {


