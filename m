Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA82A2E78F1
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 14:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgL3NEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 08:04:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:53736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgL3NEj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 08:04:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C21552229C;
        Wed, 30 Dec 2020 13:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609333405;
        bh=WjZx0LmAyapqEa7RxcfH6tfxnAzjmH0UCNs5+WwCvM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lyF9M3NMToG3pUD0xC/t0UzXJqotC9uaA8+gkRBTrhCRpnfgZJJBexJZJ91YQHM28
         asJjbfTTT2UOzbjh1jVEicpBt+vDIlIAgj+thm09qoBlZyHMaGSbfKLEyfWS4rA3vS
         E2DGTpHWl2Bgd8lmjLBWh8HnVdhDcgYmmn4k/owXkz6A24nGNDBEjU+yqZa37r52XG
         yWik4x7uOBR+L8cmwbUW+fU9vZP3ZHscqhppSB1Tvd5fmsLFTYw5M5/WQSF21aim1C
         xs9O7WvvcBCHLX45kG0gcG2HjYhRQ5WFPXyIndpEBI9Bs260tIRZ/nfFz4SegpbYbF
         /I8RN9Jb+0GFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rustam Kovhaev <rkovhaev@gmail.com>,
        syzbot+83b6f7cf9922cae5c4d7@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>,
        reiserfs-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 08/31] reiserfs: add check for an invalid ih_entry_count
Date:   Wed, 30 Dec 2020 08:02:50 -0500
Message-Id: <20201230130314.3636961-8-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201230130314.3636961-1-sashal@kernel.org>
References: <20201230130314.3636961-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rustam Kovhaev <rkovhaev@gmail.com>

[ Upstream commit d24396c5290ba8ab04ba505176874c4e04a2d53c ]

when directory item has an invalid value set for ih_entry_count it might
trigger use-after-free or out-of-bounds read in bin_search_in_dir_item()

ih_entry_count * IH_SIZE for directory item should not be larger than
ih_item_len

Link: https://lore.kernel.org/r/20201101140958.3650143-1-rkovhaev@gmail.com
Reported-and-tested-by: syzbot+83b6f7cf9922cae5c4d7@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=83b6f7cf9922cae5c4d7
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/reiserfs/stree.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index 8bf88d690729e..476a7ff494822 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -454,6 +454,12 @@ static int is_leaf(char *buf, int blocksize, struct buffer_head *bh)
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
 
-- 
2.27.0

