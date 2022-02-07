Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A136E4ABAE3
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384121AbiBGLYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241231AbiBGLKV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:10:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BADC043188;
        Mon,  7 Feb 2022 03:10:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABB6B613FB;
        Mon,  7 Feb 2022 11:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7A0C004E1;
        Mon,  7 Feb 2022 11:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232220;
        bh=khYj2u5+P6ilGQgIZTfojHq9WrTK93UBtTZQe0B6Vtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W0rPuoPCBRG56Cv+wHyDJcQUcr3rIt1OrdDkWSP6csnIzZmGg6hgWEn/Si1RZTtrF
         KRdutpaqId89OZFyAVj3oFvm6Iv/rNl1LAmnmKGKIm+hosf6PPkBRJ7ODdfyI+OpSy
         HP1tOUDVx2XxOt1v9iFpqiKqY0x9E4XkwovI2r80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Whitney <enwlinux@gmail.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 4.9 48/48] ext4: fix error handling in ext4_restore_inline_data()
Date:   Mon,  7 Feb 2022 12:06:21 +0100
Message-Id: <20220207103753.889781423@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103752.341184175@linuxfoundation.org>
References: <20220207103752.341184175@linuxfoundation.org>
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
@@ -1123,7 +1123,15 @@ static void ext4_restore_inline_data(han
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


