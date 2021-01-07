Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16172ED2D7
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbhAGObr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:31:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728983AbhAGObr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:31:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B679E23372;
        Thu,  7 Jan 2021 14:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029845;
        bh=EjAqTvqR5xGB0ysuOSu9sqTv7/TUJ9YORzCYjtD5m8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YpBEEo8z4grB6jmCg0u64nY0COrP69yW2/voDnTzBqua9mKng7GmsMmG4OEisPzdI
         pCRahOAZ8It9F5/Iw7c30HXK+6mLIDl77c9Kw3d72Yj77ZPprgJj20fhkP+9+98QQs
         fyTNirsgzB0NgILJbUAR284IFJnMzOrGMXEMCvHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rustam Kovhaev <rkovhaev@gmail.com>,
        Jan Kara <jack@suse.cz>,
        syzbot+83b6f7cf9922cae5c4d7@syzkaller.appspotmail.com
Subject: [PATCH 4.14 15/29] reiserfs: add check for an invalid ih_entry_count
Date:   Thu,  7 Jan 2021 15:31:30 +0100
Message-Id: <20210107143055.082684129@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143052.973437064@linuxfoundation.org>
References: <20210107143052.973437064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rustam Kovhaev <rkovhaev@gmail.com>

commit d24396c5290ba8ab04ba505176874c4e04a2d53c upstream.

when directory item has an invalid value set for ih_entry_count it might
trigger use-after-free or out-of-bounds read in bin_search_in_dir_item()

ih_entry_count * IH_SIZE for directory item should not be larger than
ih_item_len

Link: https://lore.kernel.org/r/20201101140958.3650143-1-rkovhaev@gmail.com
Reported-and-tested-by: syzbot+83b6f7cf9922cae5c4d7@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=83b6f7cf9922cae5c4d7
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/reiserfs/stree.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -454,6 +454,12 @@ static int is_leaf(char *buf, int blocks
 					 "(second one): %h", ih);
 			return 0;
 		}
+		if (is_direntry_le_ih(ih) && (ih_item_len(ih) < (ih_entry_count(ih) * IH_SIZE))) {
+			reiserfs_warning(NULL, "reiserfs-5093",
+					 "item entry count seems wrong %h",
+					 ih);
+			return 0;
+		}
 		prev_location = ih_location(ih);
 	}
 


