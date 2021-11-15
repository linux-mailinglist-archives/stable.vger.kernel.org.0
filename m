Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2174521F8
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377000AbhKPBHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:07:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:44610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245255AbhKOTTz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFF796351F;
        Mon, 15 Nov 2021 18:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001081;
        bh=sSmYeuCnxW32gg3/CmXK1vfWe08JWkvG7sVC9w6QLSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e8hvTEtRWrxjpzxMPdw+pb3f09aBPjwkhGy2iaOKIznR6H90+EKZ772iUTXFmKAlz
         0RZIlq8zDZ8ih4RTHggB8FtWrYVzOEwyaDzJGtQ7uatYHXfFBLVlk4iv/aub+X1Qna
         1IMY46qRyoyyaVL/uKFeTjCZwKRFsDk4g1z2jeNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Whitney <enwlinux@gmail.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.15 052/917] Revert "ext4: enforce buffer head state assertion in ext4_da_map_blocks"
Date:   Mon, 15 Nov 2021 17:52:27 +0100
Message-Id: <20211115165430.537697047@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Whitney <enwlinux@gmail.com>

commit 3eda41df05d6ad5c825cbc7fef03d563597b1afa upstream.

This reverts commit 948ca5f30e1df0c11eb5b0f410b9ceb97fa77ad9.

Two crash reports from users running variations on 5.15-rc4 kernels
suggest that it is premature to enforce the state assertion in the
original commit.  Both crashes were triggered by BUG calls in that
code, indicating that under some rare circumstance the buffer head
state did not match a delayed allocated block at the time the
block was written out.  No reproducer is available.  Resolving this
problem will require more time than remains in the current release
cycle, so reverting the original patch for the time being is necessary
to avoid any instability it may cause.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
Link: https://lore.kernel.org/r/20211012171901.5352-1-enwlinux@gmail.com
Fixes: 948ca5f30e1d ("ext4: enforce buffer head state assertion in ext4_da_map_blocks")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1711,16 +1711,13 @@ static int ext4_da_map_blocks(struct ino
 		}
 
 		/*
-		 * the buffer head associated with a delayed and not unwritten
-		 * block found in the extent status cache must contain an
-		 * invalid block number and have its BH_New and BH_Delay bits
-		 * set, reflecting the state assigned when the block was
-		 * initially delayed allocated
+		 * Delayed extent could be allocated by fallocate.
+		 * So we need to check it.
 		 */
-		if (ext4_es_is_delonly(&es)) {
-			BUG_ON(bh->b_blocknr != invalid_block);
-			BUG_ON(!buffer_new(bh));
-			BUG_ON(!buffer_delay(bh));
+		if (ext4_es_is_delayed(&es) && !ext4_es_is_unwritten(&es)) {
+			map_bh(bh, inode->i_sb, invalid_block);
+			set_buffer_new(bh);
+			set_buffer_delay(bh);
 			return 0;
 		}
 


