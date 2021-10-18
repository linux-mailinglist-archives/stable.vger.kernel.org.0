Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9509B431C8D
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbhJRNmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:42:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233466AbhJRNkQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:40:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14912613A0;
        Mon, 18 Oct 2021 13:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563990;
        bh=UcFL9DfXg+6mbtrclVkILyxxrPYNlGHcFAnxg0JclxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DMqW3HCnM1jxgKDJcyWRa+ILiU8lDD0rbZGl453t8qWwpBKb6bj26O8bvgEwHziVn
         lIPOf4oZ7XCkkPNbXnbrGhzzef86IQ3rSWtw5J9s+ptIVapiLjUNn+C6qo67UvJOoV
         2ahIPBLDQl1dM+YE4Gd/SU5rT3wwkiq85bJhurxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 024/103] btrfs: fix abort logic in btrfs_replace_file_extents
Date:   Mon, 18 Oct 2021 15:24:00 +0200
Message-Id: <20211018132335.521225185@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 4afb912f439c4bc4e6a4f3e7547f2e69e354108f upstream.

Error injection testing uncovered a case where we'd end up with a
corrupt file system with a missing extent in the middle of a file.  This
occurs because the if statement to decide if we should abort is wrong.

The only way we would abort in this case is if we got a ret !=
-EOPNOTSUPP and we called from the file clone code.  However the
prealloc code uses this path too.  Instead we need to abort if there is
an error, and the only error we _don't_ abort on is -EOPNOTSUPP and only
if we came from the clone file code.

CC: stable@vger.kernel.org # 5.10+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2661,14 +2661,16 @@ int btrfs_replace_file_extents(struct in
 					   1, 0, 0, NULL);
 		if (ret != -ENOSPC) {
 			/*
-			 * When cloning we want to avoid transaction aborts when
-			 * nothing was done and we are attempting to clone parts
-			 * of inline extents, in such cases -EOPNOTSUPP is
-			 * returned by __btrfs_drop_extents() without having
-			 * changed anything in the file.
+			 * The only time we don't want to abort is if we are
+			 * attempting to clone a partial inline extent, in which
+			 * case we'll get EOPNOTSUPP.  However if we aren't
+			 * clone we need to abort no matter what, because if we
+			 * got EOPNOTSUPP via prealloc then we messed up and
+			 * need to abort.
 			 */
-			if (extent_info && !extent_info->is_new_extent &&
-			    ret && ret != -EOPNOTSUPP)
+			if (ret &&
+			    (ret != -EOPNOTSUPP ||
+			     (extent_info && extent_info->is_new_extent)))
 				btrfs_abort_transaction(trans, ret);
 			break;
 		}


