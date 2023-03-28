Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43DA66CC62A
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbjC1PZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234003AbjC1PYr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:24:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C80A11649
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:23:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B77BB61843
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C443AC433D2;
        Tue, 28 Mar 2023 15:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016219;
        bh=txF2T2SbSjdoLscauRl8pEarQae68Wx84Dx4jlY8UB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2g0774kmJRBFArwbEmBB9A1VhKfmOYcW8MRe9uOTm/qNsxw9cFYniRpxwZXM6/bmm
         A06rf5M4mJJn8/lPAb82Lwb8m5YfxuuDg8RqouFHH1QRc2+fXujXg22TIecimPvJVP
         P2mW4XK4lzQqZyFOTSKTY+AhYSIlYKhZ5hsgBsKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+93e495f6a4f748827c88@syzkaller.appspotmail.com,
        Christian Brauner <brauner@kernel.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5.15 109/146] fscrypt: destroy keyring after security_sb_delete()
Date:   Tue, 28 Mar 2023 16:43:18 +0200
Message-Id: <20230328142607.225405811@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit ccb820dc7d2236b1af0d54ae038a27b5b6d5ae5a upstream.

fscrypt_destroy_keyring() must be called after all potentially-encrypted
inodes were evicted; otherwise it cannot safely destroy the keyring.
Since inodes that are in-use by the Landlock LSM don't get evicted until
security_sb_delete(), this means that fscrypt_destroy_keyring() must be
called *after* security_sb_delete().

This fixes a WARN_ON followed by a NULL dereference, only possible if
Landlock was being used on encrypted files.

Fixes: d7e7b9af104c ("fscrypt: stop using keyrings subsystem for fscrypt_master_key")
Cc: stable@vger.kernel.org
Reported-by: syzbot+93e495f6a4f748827c88@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/00000000000044651705f6ca1e30@google.com
Reviewed-by: Christian Brauner <brauner@kernel.org>
Link: https://lore.kernel.org/r/20230313221231.272498-2-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/super.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/fs/super.c
+++ b/fs/super.c
@@ -450,13 +450,22 @@ void generic_shutdown_super(struct super
 
 		cgroup_writeback_umount();
 
-		/* evict all inodes with zero refcount */
+		/* Evict all inodes with zero refcount. */
 		evict_inodes(sb);
-		/* only nonzero refcount inodes can have marks */
+
+		/*
+		 * Clean up and evict any inodes that still have references due
+		 * to fsnotify or the security policy.
+		 */
 		fsnotify_sb_delete(sb);
-		fscrypt_destroy_keyring(sb);
 		security_sb_delete(sb);
 
+		/*
+		 * Now that all potentially-encrypted inodes have been evicted,
+		 * the fscrypt keyring can be destroyed.
+		 */
+		fscrypt_destroy_keyring(sb);
+
 		if (sb->s_dio_done_wq) {
 			destroy_workqueue(sb->s_dio_done_wq);
 			sb->s_dio_done_wq = NULL;


