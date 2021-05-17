Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8506383144
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239676AbhEQOgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:36:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240273AbhEQOdn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:33:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6998A6191C;
        Mon, 17 May 2021 14:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260976;
        bh=cYITyM34fRkL0DDHNTO3gYgW71M19umtL2N33h6CW4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w5Mn+dRvsgqovD5fIqUG6wMhvxWJizTh3RoExjchYwiu5SqRShC0bosULOvqWFWhu
         il2YczCcwAH87PN9rYLwXV3UFnCHVCBmQUQEzUTkZNC5U2K3QSOjTn4KzZAn71Z8pP
         P6yEHAJAeIg0Tr1Hw1HyrMSJ+2X8ErqP1Dj1BO9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 020/329] fs: dlm: flush swork on shutdown
Date:   Mon, 17 May 2021 15:58:51 +0200
Message-Id: <20210517140302.730987387@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
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



inuxfoundation.org>
---
 arch/powerpc/lib/feature-fixups.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/arch/powerpc/lib/feature-fixups.c
+++ b/arch/powerpc/lib/feature-fixups.c
@@ -299,8 +299,9 @@ void do_uaccess_flush_fixups(enum l1d_fl
 						: "unknown");
 }
 
-void do_entry_flush_fixups(enum l1d_flush_type types)
+static int __do_entry_flush_fixups(void *data)
 {
+	enum l1d_flush_type types = *(enum l1d_flush_type *)data;
 	unsigned int instrs[3], *dest;
 	long *start, *end;
 	int i;
@@ -369,6 +370,19 @@ void do_entry_flush_fixups(enum l1d_flus
 							: "ori type" :
 		(types &  L1D_FLUSH_MTTRIG)     ? "mttrig type"
 						: "unknown");
+
+	return 0;
+}
+
+void do_entry_flush_fixups(enum l1d_flush_type types)
+{
+	/*
+	 * The call to the fallback flush can not be safely patched in/out while
+	 * other CPUs are executing it. So call __do_entry_flush_fixups() on one
+	 * CPU while all other CPUs spin in the stop machine core with interrupts
+	 * hard disabled.
+	 */
+	stop_machine(__do_entry_flush_fixups, &types, NULL);
 }
 
 void do_rfi_flush_fixups(enum l1d_flush_type types)


