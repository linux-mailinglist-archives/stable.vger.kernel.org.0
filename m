Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69BD03BBF8D
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbhGEPc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:32:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232234AbhGEPcO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:32:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D930C6198B;
        Mon,  5 Jul 2021 15:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498977;
        bh=YXHak61v1O7A050cPtVIAPc15LkwuBJvwNxrg1ZOtAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ScOIva+cOhLX2TvTPAbxBo5doh9s0Dz5ZUPIa7v4wZ/ggWr3trd0czajwFFVtHBoq
         3tdm18qtGvN56MvSKZhm76aQw3+GpV9hvWghZwGvkOisJ0NBkwuxlcAQjp6hE8tmF5
         cCn08frx42svWDqPsL4TtkWk3yd29YHNVQ1SRTNnpT+71bCg6Oq6NKrwXXQU7FFLCC
         +ZTKk5ZTn59PyN5tUVJ/NplsxmD8a7HJtKu6TeUgDDyj6setJB0AEWeOdet39OZMHG
         D+w0og6kw/ybtLLhF6LQQEyppmUJPYI9W49g8e4NZzLzD9DGEHOzNj01E3Avd4TY88
         8tbDJiz1hcilA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.12 19/52] fs: dlm: fix lowcomms_start error case
Date:   Mon,  5 Jul 2021 11:28:40 -0400
Message-Id: <20210705152913.1521036-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705152913.1521036-1-sashal@kernel.org>
References: <20210705152913.1521036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit fcef0e6c27ce109d2c617aa12f0bfd9f7ff47d38 ]

This patch fixes the error path handling in lowcomms_start(). We need to
cleanup some static allocated data structure and cleanup possible
workqueue if these have started.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 7e6736c70e11..d2a0ea0acca3 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1600,10 +1600,15 @@ static void process_send_sockets(struct work_struct *work)
 
 static void work_stop(void)
 {
-	if (recv_workqueue)
+	if (recv_workqueue) {
 		destroy_workqueue(recv_workqueue);
-	if (send_workqueue)
+		recv_workqueue = NULL;
+	}
+
+	if (send_workqueue) {
 		destroy_workqueue(send_workqueue);
+		send_workqueue = NULL;
+	}
 }
 
 static int work_start(void)
@@ -1620,6 +1625,7 @@ static int work_start(void)
 	if (!send_workqueue) {
 		log_print("can't start dlm_send");
 		destroy_workqueue(recv_workqueue);
+		recv_workqueue = NULL;
 		return -ENOMEM;
 	}
 
@@ -1751,7 +1757,7 @@ int dlm_lowcomms_start(void)
 
 	error = work_start();
 	if (error)
-		goto fail;
+		goto fail_local;
 
 	dlm_allow_conn = 1;
 
@@ -1768,6 +1774,9 @@ int dlm_lowcomms_start(void)
 fail_unlisten:
 	dlm_allow_conn = 0;
 	dlm_close_sock(&listen_con.sock);
+	work_stop();
+fail_local:
+	deinit_local();
 fail:
 	return error;
 }
-- 
2.30.2

