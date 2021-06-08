Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201C93A023C
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235350AbhFHTCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:02:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237303AbhFHTAP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:00:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9148613CE;
        Tue,  8 Jun 2021 18:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177806;
        bh=6Gabgy4UiKFla4967rw6B0OVHHOOlpCUIr2yB9sfypU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aiN4L0FVQbi/5hbhmaeDz6szC/BXQW1GV4+85psYaJxikIrdUkH+QGpIeoeDOGVV7
         u9VytSWPQ0Q4KtO/Mwrmon4S7Wjvd7YTOZv5ZuUbxX1t2qQVOX89y03Fe192g2Z5y3
         mfHW5vg7AwVWp84j+jp9UYS59eaD3roLNIiexNc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+aa12d6106ea4ca1b6aae@syzkaller.appspotmail.com,
        Phillip Potter <phil@philpotter.co.uk>, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 105/137] ext4: fix memory leak in ext4_mb_init_backend on error path.
Date:   Tue,  8 Jun 2021 20:27:25 +0200
Message-Id: <20210608175945.941826056@linuxfoundation.org>
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

From: Phillip Potter <phil@philpotter.co.uk>

commit a8867f4e3809050571c98de7a2d465aff5e4daf5 upstream.

Fix a memory leak discovered by syzbot when a file system is corrupted
with an illegally large s_log_groups_per_flex.

Reported-by: syzbot+aa12d6106ea4ca1b6aae@syzkaller.appspotmail.com
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20210412073837.1686-1-phil@philpotter.co.uk
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2738,7 +2738,7 @@ static int ext4_mb_init_backend(struct s
 		 */
 		if (sbi->s_es->s_log_groups_per_flex >= 32) {
 			ext4_msg(sb, KERN_ERR, "too many log groups per flexible block group");
-			goto err_freesgi;
+			goto err_freebuddy;
 		}
 		sbi->s_mb_prefetch = min_t(uint, 1 << sbi->s_es->s_log_groups_per_flex,
 			BLK_MAX_SEGMENT_SIZE >> (sb->s_blocksize_bits - 9));


