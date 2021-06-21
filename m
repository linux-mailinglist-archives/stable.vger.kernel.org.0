Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963C93AEE61
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbhFUQ21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:28:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231589AbhFUQ1C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:27:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 170616128E;
        Mon, 21 Jun 2021 16:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292558;
        bh=hfnzbVWcwsH8/+bJTSjIfwRk3lyiI9VBxrhkZKJnFCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WINcD6E8i8uAmID8FPmlxgkXw5B323pDTe8xWym2XVTezY0NJUj/CCZgLTgth3inr
         N5S+QGoyrOVczLpryCYbldlENY2aFLsHMg3Vstf9yoUiRV/okUUyNiolT2oXuSSwuk
         ihhDaM/bBqjNVErOj9TXoO6TJUruSE9wuFSX64jY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Bobrowski <repnop@google.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/146] fanotify: fix copy_event_to_user() fid error clean up
Date:   Mon, 21 Jun 2021 18:14:01 +0200
Message-Id: <20210621154911.643012865@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Bobrowski <repnop@google.com>

[ Upstream commit f644bc449b37cc32d3ce7b36a88073873aa21bd5 ]

Ensure that clean up is performed on the allocated file descriptor and
struct file object in the event that an error is encountered while copying
fid info objects. Currently, we return directly to the caller when an error
is experienced in the fid info copying helper, which isn't ideal given that
the listener process could be left with a dangling file descriptor in their
fdtable.

Fixes: 5e469c830fdb ("fanotify: copy event fid info to user")
Fixes: 44d705b0370b ("fanotify: report name info for FAN_DIR_MODIFY event")
Link: https://lore.kernel.org/linux-fsdevel/YMKv1U7tNPK955ho@google.com/T/#m15361cd6399dad4396aad650de25dbf6b312288e
Link: https://lore.kernel.org/r/1ef8ae9100101eb1a91763c516c2e9a3a3b112bd.1623376346.git.repnop@google.com
Signed-off-by: Matthew Bobrowski <repnop@google.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index dcab112e1f00..086b6bacbad1 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -378,7 +378,7 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 					info_type, fanotify_info_name(info),
 					info->name_len, buf, count);
 		if (ret < 0)
-			return ret;
+			goto out_close_fd;
 
 		buf += ret;
 		count -= ret;
@@ -426,7 +426,7 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 					fanotify_event_object_fh(event),
 					info_type, dot, dot_len, buf, count);
 		if (ret < 0)
-			return ret;
+			goto out_close_fd;
 
 		buf += ret;
 		count -= ret;
-- 
2.30.2



