Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0880332881E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238380AbhCARdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:33:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:49370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238421AbhCAR1B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:27:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59D766508D;
        Mon,  1 Mar 2021 16:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617471;
        bh=PKy+BTdVpY5bdXj1vnnfybhkRjj+pobNfcSHDw8vm/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PLlD4xB1PT62lPpVROcW+CccvvxMLodQD86PWoOA9UPFJ3Hrl2hC8LKdzpU8SsAz6
         nr49MCHqs91CTpMRbOL0fLNACZ9VoBEeqWqmEZxldeyyZCPx8SSoMb9WVZYqqB7lBl
         9qFOkDQF/TwVrNXjSEkiMuXSmNmVeZITktUmn3s8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 085/340] media: em28xx: Fix use-after-free in em28xx_alloc_urbs
Date:   Mon,  1 Mar 2021 17:10:29 +0100
Message-Id: <20210301161052.509353711@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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



