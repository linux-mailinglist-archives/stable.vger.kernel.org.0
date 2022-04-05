Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0004F25AF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbiDEHvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233544AbiDEHr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:47:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE24F9233D;
        Tue,  5 Apr 2022 00:45:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40AE9616BF;
        Tue,  5 Apr 2022 07:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EAFC340EE;
        Tue,  5 Apr 2022 07:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144716;
        bh=S9aXtfEKDGdBQZkVkd+a1yTaeGJtvtEgjUrZ0wayzj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zECrY2ubk9bbWD8Xelbj5t1VFMrP8BHD3mPnKv+fxCVbTfzAQdeFh5xMex2muf66+
         G89v0ISDKlHgXBe5j6cBI9GWttYqO7juHxP6Ei0C626v4LGSutqJ82iZXwHeWzQLCf
         T1EATTi1DFHdGNdzv6x+r7XIlPA3oFqv21s9MZXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-security-module@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>
Subject: [PATCH 5.17 0138/1126] landlock: Use square brackets around "landlock-ruleset"
Date:   Tue,  5 Apr 2022 09:14:45 +0200
Message-Id: <20220405070411.629673184@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Christian Brauner <christian.brauner@ubuntu.com>

commit aea0b9f2486da8497f35c7114b764bf55e17c7ea upstream.

Make the name of the anon inode fd "[landlock-ruleset]" instead of
"landlock-ruleset". This is minor but most anon inode fds already
carry square brackets around their name:

    [eventfd]
    [eventpoll]
    [fanotify]
    [fscontext]
    [io_uring]
    [pidfd]
    [signalfd]
    [timerfd]
    [userfaultfd]

For the sake of consistency lets do the same for the landlock-ruleset anon
inode fd that comes with landlock. We did the same in
1cdc415f1083 ("uapi, fsopen: use square brackets around "fscontext" [ver #2]")
for the new mount api.

Cc: linux-security-module@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/r/20211011133704.1704369-1-brauner@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/syscalls.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -192,7 +192,7 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
 		return PTR_ERR(ruleset);
 
 	/* Creates anonymous FD referring to the ruleset. */
-	ruleset_fd = anon_inode_getfd("landlock-ruleset", &ruleset_fops,
+	ruleset_fd = anon_inode_getfd("[landlock-ruleset]", &ruleset_fops,
 			ruleset, O_RDWR | O_CLOEXEC);
 	if (ruleset_fd < 0)
 		landlock_put_ruleset(ruleset);


