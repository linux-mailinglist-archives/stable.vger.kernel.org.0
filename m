Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1A43A9D1
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733280AbfFIQ57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:57:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:32954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733277AbfFIQ56 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:57:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95AC520840;
        Sun,  9 Jun 2019 16:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099478;
        bh=SurAlSJuIgXS5zvEQC7YB5+ieM+xlVu36sEG7hdHYBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BDofnE4y0/Uz2KnPiDPejZUkN6XQf74ejHYVFDMvfdcFNwOkgnNjmxlutTLZ/LkZT
         9IIHKUr07iQJrIqDC1nFkBTIQnEBM2VoJjXFaMPR7HxUa6/CxmKwZw6ls6+C83+C68
         lUTqHz0ebU/3Dm3o7+9Zr1HycF6e3BbLqyEwwUj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yifeng Li <tomli@tomli.me>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Teddy Wang <teddy.wang@siliconmotion.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 4.4 055/241] fbdev: sm712fb: fix VRAM detection, dont set SR70/71/74/75
Date:   Sun,  9 Jun 2019 18:39:57 +0200
Message-Id: <20190609164149.361947105@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifeng Li <tomli@tomli.me>

commit dcf9070595e100942c539e229dde4770aaeaa4e9 upstream.

On a Thinkpad s30 (Pentium III / i440MX, Lynx3DM), the amount of Video
RAM is not detected correctly by the xf86-video-siliconmotion driver.
This is because sm712fb overwrites the GPR71 Scratch Pad Register, which
is set by BIOS on x86 and used to indicate amount of VRAM.

Other Scratch Pad Registers, including GPR70/74/75, don't have the same
side-effect, but overwriting to them is still questionable, as they are
not related to modesetting.

Stop writing to SR70/71/74/75 (a.k.a GPR70/71/74/75).

Signed-off-by: Yifeng Li <tomli@tomli.me>
Tested-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Teddy Wang <teddy.wang@siliconmotion.com>
Cc: <stable@vger.kernel.org>  # v4.4+
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/sm712fb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/sm712fb.c
+++ b/drivers/video/fbdev/sm712fb.c
@@ -1145,7 +1145,9 @@ static void sm7xx_set_timing(struct smtc
 		/* init SEQ register SR30 - SR75 */
 		for (i = 0; i < SIZE_SR30_SR75; i++)
 			if ((i + 0x30) != 0x30 && (i + 0x30) != 0x62 &&
-			    (i + 0x30) != 0x6a && (i + 0x30) != 0x6b)
+			    (i + 0x30) != 0x6a && (i + 0x30) != 0x6b &&
+			    (i + 0x30) != 0x70 && (i + 0x30) != 0x71 &&
+			    (i + 0x30) != 0x74 && (i + 0x30) != 0x75)
 				smtc_seqw(i + 0x30,
 					  vgamode[j].init_sr30_sr75[i]);
 


