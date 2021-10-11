Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13B74290A0
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242815AbhJKOKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:10:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242024AbhJKOIn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:08:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A39361078;
        Mon, 11 Oct 2021 14:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960892;
        bh=lHlgL+PtI8loLZASCAO+rwqLV6OQApavNdR03jGGako=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H3AZcj+IZWNgAyy4Aewh/PtVSwyKwGv37OWI/CRH1ilNRw7jH/Mf81YUfl3iByuPy
         TU0OukkU0BGkyr51LdIw1SzUVna+yFvPFwGaAb7QKBj8ByPYXsPqu2busOWr6Qypt4
         TxF4oipkOWT51TZDQ6OVPUqW3t6epqNRCQfO7u5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Karol Herbst <kherbst@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 104/151] drm/nouveau/kms/nv50-: fix file release memory leak
Date:   Mon, 11 Oct 2021 15:46:16 +0200
Message-Id: <20211011134521.180781009@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 0b3d4945cc7e7ea1acd52cb06dfa83bfe265b6d5 ]

When using single_open() for opening, single_release() should be
called, otherwise the 'op' allocated in single_open() will be leaked.

Fixes: 12885ecbfe62 ("drm/nouveau/kms/nvd9-: Add CRC support")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210911075023.3969054-1-yangyingliang@huawei.com
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/dispnv50/crc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/dispnv50/crc.c b/drivers/gpu/drm/nouveau/dispnv50/crc.c
index b8c31b697797..66f32d965c72 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/crc.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/crc.c
@@ -704,6 +704,7 @@ static const struct file_operations nv50_crc_flip_threshold_fops = {
 	.open = nv50_crc_debugfs_flip_threshold_open,
 	.read = seq_read,
 	.write = nv50_crc_debugfs_flip_threshold_set,
+	.release = single_release,
 };
 
 int nv50_head_crc_late_register(struct nv50_head *head)
-- 
2.33.0



