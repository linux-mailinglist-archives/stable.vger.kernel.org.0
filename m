Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499383C4CD0
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240971AbhGLHIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:08:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242403AbhGLHGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:06:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24B49610E6;
        Mon, 12 Jul 2021 07:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073435;
        bh=YXHak61v1O7A050cPtVIAPc15LkwuBJvwNxrg1ZOtAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sQ35hwl+wNNUf6hCRkkQDrLOlyR+vIC01LWDAQq0pUYcgM68CO2JahIo35wWz2UAV
         aNNOhTjgN8OWLX3KhiPZRSE2lbPKdJ3cwF02zXSYM34XiN7YkvU0tcm15RQt+viRS+
         3sPtlnMWFnmLFXSijkHLQZAvIeA3nqpX0wNqS13Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 214/700] fs: dlm: fix lowcomms_start error case
Date:   Mon, 12 Jul 2021 08:04:57 +0200
Message-Id: <20210712060957.123521997@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



