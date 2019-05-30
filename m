Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE0152F3FE
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729362AbfE3DNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:13:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729353AbfE3DNL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:13:11 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 799A3244B0;
        Thu, 30 May 2019 03:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185990;
        bh=oQi+LBWQl62U/gK8w8KtJLAKDAtJ6dbUAVFw0YbHPF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ln5XVbmamUcWLXJAzvv1AZ2UKrkuWm/zr6eqT1FBvlrdxhxqogaKvpkMaJkaqoFY6
         p2iGq9asZnA18KBuMYPg6RRfcZpNDWp2RN9GkQ3sVMM4AiHP15QxF5LUW/gdmgu0zw
         n1NYGPDr1tFFX/7BprawBiVJfoYEtXJABnbKi+lE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.0 017/346] btrfs: dont double unlock on error in btrfs_punch_hole
Date:   Wed, 29 May 2019 20:01:30 -0700
Message-Id: <20190530030541.523261725@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 8fca955057b9c58467d1b231e43f19c4cf26ae8c upstream.

If we have an error writing out a delalloc range in
btrfs_punch_hole_lock_range we'll unlock the inode and then goto
out_only_mutex, where we will again unlock the inode.  This is bad,
don't do this.

Fixes: f27451f22996 ("Btrfs: add support for fallocate's zero range operation")
CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/file.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2546,10 +2546,8 @@ static int btrfs_punch_hole(struct inode
 
 	ret = btrfs_punch_hole_lock_range(inode, lockstart, lockend,
 					  &cached_state);
-	if (ret) {
-		inode_unlock(inode);
+	if (ret)
 		goto out_only_mutex;
-	}
 
 	path = btrfs_alloc_path();
 	if (!path) {


