Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30C6C121504
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731347AbfLPSR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:17:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:41326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731359AbfLPSRZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:17:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E79720717;
        Mon, 16 Dec 2019 18:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520245;
        bh=h6h2iKDlws2XsM3EJFa8ad3Lcnw7rBJHFhzCA/7wLyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N2ohEk6nNTvaidl6n5EHFj0GA4lHmw0YVYtp4WFvZd4Kh8cfuUWByLp7QRUV3f/9+
         2R80CwPgUNpw1ceLG6M7aV8uubA3xL72r8JwF8FFxRWEuXS6rymTKzoT0JFe89A5Bg
         1jinT71E4QeKyD510/aI5a18MT7Wm4VdOsRks3fY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 074/177] btrfs: record all roots for rename exchange on a subvol
Date:   Mon, 16 Dec 2019 18:48:50 +0100
Message-Id: <20191216174835.561413372@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 3e1740993e43116b3bc71b0aad1e6872f6ccf341 upstream.

Testing with the new fsstress support for subvolumes uncovered a pretty
bad problem with rename exchange on subvolumes.  We're modifying two
different subvolumes, but we only start the transaction on one of them,
so the other one is not added to the dirty root list.  This is caught by
btrfs_cow_block() with a warning because the root has not been updated,
however if we do not modify this root again we'll end up pointing at an
invalid root because the root item is never updated.

Fix this by making sure we add the destination root to the trans list,
the same as we do with normal renames.  This fixes the corruption.

Fixes: cdd1fedf8261 ("btrfs: add support for RENAME_EXCHANGE and RENAME_WHITEOUT")
CC: stable@vger.kernel.org # 4.9+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9554,6 +9554,9 @@ static int btrfs_rename_exchange(struct
 		goto out_notrans;
 	}
 
+	if (dest != root)
+		btrfs_record_root_in_trans(trans, dest);
+
 	/*
 	 * We need to find a free sequence number both in the source and
 	 * in the destination directory for the exchange.


