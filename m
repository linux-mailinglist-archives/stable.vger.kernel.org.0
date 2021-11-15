Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C81E450EA7
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239694AbhKOSQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:16:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:50066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240636AbhKOSLd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:11:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2EF6633C0;
        Mon, 15 Nov 2021 17:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998443;
        bh=WNfqfHL+XDuPIiFCSXiN5p1SQMFshojtqrcyDtt4W3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KaPibCM9ypVaIY1uMetN8P2fV1VvTfxZ5wbhBp5kMg2rcn5L0dpULQn/HT1FuY3dp
         5JlZA55FTHO4Ax0+BFoGcPKW7lRsKur+tNN/Fx5H6onx8/C4kGhvf3RjykDZ1kJxkg
         3jZNW2c0bMsCLFsVYJ8YRQ4AX9yFbIBK39ABQjTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chenyuan Mi <cymi20@fudan.edu.cn>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>, Lyude Paul <lyude@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 512/575] drm/nouveau/svm: Fix refcount leak bug and missing check against null bug
Date:   Mon, 15 Nov 2021 18:03:57 +0100
Message-Id: <20211115165401.391650995@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chenyuan Mi <cymi20@fudan.edu.cn>

[ Upstream commit 6bb8c2d51811eb5e6504f49efe3b089d026009d2 ]

The reference counting issue happens in one exception handling path of
nouveau_svmm_bind(). When cli->svm.svmm is null, the function forgets
to decrease the refcount of mm increased by get_task_mm(), causing a
refcount leak.

Fix this issue by using mmput() to decrease the refcount in the
exception handling path.

Also, the function forgets to do check against null when get mm
by get_task_mm().

Fix this issue by adding null check after get mm by get_task_mm().

Signed-off-by: Chenyuan Mi <cymi20@fudan.edu.cn>
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Fixes: 822cab6150d3 ("drm/nouveau/svm: check for SVM initialized before migrating")
Reviewed-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Ben Skeggs <bskeggs@redhat.com>
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210907122633.16665-1-cymi20@fudan.edu.cn
Link: https://gitlab.freedesktop.org/drm/nouveau/-/merge_requests/14
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_svm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouveau/nouveau_svm.c
index 1c3f890377d2c..f67700c028c75 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -156,10 +156,14 @@ nouveau_svmm_bind(struct drm_device *dev, void *data,
 	 */
 
 	mm = get_task_mm(current);
+	if (!mm) {
+		return -EINVAL;
+	}
 	mmap_read_lock(mm);
 
 	if (!cli->svm.svmm) {
 		mmap_read_unlock(mm);
+		mmput(mm);
 		return -EINVAL;
 	}
 
-- 
2.33.0



