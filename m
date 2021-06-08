Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F9F3A0283
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbhFHTGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:06:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236270AbhFHTC6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:02:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3236613FE;
        Tue,  8 Jun 2021 18:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177907;
        bh=rXuMDTDdlZKIcwXwbthMZb6vebSQQc2+MVKcMhO0BIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pqSE1kDkaAIu3l8/NtTBdgoz9V7rjeahZ3Qd9mZeD+FV2PR9vYxAC7HZiW52iS79H
         5zrWFiFry9eKERbKCWrzGylTMbTUNhR1q+d/zgjUt/CDsGLLnOfa1HW3TMA2DXJPQ5
         QuDEMCddOsoQT1mJz3vbMKz2sbhPEYKYGL/SaT+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 120/137] btrfs: fix error handling in btrfs_del_csums
Date:   Tue,  8 Jun 2021 20:27:40 +0200
Message-Id: <20210608175946.430192399@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit b86652be7c83f70bf406bed18ecf55adb9bfb91b upstream.

Error injection stress would sometimes fail with checksums on disk that
did not have a corresponding extent.  This occurred because the pattern
in btrfs_del_csums was

	while (1) {
		ret = btrfs_search_slot();
		if (ret < 0)
			break;
	}
	ret = 0;
out:
	btrfs_free_path(path);
	return ret;

If we got an error from btrfs_search_slot we'd clear the error because
we were breaking instead of goto out.  Instead of using goto out, simply
handle the cases where we may leave a random value in ret, and get rid
of the

	ret = 0;
out:

pattern and simply allow break to have the proper error reporting.  With
this fix we properly abort the transaction and do not commit thinking we
successfully deleted the csum.

Reviewed-by: Qu Wenruo <wqu@suse.com>
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file-item.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -690,7 +690,7 @@ int btrfs_del_csums(struct btrfs_trans_h
 	u64 end_byte = bytenr + len;
 	u64 csum_end;
 	struct extent_buffer *leaf;
-	int ret;
+	int ret = 0;
 	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
 	int blocksize_bits = fs_info->sb->s_blocksize_bits;
 
@@ -709,6 +709,7 @@ int btrfs_del_csums(struct btrfs_trans_h
 		path->leave_spinning = 1;
 		ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 		if (ret > 0) {
+			ret = 0;
 			if (path->slots[0] == 0)
 				break;
 			path->slots[0]--;
@@ -765,7 +766,7 @@ int btrfs_del_csums(struct btrfs_trans_h
 			ret = btrfs_del_items(trans, root, path,
 					      path->slots[0], del_nr);
 			if (ret)
-				goto out;
+				break;
 			if (key.offset == bytenr)
 				break;
 		} else if (key.offset < bytenr && csum_end > end_byte) {
@@ -809,8 +810,9 @@ int btrfs_del_csums(struct btrfs_trans_h
 			ret = btrfs_split_item(trans, root, path, &key, offset);
 			if (ret && ret != -EAGAIN) {
 				btrfs_abort_transaction(trans, ret);
-				goto out;
+				break;
 			}
+			ret = 0;
 
 			key.offset = end_byte - 1;
 		} else {
@@ -820,8 +822,6 @@ int btrfs_del_csums(struct btrfs_trans_h
 		}
 		btrfs_release_path(path);
 	}
-	ret = 0;
-out:
 	btrfs_free_path(path);
 	return ret;
 }


