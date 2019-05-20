Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77FA1234C6
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390142AbfETMal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:30:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390140AbfETMak (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:30:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32A6020815;
        Mon, 20 May 2019 12:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355439;
        bh=CaVc0Vmf0CTBvhnD/hDvXM9q76PEYULHxwWmImXaQsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVS6I1405jMGro8ZMb1qPMC0lCi0B7grpkONVu5rBKgEoAbizlauJ4FnVGUvUXLiE
         3auLwAGfqa0tkUsXVi8X2BsIngl+ubw+u9pGa/hqdiyNWMNJvWk5/ynfA3tfBdaNFI
         eiOUcQc5SE2QSheC4MC3+OGpl9El0jlyZuLsMkTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.0 120/123] ext4: unsigned int compared against zero
Date:   Mon, 20 May 2019 14:15:00 +0200
Message-Id: <20190520115253.149556849@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit fbbbbd2f28aec991f3fbc248df211550fbdfd58c upstream.

There are two cases where u32 variables n and err are being checked
for less than zero error values, the checks is always false because
the variables are not signed. Fix this by making the variables ints.

Addresses-Coverity: ("Unsigned compared against 0")
Fixes: 345c0dbf3a30 ("ext4: protect journal inode's blocks using block_validity")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/block_validity.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -142,7 +142,8 @@ static int ext4_protect_reserved_inode(s
 	struct inode *inode;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_map_blocks map;
-	u32 i = 0, err = 0, num, n;
+	u32 i = 0, num;
+	int err = 0, n;
 
 	if ((ino < EXT4_ROOT_INO) ||
 	    (ino > le32_to_cpu(sbi->s_es->s_inodes_count)))


