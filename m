Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA21374397
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbhEEQvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:51:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236155AbhEEQrk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:47:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA73061934;
        Wed,  5 May 2021 16:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232616;
        bh=GTG8bbh8V6Po43xFaE8EyHLkS4c8grvCURbwrR39XoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U0/8bcudKM2m02FT+R5hdLHj6CCHwaaFclj/EyYuizVy9wW534WrVJmhbohaafzmi
         KyAPkbVd/8qGaa3EPQ2PAyi5IOTi85uwLpyZolklE/lruIEw9+aL9jh9rgga5FjKLY
         wGTudXcM/lCpiBupNHfaMih8XxzLnn/EqM/rQZFiEpdHFtGiXx9eDqT2hYh1Zu7aN/
         YR23kX/GR9jo2ueAoM0bTyzXglgqNBEotCQ8BS0pxnbapWXT3SJwExm44dJO/DU/om
         9DMcLyGjS1iWRpdJ9qjjaAzCRY4h6nSxTakLXF67ycMjMor/6uXj4QufRTHikLywuC
         snL8PCERL4GGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.10 05/85] fs: dlm: flush swork on shutdown
Date:   Wed,  5 May 2021 12:35:28 -0400
Message-Id: <20210505163648.3462507-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
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
index 79f56f16bc2c..44e2716ac158 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -612,10 +612,7 @@ static void shutdown_connection(struct connection *con)
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

