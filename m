Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC5CA6FCC
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730962AbfICQ1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:27:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730957AbfICQ1u (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 701D3238C6;
        Tue,  3 Sep 2019 16:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528069;
        bh=krAUKclN5zuG1oCarZQF52J+e248ke7MQqKEOMq6egk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uS7PmZ9YH8yfjYHHeRe+aV4VqFPg6QQxiyde4g/BbA6OQdZ9DvvN6RYooZUsa54DW
         9C9r6o+dPk5AKQPQWkNmv3WKIaW5KZ/WD1Df8DOBX6FVSOvhi3TMDbkOB6XsH++ve3
         LFFk7xJAbmp92sqmE2sATw+plEpSWPJdO5z+tVO8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Dooks <ben.dooks@codethink.co.uk>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 083/167] drm: add __user attribute to ptr_to_compat()
Date:   Tue,  3 Sep 2019 12:23:55 -0400
Message-Id: <20190903162519.7136-83-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit e552f0851070fe4975d610a99910be4e9bf5d7bd ]

The ptr_to_compat() call takes a "void __user *", so cast
the compat drm calls that use it to avoid the following
warnings from sparse:

drivers/gpu/drm/drm_ioc32.c:188:39: warning: incorrect type in argument 1 (different address spaces)
drivers/gpu/drm/drm_ioc32.c:188:39:    expected void [noderef] <asn:1>*uptr
drivers/gpu/drm/drm_ioc32.c:188:39:    got void *[addressable] [assigned] handle
drivers/gpu/drm/drm_ioc32.c:529:41: warning: incorrect type in argument 1 (different address spaces)
drivers/gpu/drm/drm_ioc32.c:529:41:    expected void [noderef] <asn:1>*uptr
drivers/gpu/drm/drm_ioc32.c:529:41:    got void *[addressable] [assigned] handle

Cc: stable@vger.kernel.org
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190301120046.26961-1-ben.dooks@codethink.co.uk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_ioc32.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_ioc32.c b/drivers/gpu/drm/drm_ioc32.c
index 138680b37c709..f8672238d444b 100644
--- a/drivers/gpu/drm/drm_ioc32.c
+++ b/drivers/gpu/drm/drm_ioc32.c
@@ -185,7 +185,7 @@ static int compat_drm_getmap(struct file *file, unsigned int cmd,
 	m32.size = map.size;
 	m32.type = map.type;
 	m32.flags = map.flags;
-	m32.handle = ptr_to_compat(map.handle);
+	m32.handle = ptr_to_compat((void __user *)map.handle);
 	m32.mtrr = map.mtrr;
 	if (copy_to_user(argp, &m32, sizeof(m32)))
 		return -EFAULT;
@@ -216,7 +216,7 @@ static int compat_drm_addmap(struct file *file, unsigned int cmd,
 
 	m32.offset = map.offset;
 	m32.mtrr = map.mtrr;
-	m32.handle = ptr_to_compat(map.handle);
+	m32.handle = ptr_to_compat((void __user *)map.handle);
 	if (map.handle != compat_ptr(m32.handle))
 		pr_err_ratelimited("compat_drm_addmap truncated handle %p for type %d offset %x\n",
 				   map.handle, m32.type, m32.offset);
@@ -529,7 +529,7 @@ static int compat_drm_getsareactx(struct file *file, unsigned int cmd,
 	if (err)
 		return err;
 
-	req32.handle = ptr_to_compat(req.handle);
+	req32.handle = ptr_to_compat((void __user *)req.handle);
 	if (copy_to_user(argp, &req32, sizeof(req32)))
 		return -EFAULT;
 
-- 
2.20.1

