Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055C0428ED2
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237398AbhJKNwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:52:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:39696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237397AbhJKNvU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:51:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30D0160F4B;
        Mon, 11 Oct 2021 13:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960160;
        bh=XC8DOm1IYkfkc3oE4uLp0C4QhgpOBS3pS7pMg3zef1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yV2g+Z4RqbjHIKsmmBLtF6eexb0esEoQShraYKMziaO5GbbkHevcyzm1ZO17GJJTz
         KFYu5TeZY/n6RN7ZQAiti0Yhy8ei65dwRJkx8V9+uakYIzoY4+Jb0a9LdVt6dH14M7
         Rx5S2kIkp9EjOtjS+iYfPMR+s7HgJ47sM3t0SaNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Karol Herbst <kherbst@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 39/52] drm/nouveau/debugfs: fix file release memory leak
Date:   Mon, 11 Oct 2021 15:46:08 +0200
Message-Id: <20211011134505.071089694@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134503.715740503@linuxfoundation.org>
References: <20211011134503.715740503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit f5a8703a9c418c6fc54eb772712dfe7641e3991c ]

When using single_open() for opening, single_release() should be
called, otherwise the 'op' allocated in single_open() will be leaked.

Fixes: 6e9fc177399f ("drm/nouveau/debugfs: add copy of sysfs pstate interface ported to debugfs")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210911075023.3969054-2-yangyingliang@huawei.com
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_debugfs.c b/drivers/gpu/drm/nouveau/nouveau_debugfs.c
index 3b13feca970f..3c54d61e4fa9 100644
--- a/drivers/gpu/drm/nouveau/nouveau_debugfs.c
+++ b/drivers/gpu/drm/nouveau/nouveau_debugfs.c
@@ -207,6 +207,7 @@ static const struct file_operations nouveau_pstate_fops = {
 	.open = nouveau_debugfs_pstate_open,
 	.read = seq_read,
 	.write = nouveau_debugfs_pstate_set,
+	.release = single_release,
 };
 
 static struct drm_info_list nouveau_debugfs_list[] = {
-- 
2.33.0



