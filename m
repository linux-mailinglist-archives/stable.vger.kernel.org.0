Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEE0328D9D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240927AbhCATOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:14:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:39034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234818AbhCATJf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:09:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE3F06519A;
        Mon,  1 Mar 2021 17:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618731;
        bh=PKy+BTdVpY5bdXj1vnnfybhkRjj+pobNfcSHDw8vm/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oh35Bf7vDrP6QGO6z0hJqjfGTniVoZPy8eFjdi8vcF9JkFQ3ViTZO/Klbp+Wxx5Pn
         uh+Miht8/uJ4bOWtNOYAx2a4xUZ9DIyOJzfUOnutseWcQmWUpNXdQOI0AnDdhIS7ED
         2XKij0NgKssoPQM81UDbqLN/kXm5Ln0a0lDHs7oY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 166/663] media: em28xx: Fix use-after-free in em28xx_alloc_urbs
Date:   Mon,  1 Mar 2021 17:06:54 +0100
Message-Id: <20210301161149.993996715@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit a26efd1961a18b91ae4cd2e433adbcf865b40fa3 ]

When kzalloc() fails, em28xx_uninit_usb_xfer() will free
usb_bufs->buf and set it to NULL. Thus the later access
to usb_bufs->buf[i] will lead to null pointer dereference.
Also the kfree(usb_bufs->buf) after that is redundant.

Fixes: d571b592c6206 ("media: em28xx: don't use coherent buffer for DMA transfers")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-core.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index e6088b5d1b805..3daa64bb1e1d9 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -956,14 +956,10 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 
 		usb_bufs->buf[i] = kzalloc(sb_size, GFP_KERNEL);
 		if (!usb_bufs->buf[i]) {
-			em28xx_uninit_usb_xfer(dev, mode);
-
 			for (i--; i >= 0; i--)
 				kfree(usb_bufs->buf[i]);
 
-			kfree(usb_bufs->buf);
-			usb_bufs->buf = NULL;
-
+			em28xx_uninit_usb_xfer(dev, mode);
 			return -ENOMEM;
 		}
 
-- 
2.27.0



