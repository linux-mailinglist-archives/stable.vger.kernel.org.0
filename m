Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690654A9661
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357699AbiBDJZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:25:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43630 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357554AbiBDJYc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:24:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18809616DB;
        Fri,  4 Feb 2022 09:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06A3C340EF;
        Fri,  4 Feb 2022 09:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966671;
        bh=ZzMj6G9e6/gWX7cJeYR8I7KvzFa61O0cT2/d4KYtnsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LmIs9LcNmIDEgis9fGmzfKwy0n7j5DYhqFCFDz33xnobrg0dUqKiqNpKDbau/A1c5
         SgbxKLocC9PPpGzH7IG9I2EYMsJRMypcr/L5lPDonE23P8ArBtv84OVf0D57S0WFwQ
         eXgxUAIKFGwIOVkrO/5SE5LIx2FX2yWl/EJnY84s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mathias Krause <minipli@grsecurity.net>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.15 26/32] fanotify: Fix stale file descriptor in copy_event_to_user()
Date:   Fri,  4 Feb 2022 10:22:36 +0100
Message-Id: <20220204091916.121063674@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091915.247906930@linuxfoundation.org>
References: <20220204091915.247906930@linuxfoundation.org>
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
@@ -611,9 +611,6 @@ static ssize_t copy_event_to_user(struct
 	if (fanotify_is_perm_event(event->mask))
 		FANOTIFY_PERM(event)->fd = fd;
 
-	if (f)
-		fd_install(fd, f);
-
 	if (info_mode) {
 		ret = copy_info_records_to_user(event, info, info_mode, pidfd,
 						buf, count);
@@ -621,6 +618,9 @@ static ssize_t copy_event_to_user(struct
 			goto out_close_fd;
 	}
 
+	if (f)
+		fd_install(fd, f);
+
 	return metadata.event_len;
 
 out_close_fd:


