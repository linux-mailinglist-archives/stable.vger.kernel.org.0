Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2ED3246C53
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 18:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388778AbgHQQOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 12:14:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388756AbgHQQNk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:13:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 189A820578;
        Mon, 17 Aug 2020 16:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680818;
        bh=yzqgOeGUuulbsB4LN8mlMYgkUV39h4cYOiRjSlgDeqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kdRneImz2oTXvMJHlvMfKpp66MAuYI/dqd0ec4+tqlM5uzvT8lBMROpIQyuaVcniM
         i0XierI7FelDEvq9fzeDfShWwcKm8hlP/UAhfjY3PhWXb7wTN9uNmzhbn+RWTXGrFx
         6mXdqdB20BKPfrW0tS7ZxWJLxSaeE/l2M6QCQWiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Tretter <m.tretter@pengutronix.de>,
        Jani Nikula <jani.nikula@intel.com>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 039/168] drm/debugfs: fix plain echo to connector "force" attribute
Date:   Mon, 17 Aug 2020 17:16:10 +0200
Message-Id: <20200817143735.731694115@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Tretter <m.tretter@pengutronix.de>

[ Upstream commit c704b17071c4dc571dca3af4e4151dac51de081a ]

Using plain echo to set the "force" connector attribute fails with
-EINVAL, because echo appends a newline to the output.

Replace strcmp with sysfs_streq to also accept strings that end with a
newline.

v2: use sysfs_streq instead of stripping trailing whitespace

Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Emil Velikov <emil.l.velikov@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20170817104307.17124-1-m.tretter@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_debugfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_debugfs.c b/drivers/gpu/drm/drm_debugfs.c
index 373bd4c2b698b..84b7b22a9590a 100644
--- a/drivers/gpu/drm/drm_debugfs.c
+++ b/drivers/gpu/drm/drm_debugfs.c
@@ -265,13 +265,13 @@ static ssize_t connector_write(struct file *file, const char __user *ubuf,
 
 	buf[len] = '\0';
 
-	if (!strcmp(buf, "on"))
+	if (sysfs_streq(buf, "on"))
 		connector->force = DRM_FORCE_ON;
-	else if (!strcmp(buf, "digital"))
+	else if (sysfs_streq(buf, "digital"))
 		connector->force = DRM_FORCE_ON_DIGITAL;
-	else if (!strcmp(buf, "off"))
+	else if (sysfs_streq(buf, "off"))
 		connector->force = DRM_FORCE_OFF;
-	else if (!strcmp(buf, "unspecified"))
+	else if (sysfs_streq(buf, "unspecified"))
 		connector->force = DRM_FORCE_UNSPECIFIED;
 	else
 		return -EINVAL;
-- 
2.25.1



