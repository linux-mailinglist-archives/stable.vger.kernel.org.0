Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77B33BBF18
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbhGEPb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:31:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232023AbhGEPbW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:31:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 803046197F;
        Mon,  5 Jul 2021 15:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498925;
        bh=8elQxYq1HPPZFOtDMNr1juoBYQjgziwAnZkffRxeYxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K8jUBWnlTrk15kcvVgpU6IT6bNRKTAcc2nlM1LSQ1btauGXnpFS6vVleXweiO8DbO
         H//hGWsWJ+4rLDx9BTZSjTt97gcQr+xJCPHQF8F1RESNBk6gphFZ5bPK3Ek9urnmU6
         hoG3uu+eAKIuNKucThLTeYwVIHCKWfKe50yvLPmnN5hTNke4FtyHLRFkSKsG+uPdzm
         h0EBL5dmV/F9WrOBWJ01sMeX3rG49tmlTefxwZqdFdJuHEd9wi/UKSuPm39mTv9GgC
         UhGEjfU0seI06J5ku6MGq1gkhMLKjMUwgl2+Fkb+gFVdOIybszk24FXtrGCFDbJRf9
         s+DpnyL8By5Kw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.13 22/59] fs: dlm: fix lowcomms_start error case
Date:   Mon,  5 Jul 2021 11:27:38 -0400
Message-Id: <20210705152815.1520546-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705152815.1520546-1-sashal@kernel.org>
References: <20210705152815.1520546-1-sashal@kernel.org>
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
index b1dd850a4699..9bf920bee292 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1666,10 +1666,15 @@ static void process_send_sockets(struct work_struct *work)
 
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
@@ -1686,6 +1691,7 @@ static int work_start(void)
 	if (!send_workqueue) {
 		log_print("can't start dlm_send");
 		destroy_workqueue(recv_workqueue);
+		recv_workqueue = NULL;
 		return -ENOMEM;
 	}
 
@@ -1823,7 +1829,7 @@ int dlm_lowcomms_start(void)
 
 	error = work_start();
 	if (error)
-		goto fail;
+		goto fail_local;
 
 	dlm_allow_conn = 1;
 
@@ -1840,6 +1846,9 @@ int dlm_lowcomms_start(void)
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

