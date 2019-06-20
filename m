Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 301AC4D1E7
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 17:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732017AbfFTPTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 11:19:00 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:34890 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731791AbfFTPSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 11:18:55 -0400
Received: by mail-io1-f66.google.com with SMTP id m24so649085ioo.2
        for <stable@vger.kernel.org>; Thu, 20 Jun 2019 08:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8qPSgW/MPmMfMRbYOSrZE2Wb0C0QAL6xUVu8BnMULPU=;
        b=E18fnBvQxeTWGcLPU7yJtnVUsZk1M7260uW49AWUEQwpDTLXW4zaL81bfOBaOIKkJe
         izk337ElLT6ixdEAM82Alqqvi8RTCa5t/m7TIIGM2CTO/X/MhLTAbXsdT4WaLEPQzOwi
         5M/ks9JI6LULaQnx5ORxgNivEqZfrhzLXyxFY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8qPSgW/MPmMfMRbYOSrZE2Wb0C0QAL6xUVu8BnMULPU=;
        b=n7viLBj89hkZYeGU8y0pNH0VYwCl9YOD9HCzi1UCvIP59Z8AbbfF+zEDvHQywMZKb1
         OYSWmNmUt2qzCHcNP43Ay1w8et92hUQNs4t84lRAkzARarPMOPLh0IFauOTJnZviGja7
         mm1zqW21izSop69hkPWVQV+JNOeMbPWisCUG5ohCiDjgTDnxXwu+9Wln+c+xhz+b5sD4
         RFJy4TlBpbEdjT5JrM6Ed4hsTC56bP6FMoRdJKNIjQzzHvwwQKeOmYFPCz/Hfoisiy0T
         TVWQ9UU42KJMB0V+mEdR8PffQWo1L/+eXTkdIfV/CQ1WAKoSj6E/gU9pzqwKQRXxLwlb
         ndpQ==
X-Gm-Message-State: APjAAAVRtdzfZVApzjqLOpraKheWIS3Q6+TtVARzpEK7rpt/nUxnMyZV
        WujzZxRcsQqoMEJA8TXuB/YL9Q==
X-Google-Smtp-Source: APXvYqyKoB4ShJDQDvXm8iMpldDQ7RBFe5iQW/R6q5N6coubvTjfHUDrQI1UrGttuBMzscYMvKWwFg==
X-Received: by 2002:a5d:8794:: with SMTP id f20mr30867938ion.128.1561043934904;
        Thu, 20 Jun 2019 08:18:54 -0700 (PDT)
Received: from localhost ([2620:15c:183:200:855f:8919:84a7:4794])
        by smtp.gmail.com with ESMTPSA id e22sm51531iob.66.2019.06.20.08.18.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 08:18:54 -0700 (PDT)
From:   Ross Zwisler <zwisler@chromium.org>
X-Google-Original-From: Ross Zwisler <zwisler@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Fletcher Woodruff <fletcherw@google.com>,
        Justin TerAvest <teravest@google.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH v2 3/3] ext4: use jbd2_inode dirty range scoping
Date:   Thu, 20 Jun 2019 09:18:39 -0600
Message-Id: <20190620151839.195506-4-zwisler@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190620151839.195506-1-zwisler@google.com>
References: <20190620151839.195506-1-zwisler@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use the newly introduced jbd2_inode dirty range scoping to prevent us
from waiting forever when trying to complete a journal transaction.

Signed-off-by: Ross Zwisler <zwisler@google.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org
---
 fs/ext4/ext4_jbd2.h   | 12 ++++++------
 fs/ext4/inode.c       | 13 ++++++++++---
 fs/ext4/move_extent.c |  3 ++-
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 75a5309f22315..ef8fcf7d0d3b3 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -361,20 +361,20 @@ static inline int ext4_journal_force_commit(journal_t *journal)
 }
 
 static inline int ext4_jbd2_inode_add_write(handle_t *handle,
-					    struct inode *inode)
+		struct inode *inode, loff_t start_byte, loff_t length)
 {
 	if (ext4_handle_valid(handle))
-		return jbd2_journal_inode_add_write(handle,
-						    EXT4_I(inode)->jinode);
+		return jbd2_journal_inode_ranged_write(handle,
+				EXT4_I(inode)->jinode, start_byte, length);
 	return 0;
 }
 
 static inline int ext4_jbd2_inode_add_wait(handle_t *handle,
-					   struct inode *inode)
+		struct inode *inode, loff_t start_byte, loff_t length)
 {
 	if (ext4_handle_valid(handle))
-		return jbd2_journal_inode_add_wait(handle,
-						   EXT4_I(inode)->jinode);
+		return jbd2_journal_inode_ranged_wait(handle,
+				EXT4_I(inode)->jinode, start_byte, length);
 	return 0;
 }
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c7f77c6430085..27fec5c594459 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -731,10 +731,16 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		    !(flags & EXT4_GET_BLOCKS_ZERO) &&
 		    !ext4_is_quota_file(inode) &&
 		    ext4_should_order_data(inode)) {
+			loff_t start_byte =
+				(loff_t)map->m_lblk << inode->i_blkbits;
+			loff_t length = (loff_t)map->m_len << inode->i_blkbits;
+
 			if (flags & EXT4_GET_BLOCKS_IO_SUBMIT)
-				ret = ext4_jbd2_inode_add_wait(handle, inode);
+				ret = ext4_jbd2_inode_add_wait(handle, inode,
+						start_byte, length);
 			else
-				ret = ext4_jbd2_inode_add_write(handle, inode);
+				ret = ext4_jbd2_inode_add_write(handle, inode,
+						start_byte, length);
 			if (ret)
 				return ret;
 		}
@@ -4085,7 +4091,8 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 		err = 0;
 		mark_buffer_dirty(bh);
 		if (ext4_should_order_data(inode))
-			err = ext4_jbd2_inode_add_write(handle, inode);
+			err = ext4_jbd2_inode_add_write(handle, inode, from,
+					length);
 	}
 
 unlock:
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 1083a9f3f16a1..c7ded4e2adff5 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -390,7 +390,8 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 
 	/* Even in case of data=writeback it is reasonable to pin
 	 * inode to transaction, to prevent unexpected data loss */
-	*err = ext4_jbd2_inode_add_write(handle, orig_inode);
+	*err = ext4_jbd2_inode_add_write(handle, orig_inode,
+			(loff_t)orig_page_offset << PAGE_SHIFT, replaced_size);
 
 unlock_pages:
 	unlock_page(pagep[0]);
-- 
2.22.0.410.gd8fdbe21b5-goog

