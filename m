Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5F43A0394
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhFHTSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:18:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235513AbhFHTQq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:16:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB4C561976;
        Tue,  8 Jun 2021 18:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178274;
        bh=twcGeTYzNJlBKwZxhVdTINqIPiMEIB8QqXYKoc+MPHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y3J5o1DzA7WLk8M4CFuDI0tOIYDrvvtLFTtBgZLvZAKvGfT5B6wPYEhCKXSLtrPrc
         A5Ja30F9hAKdFH6RJZ3AliYmyiOD0mm7hhilvtGOaeG/yXMVR7Zo5HdI7qEOludclk
         lHAgwN5UX09X2q5INRW2T23tuv+ga4bv8weXRp1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.12 141/161] btrfs: fix error handling in btrfs_del_csums
Date:   Tue,  8 Jun 2021 20:27:51 +0200
Message-Id: <20210608175950.219304466@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
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
@@ -787,7 +787,7 @@ int btrfs_del_csums(struct btrfs_trans_h
 	u64 end_byte = bytenr + len;
 	u64 csum_end;
 	struct extent_buffer *leaf;
-	int ret;
+	int ret = 0;
 	const u32 csum_size = fs_info->csum_size;
 	u32 blocksize_bits = fs_info->sectorsize_bits;
 
@@ -805,6 +805,7 @@ int btrfs_del_csums(struct btrfs_trans_h
 
 		ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 		if (ret > 0) {
+			ret = 0;
 			if (path->slots[0] == 0)
 				break;
 			path->slots[0]--;
@@ -861,7 +862,7 @@ int btrfs_del_csums(struct btrfs_trans_h
 			ret = btrfs_del_items(trans, root, path,
 					      path->slots[0], del_nr);
 			if (ret)
-				goto out;
+				break;
 			if (key.offset == bytenr)
 				break;
 		} else if (key.offset < bytenr && csum_end > end_byte) {
@@ -905,8 +906,9 @@ int btrfs_del_csums(struct btrfs_trans_h
 			ret = btrfs_split_item(trans, root, path, &key, offset);
 			if (ret && ret != -EAGAIN) {
 				btrfs_abort_transaction(trans, ret);
-				goto out;
+				break;
 			}
+			ret = 0;
 
 			key.offset = end_byte - 1;
 		} else {
@@ -916,8 +918,6 @@ int btrfs_del_csums(struct btrfs_trans_h
 		}
 		btrfs_release_path(path);
 	}
-	ret = 0;
-out:
 	btrfs_free_path(path);
 	return ret;
 }


