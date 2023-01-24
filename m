Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148FB67978D
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 13:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbjAXMS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 07:18:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233629AbjAXMSZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 07:18:25 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B382F44BDE;
        Tue, 24 Jan 2023 04:18:19 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A497E1FE52;
        Tue, 24 Jan 2023 12:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1674562695; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m46DRSIGbNxtq+S0X71nQaA8qyjXNFqrFgBCpjCP/VI=;
        b=RL/yt1/hIrtZVUUJ7ZCLEIM/NZNwHFb/AxCm1CorTS3hnipc/PzFMwtaHTg+4b1PZkS5jX
        p12Z+VSaMwN62hNpNB0PP/zWPisiHeBFitMpSOXTlQyvWozyZa+5uXIrZ7Zd13kGSxI6Qo
        IOA0XpXH91MfKA5PsrhUhO7QT4ip4Yw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1674562695;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m46DRSIGbNxtq+S0X71nQaA8qyjXNFqrFgBCpjCP/VI=;
        b=1j1Vqnh+SNA17y+xnUbwtBdQ4Tmo+FVpGhMf3h3zxAdSAzH62HYkxBfwnVP62ON+V3qnsW
        Jr9DXzgl7TPEkNBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 97B9213A04;
        Tue, 24 Jan 2023 12:18:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Q9EFJYfMz2MFOAAAMHmgww
        (envelope-from <jack@suse.cz>); Tue, 24 Jan 2023 12:18:15 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 7C477A0719; Tue, 24 Jan 2023 13:18:14 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 21/22] udf: Fix file corruption when appending just after end of preallocated extent
Date:   Tue, 24 Jan 2023 13:18:07 +0100
Message-Id: <20230124121814.25951-21-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230124120835.21728-1-jack@suse.cz>
References: <20230124120835.21728-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2002; i=jack@suse.cz; h=from:subject; bh=lfwscmtlTLylhleSMfBN6ty0Imfx64TCTX3XBq2sWds=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBjz8x+TwOf6Aj5YpvaFbORv23yeEcN43H8u+UW/wsA yKhfUL+JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCY8/MfgAKCRCcnaoHP2RA2cI0B/ 420Pzt9o+WwwO2G8nJ6hX0wemTXDkIpwas+DLgVbWIxCzlXoDGlV8B0NZ4X6fqcSiwm+EZMWFRbbqB NW87U3Umh12YWjGCApE+IQKBzO9qlZlwcNISgvHlk9e0Sdp3UyXtXY0F00j32zOZNETJ0HUBUHsqD5 j1PB1lScJcmLtd73TfCfeJZ7S1AhAszG4NcNJj38dlgJwn6rfSvJLz/phLaM2PDGleEA8aQh39pdAB a19uQse3Lk49cwkMSUpnTgLSh2GSORitudw+bboSQBFzHXWkiaH7Fa6PDNWuaoAnjvni5M/lBkRxzU dHYOQXCXI+CHaI3svV8Dxw/W9YkQ/O
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When we append new block just after the end of preallocated extent, the
code in inode_getblk() wrongly determined we're going to use the
preallocated extent which resulted in adding block into a wrong logical
offset in the file. Sequence like this manifests it:

xfs_io -f -c "pwrite 0x2cacf 0xd122" -c "truncate 0x2dd6f" \
  -c "pwrite 0x27fd9 0x69a9" -c "pwrite 0x32981 0x7244" <file>

The code that determined the use of preallocated extent is actually
stale because udf_do_extend_file() does not create preallocation anymore
so after calling that function we are sure there's no usable
preallocation. Just remove the faulty condition.

CC: stable@vger.kernel.org
Fixes: 16d055656814 ("udf: Discard preallocation before extending file with a hole")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 8f55b37ddcad..6826c2aa021f 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -742,19 +742,17 @@ static int inode_getblk(struct inode *inode, struct udf_map_rq *map)
 		c = 0;
 		offset = 0;
 		count += ret;
-		/* We are not covered by a preallocated extent? */
-		if ((laarr[0].extLength & UDF_EXTENT_FLAG_MASK) !=
-						EXT_NOT_RECORDED_ALLOCATED) {
-			/* Is there any real extent? - otherwise we overwrite
-			 * the fake one... */
-			if (count)
-				c = !c;
-			laarr[c].extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
-				inode->i_sb->s_blocksize;
-			memset(&laarr[c].extLocation, 0x00,
-				sizeof(struct kernel_lb_addr));
-			count++;
-		}
+		/*
+		 * Is there any real extent? - otherwise we overwrite the fake
+		 * one...
+		 */
+		if (count)
+			c = !c;
+		laarr[c].extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
+			inode->i_sb->s_blocksize;
+		memset(&laarr[c].extLocation, 0x00,
+			sizeof(struct kernel_lb_addr));
+		count++;
 		endnum = c + 1;
 		lastblock = 1;
 	} else {
-- 
2.35.3

