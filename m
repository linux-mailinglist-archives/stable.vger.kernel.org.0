Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4756DCDF
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388553AbfGSESr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:18:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389264AbfGSENc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:13:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57C822082F;
        Fri, 19 Jul 2019 04:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509612;
        bh=iSw7sUSYt7Lb6X+rkSUm5CuvD5FJgG9fhc7IvQtDvSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lR1L1o8aVHk56liVrCFfmF+w1OBugTYa8i0TMkY/DEULH7fKsaj3YjtoX3k/3yZ9k
         BWAwhALNEOAczgfrQ1jxiLYGNoyI2LDAOdHlRGdbVLovW3WtfU9WjTsKU4kwCVOIoO
         +0hXPqcMHL8/WAW7QqQzXKE93fu49PUw2qAeldR8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 17/45] usb: gadget: Zero ffs_io_data
Date:   Fri, 19 Jul 2019 00:12:36 -0400
Message-Id: <20190719041304.18849-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719041304.18849-1-sashal@kernel.org>
References: <20190719041304.18849-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrzej Pietrasiewicz <andrzej.p@collabora.com>

[ Upstream commit 508595515f4bcfe36246e4a565cf280937aeaade ]

In some cases the "Allocate & copy" block in ffs_epfile_io() is not
executed. Consequently, in such a case ffs_alloc_buffer() is never called
and struct ffs_io_data is not initialized properly. This in turn leads to
problems when ffs_free_buffer() is called at the end of ffs_epfile_io().

This patch uses kzalloc() instead of kmalloc() in the aio case and memset()
in non-aio case to properly initialize struct ffs_io_data.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 927ac0ee09b7..d1278d2d544b 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1101,11 +1101,12 @@ static ssize_t ffs_epfile_write_iter(struct kiocb *kiocb, struct iov_iter *from)
 	ENTER();
 
 	if (!is_sync_kiocb(kiocb)) {
-		p = kmalloc(sizeof(io_data), GFP_KERNEL);
+		p = kzalloc(sizeof(io_data), GFP_KERNEL);
 		if (unlikely(!p))
 			return -ENOMEM;
 		p->aio = true;
 	} else {
+		memset(p, 0, sizeof(*p));
 		p->aio = false;
 	}
 
@@ -1137,11 +1138,12 @@ static ssize_t ffs_epfile_read_iter(struct kiocb *kiocb, struct iov_iter *to)
 	ENTER();
 
 	if (!is_sync_kiocb(kiocb)) {
-		p = kmalloc(sizeof(io_data), GFP_KERNEL);
+		p = kzalloc(sizeof(io_data), GFP_KERNEL);
 		if (unlikely(!p))
 			return -ENOMEM;
 		p->aio = true;
 	} else {
+		memset(p, 0, sizeof(*p));
 		p->aio = false;
 	}
 
-- 
2.20.1

