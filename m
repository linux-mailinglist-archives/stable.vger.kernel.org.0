Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7CF3A03D8
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234240AbhFHTWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236707AbhFHTS5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:18:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DB426197B;
        Tue,  8 Jun 2021 18:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178329;
        bh=mHKXomWRnMW3agROBotJ0I7obFnlXdq6Cl3swQQVP7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=If8FYPG7itFBuwUnrHOUrNJLV/VzT8T5KDhvVBRez7OOAnVwz64G7bjtgeQVKHUKo
         7fdYL7Bgjeja6qAN8CjJTC0GwYpVKkTOL2JRj8XF4WUnpP5uvBAMcXz1ck/di5ztVT
         IxiV7fQisg3Ia5TVNLr2t/IXWKmCZRyELTaZ1sdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+aa12d6106ea4ca1b6aae@syzkaller.appspotmail.com,
        Phillip Potter <phil@philpotter.co.uk>, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.12 119/161] ext4: fix memory leak in ext4_mb_init_backend on error path.
Date:   Tue,  8 Jun 2021 20:27:29 +0200
Message-Id: <20210608175949.472421199@linuxfoundation.org>
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
@@ -2715,7 +2715,7 @@ static int ext4_mb_init_backend(struct s
 		 */
 		if (sbi->s_es->s_log_groups_per_flex >= 32) {
 			ext4_msg(sb, KERN_ERR, "too many log groups per flexible block group");
-			goto err_freesgi;
+			goto err_freebuddy;
 		}
 		sbi->s_mb_prefetch = min_t(uint, 1 << sbi->s_es->s_log_groups_per_flex,
 			BLK_MAX_SEGMENT_SIZE >> (sb->s_blocksize_bits - 9));


