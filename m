Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9BD364EDE8
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 16:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbiLPP1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 10:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbiLPP1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 10:27:08 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157486A741;
        Fri, 16 Dec 2022 07:27:07 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 22FD75D11C;
        Fri, 16 Dec 2022 15:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1671204423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p/O2ps2mHRo0JeIz+0MwgqaeKuW+vsefWvMFQwy+/iE=;
        b=0raTvUDBW3B8jllKouEszKUtGXdHI7xoPCTH46FGf1CDAxPs/T9+bpWCs9gQ1JlKjKXdOP
        aiThWZ2Sc8OTNEg6VmdO/RcSM16eevKIDpFkTloo6zkP8pypTb5YAWwwvxcCkqHdWoLcWA
        9ZItq6an1kIoyIL4XVAS9uDR/1G9O/E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1671204423;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p/O2ps2mHRo0JeIz+0MwgqaeKuW+vsefWvMFQwy+/iE=;
        b=aVhVoJQL2LKiPSSCWqVsTuoufLupU0oarunCR2UdNUDFDryKzDIFSh9dYzRXO4C0h1XAYK
        1zyOfi+CAZFu4mBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0C419138FD;
        Fri, 16 Dec 2022 15:27:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 857+AkeOnGPxCAAAMHmgww
        (envelope-from <jack@suse.cz>); Fri, 16 Dec 2022 15:27:03 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id E6511A077A; Fri, 16 Dec 2022 16:26:56 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     Jan Kara <jack@suse.cz>, stable@vger.kernel.org,
        syzbot+60f291a24acecb3c2bd5@syzkaller.appspotmail.com
Subject: [PATCH 20/20] udf: Do not bother merging very long extents
Date:   Fri, 16 Dec 2022 16:24:24 +0100
Message-Id: <20221216152656.6236-20-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221216121344.14025-1-jack@suse.cz>
References: <20221216121344.14025-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1744; i=jack@suse.cz; h=from:subject; bh=634NKhsU1nEd/5CQZlTXPRVOE4qDGCQjFjkGkWgMdFU=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBjnI2nwAOuu5SkHrpaBn0fv1TipKUOl7Izm3i/mcjC uy/bUoOJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCY5yNpwAKCRCcnaoHP2RA2bZOCA CGRJth+tUs/Qtp3sfuVnqzyyOjbJ/8GOfppkSJ6nz4I6h/FZ+6oFSoP+9X7iXgQ/3ZDNyYyWHZs8Mc 7iKJHjNJelp0I78aPvOrwcItArXX84MFK9eP0RohqcOVL9MefYtEogSBckHG4hE08J/SQciKrinZO2 ekObeIPPDR+OVbpdxKVhzl1ISIJFxp6yD61UbelXxHU+Nc37Ilkdsnuby2kkp40oJH/o/k+8fYJz8F o2tH/aHn1Fi5LZsis4QB0y2xW71xFmgttGACWdju3TJlOF4GdJQvFckIdj/mNN+exGCaz5ado5Qq6u az8UPM6IrS50+DuSsHkwM2feHD9hC+
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When merging very long extents we try to push as much length as possible
to the first extent. However this is unnecessarily complicated and not
really worth the trouble. Furthermore there was a bug in the logic
resulting in corrupting extents in the file as syzbot reproducer shows.
So just don't bother with the merging of extents that are too long
together.

CC: stable@vger.kernel.org
Reported-by: syzbot+60f291a24acecb3c2bd5@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index fc5937358148..09417342d8b6 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -999,23 +999,8 @@ static void udf_merge_extents(struct inode *inode, struct kernel_long_ad *laarr,
 			blocksize - 1) >> blocksize_bits)))) {
 
 			if (((li->extLength & UDF_EXTENT_LENGTH_MASK) +
-				(lip1->extLength & UDF_EXTENT_LENGTH_MASK) +
-				blocksize - 1) & ~UDF_EXTENT_LENGTH_MASK) {
-				lip1->extLength = (lip1->extLength -
-						  (li->extLength &
-						   UDF_EXTENT_LENGTH_MASK) +
-						   UDF_EXTENT_LENGTH_MASK) &
-							~(blocksize - 1);
-				li->extLength = (li->extLength &
-						 UDF_EXTENT_FLAG_MASK) +
-						(UDF_EXTENT_LENGTH_MASK + 1) -
-						blocksize;
-				lip1->extLocation.logicalBlockNum =
-					li->extLocation.logicalBlockNum +
-					((li->extLength &
-						UDF_EXTENT_LENGTH_MASK) >>
-						blocksize_bits);
-			} else {
+			     (lip1->extLength & UDF_EXTENT_LENGTH_MASK) +
+			     blocksize - 1) <= UDF_EXTENT_LENGTH_MASK) {
 				li->extLength = lip1->extLength +
 					(((li->extLength &
 						UDF_EXTENT_LENGTH_MASK) +
-- 
2.35.3

