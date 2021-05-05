Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFDD3741EB
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235517AbhEEQmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:42:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234363AbhEEQkG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:40:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2E0461428;
        Wed,  5 May 2021 16:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232466;
        bh=Uz1VNF65UmiNq8lw5w4k+PsIosiA5GRji5y++Fpyjs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nI8NbTRxIFV/f4KOPFg2gY/nn8XDh2ffep2rhfVfKHrHSiOEF6FgJ0C0X/5VZIE8H
         +5qOPd0FD5fXy3ykJ/soSFwvWwGu3Px5f+5HDenHE1jR7T74qsDL8YTDLpvcPj0adq
         KV8aQJ7+0DcfssaFup50yaXmu5Bo+p94eXLEGmS1ux7vZSau13KMNQLQQqG2yM2tGx
         0YYrAtcqBitlZfAQyDvtN4cQQ3gLTm9XqHhXD2eOd4LsQkG+UT7j6b7hgg2NkD2tNg
         CSkqPldTPh33QRZDhIbiYDMsEFx1fDeaaIsM2Gwq/cFshb4tmWkznbw8EaspnQ1Qo/
         mYV8q+jdizcqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.11 009/104] fs: dlm: flush swork on shutdown
Date:   Wed,  5 May 2021 12:32:38 -0400
Message-Id: <20210505163413.3461611-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit eec054b5a7cfe6d1f1598a323b05771ee99857b5 ]

This patch fixes the flushing of send work before shutdown. The function
cancel_work_sync() is not the right workqueue functionality to use here
as it would cancel the work if the work queues itself. In cases of
EAGAIN in send() for dlm message we need to be sure that everything is
send out before. The function flush_work() will ensure that every send
work is be done inclusive in EAGAIN cases.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 39d6418f6e89..2ab2a38cb3b7 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -709,10 +709,7 @@ static void shutdown_connection(struct connection *con)
 {
 	int ret;
 
-	if (cancel_work_sync(&con->swork)) {
-		log_print("canceled swork for node %d", con->nodeid);
-		clear_bit(CF_WRITE_PENDING, &con->flags);
-	}
+	flush_work(&con->swork);
 
 	mutex_lock(&con->sock_mutex);
 	/* nothing to shutdown */
-- 
2.30.2

