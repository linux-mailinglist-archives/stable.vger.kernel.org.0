Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133974A96CF
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358046AbiBDJaE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:30:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358034AbiBDJ2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:28:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149CBC061340;
        Fri,  4 Feb 2022 01:27:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAB25B836EE;
        Fri,  4 Feb 2022 09:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3991C004E1;
        Fri,  4 Feb 2022 09:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966818;
        bh=u95f1E3cPlDrVSm0z4hyvD5olgUXo83F6mv+pe0hmvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q8ui5L3TEu2rsCurl2sOISdsVpwFEmnekwzAPGJEyteoJjBqdFVCyM5gT0G3XQd1K
         hlhhdsdl+/nc+47eKDmubnJs5U6vVxSaj6rR1+695j0IMCZ+ZrWl2h6ZB9IjRGFTCx
         31Gp0gzjmWufSWrHL84FV/mZKn7UYZyKBL8IaKY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mathias Krause <minipli@grsecurity.net>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.16 34/43] fanotify: Fix stale file descriptor in copy_event_to_user()
Date:   Fri,  4 Feb 2022 10:22:41 +0100
Message-Id: <20220204091918.278563230@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
References: <20220204091917.166033635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit ee12595147ac1fbfb5bcb23837e26dd58d94b15d upstream.

This code calls fd_install() which gives the userspace access to the fd.
Then if copy_info_records_to_user() fails it calls put_unused_fd(fd) but
that will not release it and leads to a stale entry in the file
descriptor table.

Generally you can't trust the fd after a call to fd_install().  The fix
is to delay the fd_install() until everything else has succeeded.

Fortunately it requires CAP_SYS_ADMIN to reach this code so the security
impact is less.

Fixes: f644bc449b37 ("fanotify: fix copy_event_to_user() fid error clean up")
Link: https://lore.kernel.org/r/20220128195656.GA26981@kili
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/notify/fanotify/fanotify_user.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -656,9 +656,6 @@ static ssize_t copy_event_to_user(struct
 	if (fanotify_is_perm_event(event->mask))
 		FANOTIFY_PERM(event)->fd = fd;
 
-	if (f)
-		fd_install(fd, f);
-
 	if (info_mode) {
 		ret = copy_info_records_to_user(event, info, info_mode, pidfd,
 						buf, count);
@@ -666,6 +663,9 @@ static ssize_t copy_event_to_user(struct
 			goto out_close_fd;
 	}
 
+	if (f)
+		fd_install(fd, f);
+
 	return metadata.event_len;
 
 out_close_fd:


