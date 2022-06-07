Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 916E8541DDA
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355812AbiFGWWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385263AbiFGWVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:21:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E7026714C;
        Tue,  7 Jun 2022 12:21:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BB23600E1;
        Tue,  7 Jun 2022 19:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE22C385A5;
        Tue,  7 Jun 2022 19:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629674;
        bh=YIivGeXXRfB6Sue+gelH2WioHvR7o0hxg8DWNPtEYV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/thVNzVhAbi0odMCe5GYZAmHOvM53KLft4PVcS2xcc7Lxw9OfS0cqeHm1lUE499J
         OJd/Z6lUzekGjXqrqvhITJdw+RCv+vCJ+gKjpB/CN5fqEnmbjEK/idIWXXUNVpbmRG
         ukvkjfsAi2NMRqk0bkzOVOH/jBvVDaapmkT2r79o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 5.18 777/879] landlock: Fix landlock_add_rule(2) documentation
Date:   Tue,  7 Jun 2022 19:04:55 +0200
Message-Id: <20220607165025.424498434@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Mickaël Salaün <mic@digikod.net>

commit a13e248ff90e81e9322406c0e618cf2168702f4e upstream.

It is not mandatory to pass a file descriptor obtained with the O_PATH
flag.  Also, replace rule's accesses with ruleset's accesses.

Link: https://lore.kernel.org/r/20220506160820.524344-2-mic@digikod.net
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/landlock.h |    5 +++--
 security/landlock/syscalls.c  |    7 +++----
 2 files changed, 6 insertions(+), 6 deletions(-)

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
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -292,14 +292,13 @@ out_fdput:
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


