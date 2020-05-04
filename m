Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA8C1C4517
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731156AbgEDSMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:12:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731350AbgEDSCk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:02:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AEE9206B8;
        Mon,  4 May 2020 18:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615359;
        bh=veOsvRPlrvyCtf3q8/NNzUyaYKGJ9L/RP453UntgzHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y7rVKuR1zxu+rjgjiyjDgp1Dcsg7yf9ED0396Lj8wXNPGKUmE2ovge5DRehAUObjG
         obkVhU5Ah5kw/8CLmQ4OGAagVZq5WoiKH3TPsZ/rxA9b9zuyqZCpj3+kIi6FpmUOQE
         D6RythWsE/pYCnZuiCWos6bW8ESfcUAp3rSaK3RY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        David Disseldorp <ddiss@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 24/37] scsi: target/iblock: fix WRITE SAME zeroing
Date:   Mon,  4 May 2020 19:57:37 +0200
Message-Id: <20200504165450.921397685@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165448.264746645@linuxfoundation.org>
References: <20200504165448.264746645@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Disseldorp <ddiss@suse.de>

commit 1d2ff149b263c9325875726a7804a0c75ef7112e upstream.

SBC4 specifies that WRITE SAME requests with the UNMAP bit set to zero
"shall perform the specified write operation to each LBA specified by the
command".  Commit 2237498f0b5c ("target/iblock: Convert WRITE_SAME to
blkdev_issue_zeroout") modified the iblock backend to call
blkdev_issue_zeroout() when handling WRITE SAME requests with UNMAP=0 and a
zero data segment.

The iblock blkdev_issue_zeroout() call incorrectly provides a flags
parameter of 0 (bool false), instead of BLKDEV_ZERO_NOUNMAP.  The bool
false parameter reflects the blkdev_issue_zeroout() API prior to commit
ee472d835c26 ("block: add a flags argument to (__)blkdev_issue_zeroout")
which was merged shortly before 2237498f0b5c.

Link: https://lore.kernel.org/r/20200419163109.11689-1-ddiss@suse.de
Fixes: 2237498f0b5c ("target/iblock: Convert WRITE_SAME to blkdev_issue_zeroout")
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_iblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -445,7 +445,7 @@ iblock_execute_zero_out(struct block_dev
 				target_to_linux_sector(dev, cmd->t_task_lba),
 				target_to_linux_sector(dev,
 					sbc_get_write_same_sectors(cmd)),
-				GFP_KERNEL, false);
+				GFP_KERNEL, BLKDEV_ZERO_NOUNMAP);
 	if (ret)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 


