Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70577206247
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403896AbgFWU6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:58:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392370AbgFWUlz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:41:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15E3B2053B;
        Tue, 23 Jun 2020 20:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944915;
        bh=mN4gSfA1BZ9tDTLJPfcnd7yd2OXQBhvuB2726QAx6WQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v4SbMgc4Way0GPvUdSyj2+LVTGS0lgZP5feWqPUur6MIv0XbHbp3qVQMgmlXzlLWV
         ey4jlRtL09ZD50wivNzBJ2bB+fMTU+iTRI39NhD8/nSIhtW3yIxG5j4F/+aeKkJqw8
         M7brIrE74CFwdfWLAbmedPFfYXjqnKYT5P8ydMKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huacai Chen <chenhc@lemote.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 4.19 175/206] drm/qxl: Use correct notify port address when creating cursor ring
Date:   Tue, 23 Jun 2020 21:58:23 +0200
Message-Id: <20200623195325.637864990@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/gpu/drm/qxl/qxl_kms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/qxl/qxl_kms.c
+++ b/drivers/gpu/drm/qxl/qxl_kms.c
@@ -181,7 +181,7 @@ int qxl_device_init(struct qxl_device *q
 				&(qdev->ram_header->cursor_ring_hdr),
 				sizeof(struct qxl_command),
 				QXL_CURSOR_RING_SIZE,
-				qdev->io_base + QXL_IO_NOTIFY_CMD,
+				qdev->io_base + QXL_IO_NOTIFY_CURSOR,
 				false,
 				&qdev->cursor_event);
 


