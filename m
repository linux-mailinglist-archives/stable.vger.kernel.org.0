Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA2559BED0
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 13:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234789AbiHVLtM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 07:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbiHVLsv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 07:48:51 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DC619C31;
        Mon, 22 Aug 2022 04:48:40 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 01E7134411;
        Mon, 22 Aug 2022 11:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1661168919; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=YyWCl2xAcpsCEoG7GfUjZWnwYfRcXQ0btheI/96Dy1Q=;
        b=bR4pQsoq7AhbEb2Hxp2KHeTyvjSBXl7lJTcmPQoRs1/yDKnIdgchwmUSVDdHZUmYT4am1U
        uIFAicbhNs3/MuYCyIXwcZPCHYqISm8Rdfy/EU5nKmPjHCHKC0cRcuJdmt3+nQ1pVbk8Mo
        m//74tc5sKzQPAePMSDdhvvgfmqMa8s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1661168919;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=YyWCl2xAcpsCEoG7GfUjZWnwYfRcXQ0btheI/96Dy1Q=;
        b=avCVgG4SgF//xpRgnkAYoNmDHILzbc3/TomlIVQanIoNQVR7t2Ng//7WgBfc4BeSQuSYS7
        Yf00XaUHdFEhAHDw==
Received: from quack3.suse.cz (unknown [10.100.200.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id E4D012C141;
        Mon, 22 Aug 2022 11:48:38 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 91893A066D; Mon, 22 Aug 2022 13:48:37 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Lukas Czerner <lczerner@redhat.com>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH] ext4: Fix check for block being out of directory size
Date:   Mon, 22 Aug 2022 13:48:32 +0200
Message-Id: <20220822114832.1482-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=955; h=from:subject; bh=yHQDf2pXkDcOFXvLWy1eATbNPW5S1nPzvO2aZB705eM=; b=owGbwMvMwME4Z+4qdvsUh5uMp9WSGJKZcznVI6SsTjPm6kXYcymsrKs/fvuWC1Puy6VM19jLLzQa eZt3MhqzMDByMMiKKbKsjryofW2eUdfWUA0ZmEGsTCBTGLg4BWAi8svY/2kuaHDoia10Frv4aEmt09 3rDV2rfNZp5+sUzSv7ljeh87HEXKHk9En173bulNdb1Fn6SJljfcOKkPIFGXdjDixxmvnqx8WI0A+T VkZ11HbozT5/bENN5dHwrKRlftaMxWoZzScvRq3+sGvDhZRr+8vDbxzLTTlwsdS0UKwig9Fc48m/y+ ku+R0pd5szDv+T1QxKYLxRdqH8lP+dmU8qN5qlytdHP/8h58myIKLQi+9vmnzNtPDtleus9U6H/lkw aVt6UFQqp4CQ3fYTcmF6Ec6VwuHLfZYeP+WhEHL4atCpgAU/Dxkcqp/k06fqX94ftqh7mrujwIKf2/ zrMwJaXjlvlvZoPOWX9ML7LtMuAA==
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The check in __ext4_read_dirblock() for block being outside of directory
size was wrong because it compared block number against directory size
in bytes. Fix it.

Fixes: 65f8ea4cd57d ("ext4: check if directory block is within i_size")
CVE: CVE-2022-1184
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 3a31b662f661..bc2e0612ec32 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -126,7 +126,7 @@ static struct buffer_head *__ext4_read_dirblock(struct inode *inode,
 	struct ext4_dir_entry *dirent;
 	int is_dx_block = 0;
 
-	if (block >= inode->i_size) {
+	if (block >= inode->i_size >> inode->i_blkbits) {
 		ext4_error_inode(inode, func, line, block,
 		       "Attempting to read directory block (%u) that is past i_size (%llu)",
 		       block, inode->i_size);
-- 
2.35.3

