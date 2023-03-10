Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3056B494C
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234032AbjCJPLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbjCJPKp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:10:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D45F12CC2
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:03:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78020B82338
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:02:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71DBC433D2;
        Fri, 10 Mar 2023 15:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460575;
        bh=OWt2X8PWOVrT1CHz2cSovZCGarJY24bm6tLiSSqYlLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fqlsgRnb/35yEzjPKN7J3K+jkdtC4PfIwYRBgSbtoqA0olNUNa0bimwKfG7uQltL3
         FFML00/DHm+qQL2E6WdAa+NL4yJZriiVfrlvihbSsSqNAMP0s2VaOhX4C0H02cgkfw
         w2X+3PT3Vf9jRAdZSp8Zx2HiQDVzTePvc/c0MdnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+0937935b993956ba28ab@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.10 350/529] udf: Do not update file length for failed writes to inline files
Date:   Fri, 10 Mar 2023 14:38:13 +0100
Message-Id: <20230310133821.237195476@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 256fe4162f8b5a1625b8603ca5f7ff79725bfb47 upstream.

When write to inline file fails (or happens only partly), we still
updated length of inline data as if the whole write succeeded. Fix the
update of length of inline data to happen only if the write succeeds.

Reported-by: syzbot+0937935b993956ba28ab@syzkaller.appspotmail.com
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/file.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -147,26 +147,24 @@ static ssize_t udf_file_write_iter(struc
 		goto out;
 
 	down_write(&iinfo->i_data_sem);
-	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
-		loff_t end = iocb->ki_pos + iov_iter_count(from);
-
-		if (inode->i_sb->s_blocksize <
-				(udf_file_entry_alloc_offset(inode) + end)) {
-			err = udf_expand_file_adinicb(inode);
-			if (err) {
-				inode_unlock(inode);
-				udf_debug("udf_expand_adinicb: err=%d\n", err);
-				return err;
-			}
-		} else {
-			iinfo->i_lenAlloc = max(end, inode->i_size);
-			up_write(&iinfo->i_data_sem);
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB &&
+	    inode->i_sb->s_blocksize < (udf_file_entry_alloc_offset(inode) +
+				 iocb->ki_pos + iov_iter_count(from))) {
+		err = udf_expand_file_adinicb(inode);
+		if (err) {
+			inode_unlock(inode);
+			udf_debug("udf_expand_adinicb: err=%d\n", err);
+			return err;
 		}
 	} else
 		up_write(&iinfo->i_data_sem);
 
 	retval = __generic_file_write_iter(iocb, from);
 out:
+	down_write(&iinfo->i_data_sem);
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB && retval > 0)
+		iinfo->i_lenAlloc = inode->i_size;
+	up_write(&iinfo->i_data_sem);
 	inode_unlock(inode);
 
 	if (retval > 0) {


