Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2457338EE1C
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233787AbhEXPpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:45:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233201AbhEXPnF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:43:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFB3661446;
        Mon, 24 May 2021 15:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870512;
        bh=ogFyHBqwc8cEz8KsA8L6Q+Hn9skW7uqjYdcqmyQVW4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QpjpBXU7gF3/rJfK1ZCG9wltyI1d6pIKWQBrN+reQy4s7F338nLikDCzrzLIVskuA
         k4XPTM3BsFM3/WAadZyDntu5dB2xgTSQj+pz9CVsspY5cFVgPb0ZpUbgQsUqsNkLA4
         z6/mZ4EuB4ij1XdcXzSVXioq/ipdb4Q9gGDvQIoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 4.19 30/49] Revert "ecryptfs: replace BUG_ON with error handling code"
Date:   Mon, 24 May 2021 17:25:41 +0200
Message-Id: <20210524152325.354855859@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152324.382084875@linuxfoundation.org>
References: <20210524152324.382084875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit e1436df2f2550bc89d832ffd456373fdf5d5b5d7 upstream.

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
Link: https://lore.kernel.org/r/20210503115736.2104747-49-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ecryptfs/crypto.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -325,10 +325,8 @@ static int crypt_scatterlist(struct ecry
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


