Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F87020E310
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390370AbgF2VLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:11:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730304AbgF2TAP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:00:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 962C625500;
        Mon, 29 Jun 2020 15:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446064;
        bh=N1s8XlJlVL3RmDycmudIzlEB6NDK7Cq5DmwaM/Jn0bA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pK+eIeLIfAFTDrTWg9LfJ5pQLdwRc62jn7sOIdsHbbRlm+JP9CM82ahkRVhor7NF/
         uh26qo554rGenbLfqTq3vN+yaO5gTJvlt7FijvEYEmCpJgUpGnBlvae7CjX7wOi9/b
         KrwtWHeN5LrJy+hOjTZVch+riXlRTIR7QmqekFpc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huacai Chen <chenhc@lemote.com>, Gerd Hoffmann <kraxel@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 063/135] drm/qxl: Use correct notify port address when creating cursor ring
Date:   Mon, 29 Jun 2020 11:51:57 -0400
Message-Id: <20200629155309.2495516-64-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhc@lemote.com>

commit 80e5f89da3ab949fbbf1cae01dfaea29f5483a75 upstream.

The command ring and cursor ring use different notify port addresses
definition: QXL_IO_NOTIFY_CMD and QXL_IO_NOTIFY_CURSOR. However, in
qxl_device_init() we use QXL_IO_NOTIFY_CMD to create both command ring
and cursor ring. This doesn't cause any problems now, because QEMU's
behaviors on QXL_IO_NOTIFY_CMD and QXL_IO_NOTIFY_CURSOR are the same.
However, QEMU's behavior may be change in future, so let's fix it.

P.S.: In the X.org QXL driver, the notify port address of cursor ring
      is correct.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Cc: <stable@vger.kernel.org>
Link: http://patchwork.freedesktop.org/patch/msgid/1585635488-17507-1-git-send-email-chenhc@lemote.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/qxl/qxl_kms.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/qxl/qxl_kms.c b/drivers/gpu/drm/qxl/qxl_kms.c
index b2977a1819358..e8664a9f1e770 100644
--- a/drivers/gpu/drm/qxl/qxl_kms.c
+++ b/drivers/gpu/drm/qxl/qxl_kms.c
@@ -199,7 +199,7 @@ static int qxl_device_init(struct qxl_device *qdev,
 				&(qdev->ram_header->cursor_ring_hdr),
 				sizeof(struct qxl_command),
 				QXL_CURSOR_RING_SIZE,
-				qdev->io_base + QXL_IO_NOTIFY_CMD,
+				qdev->io_base + QXL_IO_NOTIFY_CURSOR,
 				false,
 				&qdev->cursor_event);
 
-- 
2.25.1

