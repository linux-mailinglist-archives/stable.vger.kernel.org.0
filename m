Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B748E240D9B
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbgHJTJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:09:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728600AbgHJTJj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:09:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DE2D2224D;
        Mon, 10 Aug 2020 19:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086579;
        bh=CaGu3jCShAi6zK9n0jAB+MVmHli5uXnzyL5xTif5KX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kRPK5HfMhmgjyJPuHWZq4XjNYUfRjZwaZZrS1ElDpv73KRpjULYZvP4UAj3cJDXuQ
         Z8PeULWe5LQSLuKq0F8LlhzAMKD1ypbmYn0t+UzdmhW0eMJk8c4Q+Fu19N7uPtDyBZ
         HzZEJfZMpMNC8VzBLG1QlhassuUQHf7Y5PkmDYcs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Tretter <m.tretter@pengutronix.de>,
        Jani Nikula <jani.nikula@intel.com>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 29/64] drm/debugfs: fix plain echo to connector "force" attribute
Date:   Mon, 10 Aug 2020 15:08:24 -0400
Message-Id: <20200810190859.3793319-29-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810190859.3793319-1-sashal@kernel.org>
References: <20200810190859.3793319-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 2bea221307037..bfe4602f206b4 100644
--- a/drivers/gpu/drm/drm_debugfs.c
+++ b/drivers/gpu/drm/drm_debugfs.c
@@ -311,13 +311,13 @@ static ssize_t connector_write(struct file *file, const char __user *ubuf,
 
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

