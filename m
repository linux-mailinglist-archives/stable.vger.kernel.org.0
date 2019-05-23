Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 199AA28977
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388049AbfEWTiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:38:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390336AbfEWTX3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:23:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6162D21841;
        Thu, 23 May 2019 19:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639408;
        bh=3rxfAX4mLHvVaXl+hX9hwHnq3HJQHQSfrnr68pxQPQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pqjin1Rol+xuWfgTleSKUhjvGLc3NxcvqvbKgiCYAqXPlepyiMhlP8FwiFTQdmHNT
         oZZ0XYmi6orDgGX6K6RgABQbW2xNsJdXT4NNMReiEe6V0GqIJORE1m+LHjylY2AXRl
         /6K1yKpAv18hs6Y5zDdHwGLTTjK6Vd8rEaysHZxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yifeng Li <tomli@tomli.me>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Teddy Wang <teddy.wang@siliconmotion.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 5.0 078/139] fbdev: sm712fb: fix VRAM detection, dont set SR70/71/74/75
Date:   Thu, 23 May 2019 21:06:06 +0200
Message-Id: <20190523181731.017644887@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
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
@@ -1146,7 +1146,9 @@ static void sm7xx_set_timing(struct smtc
 		/* init SEQ register SR30 - SR75 */
 		for (i = 0; i < SIZE_SR30_SR75; i++)
 			if ((i + 0x30) != 0x30 && (i + 0x30) != 0x62 &&
-			    (i + 0x30) != 0x6a && (i + 0x30) != 0x6b)
+			    (i + 0x30) != 0x6a && (i + 0x30) != 0x6b &&
+			    (i + 0x30) != 0x70 && (i + 0x30) != 0x71 &&
+			    (i + 0x30) != 0x74 && (i + 0x30) != 0x75)
 				smtc_seqw(i + 0x30,
 					  vgamode[j].init_sr30_sr75[i]);
 


