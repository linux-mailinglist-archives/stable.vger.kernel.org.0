Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05FCF3A9D2
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730208AbfFIQ6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:58:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:33034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733289AbfFIQ6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:58:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C3FA207E0;
        Sun,  9 Jun 2019 16:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099480;
        bh=DGEHl8TIH0hqQEozBpsSU+CoLWsm/BgOYFTk5j/3BAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VxdrCTHs2JmDs7y8yyj5Msid0CaTYsmelEoetym4mkNe3YQ5nkldMU5j+5B2exq+W
         0zxzS2iZDbTrbGlc6oWQqdJq9LT9eWafbpxDohHgDdfv/JGSV0RsNyyObDJcYCaah7
         OCyp/qPycLY4Xexrtvk9geB/16e0HwOZ3gxUpgl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yifeng Li <tomli@tomli.me>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Teddy Wang <teddy.wang@siliconmotion.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 4.4 056/241] fbdev: sm712fb: fix white screen of death on reboot, dont set CR3B-CR3F
Date:   Sun,  9 Jun 2019 18:39:58 +0200
Message-Id: <20190609164149.392234936@linuxfoundation.org>
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

commit 8069053880e0ee3a75fd6d7e0a30293265fe3de4 upstream.

On a Thinkpad s30 (Pentium III / i440MX, Lynx3DM), rebooting with
sm712fb framebuffer driver would cause a white screen of death on
the next POST, presumably the proper timings for the LCD panel was
not reprogrammed properly by the BIOS.

Experiments showed a few CRTC Scratch Registers, including CRT3D,
CRT3E and CRT3F may be used internally by BIOS as some flags. CRT3B is
a hardware testing register, we shouldn't mess with it. CRT3C has
blanking signal and line compare control, which is not needed for this
driver.

Stop writing to CR3B-CR3F (a.k.a CRT3B-CRT3F) registers. Even if these
registers don't have side-effect on other systems, writing to them is
also highly questionable.

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
@@ -1172,8 +1172,12 @@ static void sm7xx_set_timing(struct smtc
 			smtc_crtcw(i, vgamode[j].init_cr00_cr18[i]);
 
 		/* init CRTC register CR30 - CR4D */
-		for (i = 0; i < SIZE_CR30_CR4D; i++)
+		for (i = 0; i < SIZE_CR30_CR4D; i++) {
+			if ((i + 0x30) >= 0x3B && (i + 0x30) <= 0x3F)
+				/* side-effect, don't write to CR3B-CR3F */
+				continue;
 			smtc_crtcw(i + 0x30, vgamode[j].init_cr30_cr4d[i]);
+		}
 
 		/* init CRTC register CR90 - CRA7 */
 		for (i = 0; i < SIZE_CR90_CRA7; i++)


