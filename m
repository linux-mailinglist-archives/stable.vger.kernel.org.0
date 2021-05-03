Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 583003714D9
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 14:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbhECMBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 08:01:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233923AbhECMBS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 08:01:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F04F611CB;
        Mon,  3 May 2021 12:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620043224;
        bh=MttyNQKIwc0lucJwVJav+gnoUjqzaL/FX+Ne9Af//ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ecDCOlPHU1I0SfiSjz1JV+T/BZgbL2pSAA6UTMr47ZigrIKv3TpIrTE/51Rg6W8oi
         YdOOcDY8Zkb1JN1wENYu6SwjU6aMta+R6qQ3KgmIgnVRYHGfEqGMLvb1MaKLYCUZNL
         2E3bJS8TOPbtXUnEUXWk4S4KogG6mxTzEAODIXY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aditya Pakki <pakki001@umn.edu>,
        stable <stable@vger.kernel.org>, Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 48/69] Revert "ecryptfs: replace BUG_ON with error handling code"
Date:   Mon,  3 May 2021 13:57:15 +0200
Message-Id: <20210503115736.2104747-49-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 2c2a7552dd6465e8fde6bc9cccf8d66ed1c1eb72.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

The original commit log for this change was incorrect, no "error
handling code" was added, things will blow up just as badly as before if
any of these cases ever were true.  As this BUG_ON() never fired, and
most of these checks are "obviously" never going to be true, let's just
revert to the original code for now until this gets unwound to be done
correctly in the future.

Cc: Aditya Pakki <pakki001@umn.edu>
Fixes: 2c2a7552dd64 ("ecryptfs: replace BUG_ON with error handling code")
Cc: stable <stable@vger.kernel.org>
Acked-by: Tyler Hicks <code@tyhicks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ecryptfs/crypto.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 943e523f4c9d..3d8623139538 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -296,10 +296,8 @@ static int crypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
 	struct extent_crypt_result ecr;
 	int rc = 0;
 
-	if (!crypt_stat || !crypt_stat->tfm
-	       || !(crypt_stat->flags & ECRYPTFS_STRUCT_INITIALIZED))
-		return -EINVAL;
-
+	BUG_ON(!crypt_stat || !crypt_stat->tfm
+	       || !(crypt_stat->flags & ECRYPTFS_STRUCT_INITIALIZED));
 	if (unlikely(ecryptfs_verbosity > 0)) {
 		ecryptfs_printk(KERN_DEBUG, "Key size [%zd]; key:\n",
 				crypt_stat->key_size);
-- 
2.31.1

