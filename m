Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0856B45E7
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbjCJOik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232713AbjCJOiX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:38:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAA510247
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:38:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5C08B822DF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3620EC4339C;
        Fri, 10 Mar 2023 14:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459031;
        bh=/icnbl99Xs46trCkoa5k/g+hdGUJKHc1Tncn333uBQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y7HKZT4bejDYzKnpMIntTPPYRKlQMOY7Y3Ly4FoMhGBdF06MWjqcqYBdkVT1zVvUs
         x0i3t+x2AFoWlokbqk96zQYXYrxjxQDiE1bgfwjtqxv9sOHE81vdQkIJ7omfXKxMeW
         7ipzkTSmqwtaX0v4v4tNsHsynt8bT67Gni3+5qQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+60f291a24acecb3c2bd5@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.4 226/357] udf: Do not bother merging very long extents
Date:   Fri, 10 Mar 2023 14:38:35 +0100
Message-Id: <20230310133744.736727841@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

commit 53cafe1d6d8ef9f93318e5bfccc0d24f27d41ced upstream.

When merging very long extents we try to push as much length as possible
to the first extent. However this is unnecessarily complicated and not
really worth the trouble. Furthermore there was a bug in the logic
resulting in corrupting extents in the file as syzbot reproducer shows.
So just don't bother with the merging of extents that are too long
together.

CC: stable@vger.kernel.org
Reported-by: syzbot+60f291a24acecb3c2bd5@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1096,23 +1096,8 @@ static void udf_merge_extents(struct ino
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


