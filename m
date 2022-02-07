Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240FC4ABD80
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356806AbiBGLop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385168AbiBGLbR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:31:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F27AC0302D0;
        Mon,  7 Feb 2022 03:29:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4DEFB80EBD;
        Mon,  7 Feb 2022 11:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CF1C004E1;
        Mon,  7 Feb 2022 11:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233366;
        bh=CfF5WdTDKr8HJN9/b0LVxkEDlz1x+4lkrQSzwtW1+XQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pe/fKzpH4R9gRFrlIt5iCWLSc8lYa6xlmR8KGwcEaGC8LrbkQLJpx1/tZTsrJTIBC
         e0ckHU73IAG6RccQi5cJZQ3Ygrway+mskupOw24pELlrARclchW/lRAB/dzgrbNTSm
         1VIPIwbf94uxwQ06Tx641nQmh3zLbRVr8NlrlVTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Whitney <enwlinux@gmail.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 5.15 101/110] ext4: fix error handling in ext4_restore_inline_data()
Date:   Mon,  7 Feb 2022 12:07:14 +0100
Message-Id: <20220207103805.814201997@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ritesh Harjani <riteshh@linux.ibm.com>

commit 897026aaa73eb2517dfea8d147f20ddb0b813044 upstream.

While running "./check -I 200 generic/475" it sometimes gives below
kernel BUG(). Ideally we should not call ext4_write_inline_data() if
ext4_create_inline_data() has failed.

<log snip>
[73131.453234] kernel BUG at fs/ext4/inline.c:223!

<code snip>
 212 static void ext4_write_inline_data(struct inode *inode, struct ext4_iloc *iloc,
 213                                    void *buffer, loff_t pos, unsigned int len)
 214 {
<...>
 223         BUG_ON(!EXT4_I(inode)->i_inline_off);
 224         BUG_ON(pos + len > EXT4_I(inode)->i_inline_size);

This patch handles the error and prints out a emergency msg saying potential
data loss for the given inode (since we couldn't restore the original
inline_data due to some previous error).

[ 9571.070313] EXT4-fs (dm-0): error restoring inline_data for inode -- potential data loss! (inode 1703982, error -30)

Reported-by: Eric Whitney <enwlinux@gmail.com>
Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/9f4cd7dfd54fa58ff27270881823d94ddf78dd07.1642416995.git.riteshh@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inline.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1133,7 +1133,15 @@ static void ext4_restore_inline_data(han
 				     struct ext4_iloc *iloc,
 				     void *buf, int inline_size)
 {
-	ext4_create_inline_data(handle, inode, inline_size);
+	int ret;
+
+	ret = ext4_create_inline_data(handle, inode, inline_size);
+	if (ret) {
+		ext4_msg(inode->i_sb, KERN_EMERG,
+			"error restoring inline_data for inode -- potential data loss! (inode %lu, error %d)",
+			inode->i_ino, ret);
+		return;
+	}
 	ext4_write_inline_data(inode, iloc, buf, 0, inline_size);
 	ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
 }


