Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA02382E63
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237953AbhEQOGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:06:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:58468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237776AbhEQOG2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:06:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B4D761353;
        Mon, 17 May 2021 14:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260301;
        bh=SO9IKWOyCylg4f9B+Qdx/AnBqlmOYXNz4K9BRYu2yTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pmnf7hCBGs9mWwfCohjH+Mt6jM1GyGya9gysDGDqbQAbrvOPjHMB3zINm/tv6yh4t
         UCcmO1/QapT6Sq/V8TIM8haxZ1RJ6eld9/j8+6L5VkDhgEONwTEZhdizAsw+U/cTjG
         S5Xn2UBs+HCpJh+ABXKGVmV5+Zk3z3iZpV6SMxa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 020/363] fs: dlm: flush swork on shutdown
Date:   Mon, 17 May 2021 15:58:06 +0200
Message-Id: <20210517140303.267143791@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f827d0b3962a..5fe571e44b1a 100644
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



