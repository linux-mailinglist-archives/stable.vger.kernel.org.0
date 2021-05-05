Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B431373FEA
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbhEEQcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:32:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:52166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234153AbhEEQcd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:32:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67623610E6;
        Wed,  5 May 2021 16:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232297;
        bh=Uz1VNF65UmiNq8lw5w4k+PsIosiA5GRji5y++Fpyjs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tf2g9nsiNX2SSQhM84SNPoUBCA/wWNtuP0XrwMVocK6u3xz6m+3kB8tZnCaAtTwI6
         i2fcbCfO4WuJhHH262cIu7oi5Csl/iTPDCUn7hGfgjwBXziGzZEv8OADnmByaShJxQ
         4HQSgKAW6Y8mC2C5hgBUXeKXtLAmdGNCkD/edxyzJRq+WVumC7JExrhSRbg6sBZ4ZZ
         eb4BfqwancWlIU2wieqVzJH1m13AdbZpAK0wFNnoIJOj7EgOZsdEBrs8q+j104H6LE
         sUiehK7CzOqaJ46PPtWNqJqyv+P1mCMYcDeSyWvgGv+q/apI+jtfiYvfg5gbKwc0sN
         weQ8JMCwjuPFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.12 009/116] fs: dlm: flush swork on shutdown
Date:   Wed,  5 May 2021 12:29:37 -0400
Message-Id: <20210505163125.3460440-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
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

