Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A18826DE5F
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731041AbfGSEGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:06:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732176AbfGSEGb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:06:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30518218BB;
        Fri, 19 Jul 2019 04:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509190;
        bh=sInZRDAzcu3qDg3rdtC9NUEMxSLGzL2xT7nPf06MNjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e1bXcGCZrV/w5KugqEROdb28LVnov0L9zXoOCbTvpKef8mMFuuhn8Wdgo0NrVcrN4
         LmOUUo1UYOuKrrmaYXyF4IU2LEiiEy50io+YEbxoNFbrEZmfzIV11GKr8Rj7k8uuP0
         1aMZDphTM1R1k9pxcDEex4FZFKsjnp2bfYnhsFIw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Windsor <dwindsor@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.1 118/141] dlm: check if workqueues are NULL before flushing/destroying
Date:   Fri, 19 Jul 2019 00:02:23 -0400
Message-Id: <20190719040246.15945-118-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Windsor <dwindsor@redhat.com>

[ Upstream commit b355516f450703c9015316e429b66a93dfff0e6f ]

If the DLM lowcomms stack is shut down before any DLM
traffic can be generated, flush_workqueue() and
destroy_workqueue() can be called on empty send and/or recv
workqueues.

Insert guard conditionals to only call flush_workqueue()
and destroy_workqueue() on workqueues that are not NULL.

Signed-off-by: David Windsor <dwindsor@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index c98ad9777ad9..88d7ec76f669 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1630,8 +1630,10 @@ static void clean_writequeues(void)
 
 static void work_stop(void)
 {
-	destroy_workqueue(recv_workqueue);
-	destroy_workqueue(send_workqueue);
+	if (recv_workqueue)
+		destroy_workqueue(recv_workqueue);
+	if (send_workqueue)
+		destroy_workqueue(send_workqueue);
 }
 
 static int work_start(void)
@@ -1691,13 +1693,17 @@ static void work_flush(void)
 	struct hlist_node *n;
 	struct connection *con;
 
-	flush_workqueue(recv_workqueue);
-	flush_workqueue(send_workqueue);
+	if (recv_workqueue)
+		flush_workqueue(recv_workqueue);
+	if (send_workqueue)
+		flush_workqueue(send_workqueue);
 	do {
 		ok = 1;
 		foreach_conn(stop_conn);
-		flush_workqueue(recv_workqueue);
-		flush_workqueue(send_workqueue);
+		if (recv_workqueue)
+			flush_workqueue(recv_workqueue);
+		if (send_workqueue)
+			flush_workqueue(send_workqueue);
 		for (i = 0; i < CONN_HASH_SIZE && ok; i++) {
 			hlist_for_each_entry_safe(con, n,
 						  &connection_hash[i], list) {
-- 
2.20.1

