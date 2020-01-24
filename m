Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41B38148125
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390503AbgAXLRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:17:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:54300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389371AbgAXLRY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:17:24 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED7CE2077C;
        Fri, 24 Jan 2020 11:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864643;
        bh=qMgmZmTKJmO4o9WJ/g49PM9tsdb/KLpW2AynvmrEon8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Znflpya4zGlbPB/NU+Q92Kc+qjlGKfyr7DKh0HXCdvaSPaQEJ3yLdhoxCKc+S5YN6
         w9G5oz9WbF+yH4okPfutzERB+fA5350a2921jdoKaGzdsMOIbppBDiNoi+UAxiu7l+
         S2QcaTt+2AccTajKPk7oOrlBmmimHRQQc8tx+zR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 311/639] staging: android: vsoc: fix copy_from_user overrun
Date:   Fri, 24 Jan 2020 10:28:01 +0100
Message-Id: <20200124093125.893621590@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Stehlé <vincent.stehle@laposte.net>

[ Upstream commit 060ea4271a82270be6d44e8e9aefe8f155fb5626 ]

The `np->permission' structure is smaller than the `np' structure but
sizeof(*np) worth of data is copied in there. Fix the size passed to
copy_from_user() to avoid overrun.

Fixes: 3d2ec9dcd553 ("staging: Android: Add 'vsoc' driver for cuttlefish.")
Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/android/vsoc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/vsoc.c b/drivers/staging/android/vsoc.c
index 22571abcaa4e8..034d86869772e 100644
--- a/drivers/staging/android/vsoc.c
+++ b/drivers/staging/android/vsoc.c
@@ -260,7 +260,8 @@ do_create_fd_scoped_permission(struct vsoc_device_region *region_p,
 	atomic_t *owner_ptr = NULL;
 	struct vsoc_device_region *managed_region_p;
 
-	if (copy_from_user(&np->permission, &arg->perm, sizeof(*np)) ||
+	if (copy_from_user(&np->permission,
+			   &arg->perm, sizeof(np->permission)) ||
 	    copy_from_user(&managed_fd,
 			   &arg->managed_region_fd, sizeof(managed_fd))) {
 		return -EFAULT;
-- 
2.20.1



