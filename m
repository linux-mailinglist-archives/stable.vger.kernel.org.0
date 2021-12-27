Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BDD47FFA1
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238209AbhL0PjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:39:19 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:41190 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238863AbhL0Phq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:37:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BE6E6CE10DB;
        Mon, 27 Dec 2021 15:37:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF90CC36AE7;
        Mon, 27 Dec 2021 15:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619463;
        bh=J1hkYbLPK0hfao3/gKPqaFTP6YrRpqHBHIxdobiEGq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aRJhKkq9sEj1t8JI4NPTaSXVZpuQA8ZXgvXZCjwwidtwwBtL9LybXKxgPoeBv45d/
         ntvT/FOoURxgk9enUbXtl9nhB7VOwfXtF2R39ri5NLbHNUD5TlUT7GC42ZLf6lJ+h8
         +FlWHyF1t6OvaAt2Hw9c/qaDqq+9xiRdk9/ufblg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 05/76] ext4: check for out-of-order index extents in ext4_valid_extent_entries()
Date:   Mon, 27 Dec 2021 16:30:20 +0100
Message-Id: <20211227151324.895735338@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

commit 8dd27fecede55e8a4e67eef2878040ecad0f0d33 upstream.

After commit 5946d089379a ("ext4: check for overlapping extents in
ext4_valid_extent_entries()"), we can check out the overlapping extent
entry in leaf extent blocks. But the out-of-order extent entry in index
extent blocks could also trigger bad things if the filesystem is
inconsistent. So this patch add a check to figure out the out-of-order
index extents and return error.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Link: https://lore.kernel.org/r/20210908120850.4012324-2-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -369,6 +369,9 @@ static int ext4_valid_extent_entries(str
 				     ext4_fsblk_t *pblk, int depth)
 {
 	unsigned short entries;
+	ext4_lblk_t lblock = 0;
+	ext4_lblk_t prev = 0;
+
 	if (eh->eh_entries == 0)
 		return 1;
 
@@ -377,31 +380,35 @@ static int ext4_valid_extent_entries(str
 	if (depth == 0) {
 		/* leaf entries */
 		struct ext4_extent *ext = EXT_FIRST_EXTENT(eh);
-		ext4_lblk_t lblock = 0;
-		ext4_lblk_t prev = 0;
-		int len = 0;
 		while (entries) {
 			if (!ext4_valid_extent(inode, ext))
 				return 0;
 
 			/* Check for overlapping extents */
 			lblock = le32_to_cpu(ext->ee_block);
-			len = ext4_ext_get_actual_len(ext);
 			if ((lblock <= prev) && prev) {
 				*pblk = ext4_ext_pblock(ext);
 				return 0;
 			}
+			prev = lblock + ext4_ext_get_actual_len(ext) - 1;
 			ext++;
 			entries--;
-			prev = lblock + len - 1;
 		}
 	} else {
 		struct ext4_extent_idx *ext_idx = EXT_FIRST_INDEX(eh);
 		while (entries) {
 			if (!ext4_valid_extent_idx(inode, ext_idx))
 				return 0;
+
+			/* Check for overlapping index extents */
+			lblock = le32_to_cpu(ext_idx->ei_block);
+			if ((lblock <= prev) && prev) {
+				*pblk = ext4_idx_pblock(ext_idx);
+				return 0;
+			}
 			ext_idx++;
 			entries--;
+			prev = lblock;
 		}
 	}
 	return 1;


