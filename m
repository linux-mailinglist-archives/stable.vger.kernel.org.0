Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2C9013F60F
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388888AbgAPTBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:01:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:35566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388625AbgAPRF7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:05:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 165B2205F4;
        Thu, 16 Jan 2020 17:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194359;
        bh=O658uSSxWwmoGFnHthtFfmzLKgcANu2grOllItCu8B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=isjkQwNNzSo5oMcVOIK0IC6wIcKBDlZzlTzyYoqKBBy8ZlUdvj2ZboDKyI46OfT2w
         PlPbthE1pIElBsEhrUz8xSJU1hQ3WvkT7us+3TqcudV8zmfEaemYaNz1ERqbujG4S1
         KmN0wvRTA/vQg0+4fHa9KeYxd2W4vpBeH7UIAZZA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.19 296/671] staging: android: vsoc: fix copy_from_user overrun
Date:   Thu, 16 Jan 2020 11:58:54 -0500
Message-Id: <20200116170509.12787-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index 22571abcaa4e..034d86869772 100644
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

