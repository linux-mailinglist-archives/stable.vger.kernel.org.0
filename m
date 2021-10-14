Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B2042DC9E
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 16:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhJNPA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Oct 2021 11:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232664AbhJNO7U (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Oct 2021 10:59:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53266610D1;
        Thu, 14 Oct 2021 14:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634223435;
        bh=ypwFQT/ttAArZs0XkrtyKy2gElvMXG7xS2Yrt+rUiZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KutgaF83xXb6y2VwQlYOuOlErTiLc7ZfIfxnWB7FsqXSF12YTeMjxktKDTts9+wRL
         UGVz/rpdPkjnNbIF4G5IQQCkQksFHjrHxyvK2wjKcYextI4vVs55bgMFE+0Zucs7eX
         3lKuslZI+TxOiuau1ctudZPHXL3QQdCDi4DzYoT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Karol Herbst <kherbst@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 20/33] drm/nouveau/debugfs: fix file release memory leak
Date:   Thu, 14 Oct 2021 16:53:52 +0200
Message-Id: <20211014145209.471298815@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211014145208.775270267@linuxfoundation.org>
References: <20211014145208.775270267@linuxfoundation.org>
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
index 4561a786fab0..cce4833a6083 100644
--- a/drivers/gpu/drm/nouveau/nouveau_debugfs.c
+++ b/drivers/gpu/drm/nouveau/nouveau_debugfs.c
@@ -185,6 +185,7 @@ static const struct file_operations nouveau_pstate_fops = {
 	.open = nouveau_debugfs_pstate_open,
 	.read = seq_read,
 	.write = nouveau_debugfs_pstate_set,
+	.release = single_release,
 };
 
 static struct drm_info_list nouveau_debugfs_list[] = {
-- 
2.33.0



