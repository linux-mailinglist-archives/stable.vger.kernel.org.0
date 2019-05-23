Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7016028A1B
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732115AbfEWTJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:09:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731604AbfEWTJS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:09:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F187721851;
        Thu, 23 May 2019 19:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638557;
        bh=vrLRgix2Gpnic3HQAbtiht8hnM0L5AnoI/kek7a8G74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUEZzc+iae5lIbBK1A2P+CHQyVmTg0U6lLtthvmwnw4OeBBYLk3gtViz5Rj72Orl4
         3o4s2IG5AIdGD/m23b+fI4q5Hg/d1k5rwK2JGoRnV88aEoWzB844LAA/UnO5CA/gJ7
         SYk+IcfwUUKwHn0KfxeshiQDsbxqCBLtNIPOJOlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yifeng Li <tomli@tomli.me>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Teddy Wang <teddy.wang@siliconmotion.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 4.9 33/53] fbdev: sm712fb: fix boot screen glitch when sm712fb replaces VGA
Date:   Thu, 23 May 2019 21:05:57 +0200
Message-Id: <20190523181716.096652285@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181710.981455400@linuxfoundation.org>
References: <20190523181710.981455400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifeng Li <tomli@tomli.me>

commit ec1587d5073f29820e358f3a383850d61601d981 upstream.

When the machine is booted in VGA mode, loading sm712fb would cause
a glitch of random pixels shown on the screen. To prevent it from
happening, we first clear the entire framebuffer, and we also need
to stop calling smtcfb_setmode() during initialization, the fbdev
layer will call it for us later when it's ready.

Signed-off-by: Yifeng Li <tomli@tomli.me>
Tested-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Teddy Wang <teddy.wang@siliconmotion.com>
Cc: <stable@vger.kernel.org>  # v4.4+
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/sm712fb.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/sm712fb.c
+++ b/drivers/video/fbdev/sm712fb.c
@@ -1492,7 +1492,11 @@ static int smtcfb_pci_probe(struct pci_d
 	if (err)
 		goto failed;
 
-	smtcfb_setmode(sfb);
+	/*
+	 * The screen would be temporarily garbled when sm712fb takes over
+	 * vesafb or VGA text mode. Zero the framebuffer.
+	 */
+	memset_io(sfb->lfb, 0, sfb->fb->fix.smem_len);
 
 	err = register_framebuffer(info);
 	if (err < 0)


