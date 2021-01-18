Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3B22FA917
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393682AbhARSmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 13:42:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:36932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390677AbhARLlP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:41:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEB6522D2C;
        Mon, 18 Jan 2021 11:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970033;
        bh=yERBotpbodozTIvgFhetE5NSsPcYXaQHg/jSD2F9yZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zkrJD0vb2j4a4oIgU0QLBHGB63TBXkqA51qZtnCoXXl3ZBhAZ4W6NR9wXf4xkJy7G
         RVTB/U3gwF625L+VDPJC7WSIPylCRkOgcpH37TjvC+E8EHiBTFKTlKK9ajO4deo2Mn
         EadIyBWP1W2tIl+lXIYWuqlM2K6zlGZr0HWHDDTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?St=C3=A9phane=20Lesimple?= <stephane_btrfs2@lesimple.fr>,
        Su Yue <l@damenly.su>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 001/152] btrfs: reloc: fix wrong file extent type check to avoid false ENOENT
Date:   Mon, 18 Jan 2021 12:32:56 +0100
Message-Id: <20210118113352.834395074@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 50e31ef486afe60f128d42fb9620e2a63172c15c upstream.

[BUG]
There are several bug reports about recent kernel unable to relocate
certain data block groups.

Sometimes the error just goes away, but there is one reporter who can
reproduce it reliably.

The dmesg would look like:

  [438.260483] BTRFS info (device dm-10): balance: start -dvrange=34625344765952..34625344765953
  [438.269018] BTRFS info (device dm-10): relocating block group 34625344765952 flags data|raid1
  [450.439609] BTRFS info (device dm-10): found 167 extents, stage: move data extents
  [463.501781] BTRFS info (device dm-10): balance: ended with status: -2

[CAUSE]
The ENOENT error is returned from the following call chain:

  add_data_references()
  |- delete_v1_space_cache();
     |- if (!found)
	   return -ENOENT;

The variable @found is set to true if we find a data extent whose
disk bytenr matches parameter @data_bytes.

With extra debugging, the offending tree block looks like this:

  leaf bytenr = 42676709441536, data_bytenr = 34626327621632

                ctime 1567904822.739884119 (2019-09-08 03:07:02)
                mtime 0.0 (1970-01-01 01:00:00)
                otime 0.0 (1970-01-01 01:00:00)
        item 27 key (51933 EXTENT_DATA 0) itemoff 9854 itemsize 53
                generation 1517381 type 2 (prealloc)
                prealloc data disk byte 34626327621632 nr 262144 <<<
                prealloc data offset 0 nr 262144
        item 28 key (52262 ROOT_ITEM 0) itemoff 9415 itemsize 439
                generation 2618893 root_dirid 256 bytenr 42677048360960 level 3 refs 1
                lastsnap 2618893 byte_limit 0 bytes_used 5557338112 flags 0x0(none)
                uuid d0d4361f-d231-6d40-8901-fe506e4b2b53

Although item 27 has disk bytenr 34626327621632, which matches the
data_bytenr, its type is prealloc, not reg.
This makes the existing code skip that item, and return ENOENT.

[FIX]
The code is modified in commit 19b546d7a1b2 ("btrfs: relocation: Use
btrfs_find_all_leafs to locate data extent parent tree leaves"), before
that commit, we use something like

  "if (type == BTRFS_FILE_EXTENT_INLINE) continue;"

But in that offending commit, we use (type == BTRFS_FILE_EXTENT_REG),
ignoring BTRFS_FILE_EXTENT_PREALLOC.

Fix it by also checking BTRFS_FILE_EXTENT_PREALLOC.

Reported-by: Stéphane Lesimple <stephane_btrfs2@lesimple.fr>
Link: https://lore.kernel.org/linux-btrfs/505cabfa88575ed6dbe7cb922d8914fb@lesimple.fr
Fixes: 19b546d7a1b2 ("btrfs: relocation: Use btrfs_find_all_leafs to locate data extent parent tree leaves")
CC: stable@vger.kernel.org # 5.6+
Tested-By: Stéphane Lesimple <stephane_btrfs2@lesimple.fr>
Reviewed-by: Su Yue <l@damenly.su>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/relocation.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3027,11 +3027,16 @@ static int delete_v1_space_cache(struct
 		return 0;
 
 	for (i = 0; i < btrfs_header_nritems(leaf); i++) {
+		u8 type;
+
 		btrfs_item_key_to_cpu(leaf, &key, i);
 		if (key.type != BTRFS_EXTENT_DATA_KEY)
 			continue;
 		ei = btrfs_item_ptr(leaf, i, struct btrfs_file_extent_item);
-		if (btrfs_file_extent_type(leaf, ei) == BTRFS_FILE_EXTENT_REG &&
+		type = btrfs_file_extent_type(leaf, ei);
+
+		if ((type == BTRFS_FILE_EXTENT_REG ||
+		     type == BTRFS_FILE_EXTENT_PREALLOC) &&
 		    btrfs_file_extent_disk_bytenr(leaf, ei) == data_bytenr) {
 			found = true;
 			space_cache_ino = key.objectid;


