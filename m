Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB7B3A0029
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234963AbhFHSkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:40:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235124AbhFHSjH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:39:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 308C761027;
        Tue,  8 Jun 2021 18:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177237;
        bh=4+1yte7jhTdz7NboCFWqBUsW1EGS/+n9JNpTFRzG1Zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMdf2+izO6XSIhLFitU1YDYQvU2XdY8fzSozikIWDALR0Q05Un96ADT+sT+OU5EyK
         /1+dBERRYNzOLxX3eyfhsUHaiUoJ8aluaP2qspi3w/O3TqPSdDxRllsO9J/KGLbnSR
         Vy9SPk1iXftdVn4MMRBBHsaeJcYrw2bW3KChgOEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 36/58] btrfs: fix error handling in btrfs_del_csums
Date:   Tue,  8 Jun 2021 20:27:17 +0200
Message-Id: <20210608175933.464050533@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175932.263480586@linuxfoundation.org>
References: <20210608175932.263480586@linuxfoundation.org>
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
@@ -586,7 +586,7 @@ int btrfs_del_csums(struct btrfs_trans_h
 	u64 end_byte = bytenr + len;
 	u64 csum_end;
 	struct extent_buffer *leaf;
-	int ret;
+	int ret = 0;
 	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
 	int blocksize_bits = fs_info->sb->s_blocksize_bits;
 
@@ -605,6 +605,7 @@ int btrfs_del_csums(struct btrfs_trans_h
 		path->leave_spinning = 1;
 		ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 		if (ret > 0) {
+			ret = 0;
 			if (path->slots[0] == 0)
 				break;
 			path->slots[0]--;
@@ -661,7 +662,7 @@ int btrfs_del_csums(struct btrfs_trans_h
 			ret = btrfs_del_items(trans, root, path,
 					      path->slots[0], del_nr);
 			if (ret)
-				goto out;
+				break;
 			if (key.offset == bytenr)
 				break;
 		} else if (key.offset < bytenr && csum_end > end_byte) {
@@ -705,8 +706,9 @@ int btrfs_del_csums(struct btrfs_trans_h
 			ret = btrfs_split_item(trans, root, path, &key, offset);
 			if (ret && ret != -EAGAIN) {
 				btrfs_abort_transaction(trans, ret);
-				goto out;
+				break;
 			}
+			ret = 0;
 
 			key.offset = end_byte - 1;
 		} else {
@@ -716,8 +718,6 @@ int btrfs_del_csums(struct btrfs_trans_h
 		}
 		btrfs_release_path(path);
 	}
-	ret = 0;
-out:
 	btrfs_free_path(path);
 	return ret;
 }


