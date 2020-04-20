Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12741B0BEE
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgDTMlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:41:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727914AbgDTMlC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:41:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96C8B20736;
        Mon, 20 Apr 2020 12:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386462;
        bh=dmfp8iJjkzItWWjRKonzZYhBJ02Aif1xYwUp0wvQUfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GMi8I1HvtK5RqRuYpPA1SfRtp5+vH+jKxUQwHPUrHCvQWgOepN7SECKv/jEpq1owH
         yedLXnbq/7wxwRepL2ehbcyFIMl02X8MvWKW3CcmN5mAL1iMagF/UHTmohyhi/LHuU
         KzAC8v6tfJ+MeiEb06iAx/jxGS/02bJgcCmm+TBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
        Josh Triplett <josh@joshtriplett.org>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.5 31/65] ext4: fix incorrect inodes per group in error message
Date:   Mon, 20 Apr 2020 14:38:35 +0200
Message-Id: <20200420121512.931858314@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121505.909671922@linuxfoundation.org>
References: <20200420121505.909671922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Triplett <josh@joshtriplett.org>

commit b9c538da4e52a7b79dfcf4cfa487c46125066dfb upstream.

If ext4_fill_super detects an invalid number of inodes per group, the
resulting error message printed the number of blocks per group, rather
than the number of inodes per group. Fix it to print the correct value.

Fixes: cd6bb35bf7f6d ("ext4: use more strict checks for inodes_per_block on mount")
Link: https://lore.kernel.org/r/8be03355983a08e5d4eed480944613454d7e2550.1585434649.git.josh@joshtriplett.org
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4112,7 +4112,7 @@ static int ext4_fill_super(struct super_
 	if (sbi->s_inodes_per_group < sbi->s_inodes_per_block ||
 	    sbi->s_inodes_per_group > blocksize * 8) {
 		ext4_msg(sb, KERN_ERR, "invalid inodes per group: %lu\n",
-			 sbi->s_blocks_per_group);
+			 sbi->s_inodes_per_group);
 		goto failed_mount;
 	}
 	sbi->s_itb_per_group = sbi->s_inodes_per_group /


