Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D747153E234
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 10:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbiFFHtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 03:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiFFHts (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 03:49:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79669ABE7A
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 00:49:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31852B811CE
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 07:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F993C385A9;
        Mon,  6 Jun 2022 07:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654501785;
        bh=pp5VSp48kGRd+eDtAKqymDsTM91/Xi9zP8tL9DUJoTY=;
        h=Subject:To:Cc:From:Date:From;
        b=n/rsLyAajk2WdFYbglh9EgsDtP/HaH/jU4CVkOR0QZzNjP2QMmEu/MWPkhPeH8ORI
         u0LA8ChjyTruK++I4HEWVI2VecflnyY3d5dZIz6v4yqBBSJypJCLvj17XYxtX7T0wy
         WZ0Yuus2wJGAEQ8fsw1L9Gg8EZVGYusOIhqZwSU8=
Subject: WTF: patch "[PATCH] landlock: Fix landlock_add_rule(2) documentation" was seriously submitted to be applied to the 5.18-stable tree?
To:     mic@digikod.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 09:49:42 +0200
Message-ID: <165450178225224@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below was submitted to be applied to the 5.18-stable tree.

I fail to see how this patch meets the stable kernel rules as found at
Documentation/process/stable-kernel-rules.rst.

I could be totally wrong, and if so, please respond to 
<stable@vger.kernel.org> and let me know why this patch should be
applied.  Otherwise, it is now dropped from my patch queues, never to be
seen again.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a13e248ff90e81e9322406c0e618cf2168702f4e Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Date: Fri, 6 May 2022 18:08:11 +0200
Subject: [PATCH] landlock: Fix landlock_add_rule(2) documentation
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

It is not mandatory to pass a file descriptor obtained with the O_PATH
flag.  Also, replace rule's accesses with ruleset's accesses.

Link: https://lore.kernel.org/r/20220506160820.524344-2-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>

diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
index 15c31abb0d76..21c8d58283c9 100644
--- a/include/uapi/linux/landlock.h
+++ b/include/uapi/linux/landlock.h
@@ -62,8 +62,9 @@ struct landlock_path_beneath_attr {
 	 */
 	__u64 allowed_access;
 	/**
-	 * @parent_fd: File descriptor, open with ``O_PATH``, which identifies
-	 * the parent directory of a file hierarchy, or just a file.
+	 * @parent_fd: File descriptor, preferably opened with ``O_PATH``,
+	 * which identifies the parent directory of a file hierarchy, or just a
+	 * file.
 	 */
 	__s32 parent_fd;
 	/*
diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index 2fde978bf8ca..7edc1d50e2bf 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -292,14 +292,13 @@ static int get_path_from_fd(const s32 fd, struct path *const path)
  *
  * - EOPNOTSUPP: Landlock is supported by the kernel but disabled at boot time;
  * - EINVAL: @flags is not 0, or inconsistent access in the rule (i.e.
- *   &landlock_path_beneath_attr.allowed_access is not a subset of the rule's
- *   accesses);
+ *   &landlock_path_beneath_attr.allowed_access is not a subset of the
+ *   ruleset handled accesses);
  * - ENOMSG: Empty accesses (e.g. &landlock_path_beneath_attr.allowed_access);
  * - EBADF: @ruleset_fd is not a file descriptor for the current thread, or a
  *   member of @rule_attr is not a file descriptor as expected;
  * - EBADFD: @ruleset_fd is not a ruleset file descriptor, or a member of
- *   @rule_attr is not the expected file descriptor type (e.g. file open
- *   without O_PATH);
+ *   @rule_attr is not the expected file descriptor type;
  * - EPERM: @ruleset_fd has no write access to the underlying ruleset;
  * - EFAULT: @rule_attr inconsistency.
  */

