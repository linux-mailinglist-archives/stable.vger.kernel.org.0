Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76D0C66CE2
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbfGLMYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:24:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728039AbfGLMYJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:24:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A632B2084B;
        Fri, 12 Jul 2019 12:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934249;
        bh=RYgNIcgVq4MvcSezTMgFH6yH/BO/iiWP7tZ6Y9Kxu5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u9RwUGNSBHgYu7MG6pZZ2FoUiP9bqd8zS94OFamcj8lh3D0bzPTeVbiAVpMq/tbcL
         i9qi5pz87BbFsOeWFP58AowlwdqrlDNuOiupUybBvalm/z3JEoDE8W+4mBQ2j1/6d0
         OYwbJVqnMAkQMwU4BvhQ2VR3V9dk64yEn/EztOnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Sean Paul <seanpaul@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 48/91] drm: return -EFAULT if copy_to_user() fails
Date:   Fri, 12 Jul 2019 14:18:51 +0200
Message-Id: <20190712121624.199415799@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
References: <20190712121621.422224300@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 74b67efa8d7b4f90137f0ab9a80dd319da050350 ]

The copy_from_user() function returns the number of bytes remaining
to be copied but we want to return a negative error code.  Otherwise
the callers treat it as a successful copy.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Sean Paul <seanpaul@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190618131843.GA29463@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_bufs.c  | 5 ++++-
 drivers/gpu/drm/drm_ioc32.c | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_bufs.c b/drivers/gpu/drm/drm_bufs.c
index e2f775d1c112..21bec4548092 100644
--- a/drivers/gpu/drm/drm_bufs.c
+++ b/drivers/gpu/drm/drm_bufs.c
@@ -1321,7 +1321,10 @@ static int copy_one_buf(void *data, int count, struct drm_buf_entry *from)
 				 .size = from->buf_size,
 				 .low_mark = from->low_mark,
 				 .high_mark = from->high_mark};
-	return copy_to_user(to, &v, offsetof(struct drm_buf_desc, flags));
+
+	if (copy_to_user(to, &v, offsetof(struct drm_buf_desc, flags)))
+		return -EFAULT;
+	return 0;
 }
 
 int drm_legacy_infobufs(struct drm_device *dev, void *data,
diff --git a/drivers/gpu/drm/drm_ioc32.c b/drivers/gpu/drm/drm_ioc32.c
index 67b1fca39aa6..138680b37c70 100644
--- a/drivers/gpu/drm/drm_ioc32.c
+++ b/drivers/gpu/drm/drm_ioc32.c
@@ -372,7 +372,10 @@ static int copy_one_buf32(void *data, int count, struct drm_buf_entry *from)
 			      .size = from->buf_size,
 			      .low_mark = from->low_mark,
 			      .high_mark = from->high_mark};
-	return copy_to_user(to + count, &v, offsetof(drm_buf_desc32_t, flags));
+
+	if (copy_to_user(to + count, &v, offsetof(drm_buf_desc32_t, flags)))
+		return -EFAULT;
+	return 0;
 }
 
 static int drm_legacy_infobufs32(struct drm_device *dev, void *data,
-- 
2.20.1



