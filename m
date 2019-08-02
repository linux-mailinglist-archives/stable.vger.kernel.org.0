Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C60B97F265
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405780AbfHBJsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:48:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405129AbfHBJsF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:48:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A1DA2086A;
        Fri,  2 Aug 2019 09:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739284;
        bh=qpSjsDF93Ma1fWAzJhnv1/Q2oQmfhLU3c2dWjD1rujo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z37sdNpfokrmzlmiRJHArM0oWqueBmpFafh+lzhy6low6Jf/m+LL0S/73rYmmG8t2
         /WXfrlVlSRaOngyK7A4s+KOkVqD3PLh5VCE9ykRHWt/KtsSMens1y88qRzGMWygtfE
         HYzif8aCXGOoGuYnzmHArn6IrcC6HsSpW+01eVFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 174/223] usb: gadget: Zero ffs_io_data
Date:   Fri,  2 Aug 2019 11:36:39 +0200
Message-Id: <20190802092249.120949036@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



