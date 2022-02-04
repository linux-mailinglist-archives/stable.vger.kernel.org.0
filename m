Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74A6D4A9611
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357514AbiBDJWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357549AbiBDJVs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:21:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB76C06176E;
        Fri,  4 Feb 2022 01:21:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38D31B836ED;
        Fri,  4 Feb 2022 09:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7547DC004E1;
        Fri,  4 Feb 2022 09:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966507;
        bh=QxDpZTI1T/K786gFZQxlq1ZSoTSFEF/Vn8/D4xcS44c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URPHy5IoTX2oI7bxOzQTf3yjKRCC9jG62/PjrOEuVPZMxk0a7H+5Z/0I2bzjbBbiT
         MUhtlAPnaCVlBDT+hoA7scMDIgBKi74ZuihiP3/uQjpDyvloHooqPFyxXtV5JlBaSi
         c78r17kPmkWf+pg5UX6mmSGYCApHYohp1+nPafK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mathias Krause <minipli@grsecurity.net>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.10 20/25] fanotify: Fix stale file descriptor in copy_event_to_user()
Date:   Fri,  4 Feb 2022 10:20:27 +0100
Message-Id: <20220204091914.933296036@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091914.280602669@linuxfoundation.org>
References: <20220204091914.280602669@linuxfoundation.org>
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
@@ -366,9 +366,6 @@ static ssize_t copy_event_to_user(struct
 	if (fanotify_is_perm_event(event->mask))
 		FANOTIFY_PERM(event)->fd = fd;
 
-	if (f)
-		fd_install(fd, f);
-
 	/* Event info records order is: dir fid + name, child fid */
 	if (fanotify_event_dir_fh_len(event)) {
 		info_type = info->name_len ? FAN_EVENT_INFO_TYPE_DFID_NAME :
@@ -432,6 +429,9 @@ static ssize_t copy_event_to_user(struct
 		count -= ret;
 	}
 
+	if (f)
+		fd_install(fd, f);
+
 	return metadata.event_len;
 
 out_close_fd:


