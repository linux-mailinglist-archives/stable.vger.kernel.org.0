Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68453366C2B
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 15:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242031AbhDUNLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 09:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241399AbhDUNKs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Apr 2021 09:10:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03E456143B;
        Wed, 21 Apr 2021 13:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619010613;
        bh=d/Kxwex8yL6ysQ5bRXvaV3m6u+RpTx759xF+V/JNs40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EZ4S9jytfSXnRHkVPONLdHM8TSSWtdGdPvG9rvMcjnNq1eDPBrSHhhJV3s8rWI1hD
         8Z6uOA1xgL5w6CNKDE2CB5IgmpthWmgKPYQg9q5wdkyV2A+/LX3uvHjdHXRedHNfpM
         1jCbSO2HcExFAl+5QiwNjC+lAOYq3mSH/zwxDKFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wang6495@umn.edu>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 181/190] Revert "dm ioctl: harden copy_params()'s copy_from_user() from malicious users"
Date:   Wed, 21 Apr 2021 15:00:56 +0200
Message-Id: <20210421130105.1226686-182-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 800a7340ab7dd667edf95e74d8e4f23a17e87076.

Commits from @umn.edu addresses have been found to be submitted in "bad
faith" to try to test the kernel community's ability to review "known
malicious" changes.  The result of these submissions can be found in a
paper published at the 42nd IEEE Symposium on Security and Privacy
entitled, "Open Source Insecurity: Stealthily Introducing
Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University
of Minnesota) and Kangjie Lu (University of Minnesota).

Because of this, all submissions from this group must be reverted from
the kernel tree and will need to be re-reviewed again to determine if
they actually are a valid fix.  Until that work is complete, remove this
change to ensure that no problems are being introduced into the
codebase.

Cc: stable@vger.kernel.org
Cc: Wenwen Wang <wang6495@umn.edu>
Cc: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 1ca65b434f1f..820342de92cd 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1747,7 +1747,8 @@ static void free_params(struct dm_ioctl *param, size_t param_size, int param_fla
 }
 
 static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kernel,
-		       int ioctl_flags, struct dm_ioctl **param, int *param_flags)
+		       int ioctl_flags,
+		       struct dm_ioctl **param, int *param_flags)
 {
 	struct dm_ioctl *dmi;
 	int secure_data;
@@ -1788,13 +1789,18 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kern
 
 	*param_flags |= DM_PARAMS_MALLOC;
 
-	/* Copy from param_kernel (which was already copied from user) */
-	memcpy(dmi, param_kernel, minimum_data_size);
-
-	if (copy_from_user(&dmi->data, (char __user *)user + minimum_data_size,
-			   param_kernel->data_size - minimum_data_size))
+	if (copy_from_user(dmi, user, param_kernel->data_size))
 		goto bad;
+
 data_copied:
+	/*
+	 * Abort if something changed the ioctl data while it was being copied.
+	 */
+	if (dmi->data_size != param_kernel->data_size) {
+		DMERR("rejecting ioctl: data size modified while processing parameters");
+		goto bad;
+	}
+
 	/* Wipe the user buffer so we do not return it to userspace */
 	if (secure_data && clear_user(user, param_kernel->data_size))
 		goto bad;
-- 
2.31.1

