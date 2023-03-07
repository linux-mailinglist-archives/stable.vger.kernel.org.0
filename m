Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6725A6AF530
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbjCGTXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbjCGTWj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:22:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B125C618B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:07:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2C528CE1C5D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5E9C433EF;
        Tue,  7 Mar 2023 19:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216070;
        bh=AV3JCL4KGx4GHBZWpsfZrZsdVT0X+TPMsLy5IYMqN90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rfd/YOHa6ivPa6ZzjtydLZEikDufNqRiJB46BrRwmihMenfmu90aQxmfMmQj3RZSW
         m59ecwtxr0x787OBy7J9zARjfshC3ma3eqNlP6ZHCzBwjhg08CY/Een8NMpr8BkK9d
         v/Zw/IOUuBGZtF/J/ZR2dv5cD62u9s+UiSbQ1GvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>
Subject: [PATCH 5.15 464/567] udf: Fix file corruption when appending just after end of preallocated extent
Date:   Tue,  7 Mar 2023 18:03:20 +0100
Message-Id: <20230307165925.975938852@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 36ec52ea038b18a53e198116ef7d7e70c87db046 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -804,19 +804,17 @@ static sector_t inode_getblk(struct inod
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


