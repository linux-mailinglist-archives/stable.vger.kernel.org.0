Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CED9594D0A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233380AbiHPAwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344545AbiHPAtF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:49:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C8E169C75;
        Mon, 15 Aug 2022 13:45:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E0478CE1187;
        Mon, 15 Aug 2022 20:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B020AC433C1;
        Mon, 15 Aug 2022 20:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596351;
        bh=+qpLPaKGzazoYN5NC/HJnxora1lgK1xSLQ58YvKLZK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EPQR4Y5wpukCCaGP04UA0mwLGOaEV5i2c6FXhoXfT6cW/Q+ZJcf9s7ao2uSuXh3BN
         76ZP6bXtgM8DQ+RQtwMWr+TUShok5CyQb4Y2EpUkHYAI0uftifFUY/OjvzWoRK1tLN
         dxJc2mj98ld6LsHifpm53y8BhNYb5MKQof0gx9OY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.19 1053/1157] __follow_mount_rcu(): verify that mount_lock remains unchanged
Date:   Mon, 15 Aug 2022 20:06:49 +0200
Message-Id: <20220815180522.175089622@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Al Viro <viro@zeniv.linux.org.uk>

commit 20aac6c60981f5bfacd66661d090d907bf1482f0 upstream.

Validate mount_lock seqcount as soon as we cross into mount in RCU
mode.  Sure, ->mnt_root is pinned and will remain so until we
do rcu_read_unlock() anyway, and we will eventually fail to unlazy if
the mount_lock had been touched, but we might run into a hard error
(e.g. -ENOENT) before trying to unlazy.  And it's possible to end
up with RCU pathwalk racing with rename() and umount() in a way
that would fail with -ENOENT while non-RCU pathwalk would've
succeeded with any timings.

Once upon a time we hadn't needed that, but analysis had been subtle,
brittle and went out of window as soon as RENAME_EXCHANGE had been
added.

It's narrow, hard to hit and won't get you anything other than
stray -ENOENT that could be arranged in much easier way with the
same priveleges, but it's a bug all the same.

Cc: stable@kernel.org
X-sky-is-falling: unlikely
Fixes: da1ce0670c14 "vfs: add cross-rename"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namei.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1505,6 +1505,8 @@ static bool __follow_mount_rcu(struct na
 				 * becoming unpinned.
 				 */
 				flags = dentry->d_flags;
+				if (read_seqretry(&mount_lock, nd->m_seq))
+					return false;
 				continue;
 			}
 			if (read_seqretry(&mount_lock, nd->m_seq))


