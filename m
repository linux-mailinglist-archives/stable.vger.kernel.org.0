Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D06B28A5A
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731820AbfEWTMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731801AbfEWTMu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:12:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CEC621855;
        Thu, 23 May 2019 19:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638769;
        bh=fvZOAFP5AIRVhhIqDeRi4wXWN+GCiBS8EQcBL1t27ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z2QFKmtzmTWK5M3iCyZ7yBA1UemX6uMAOrJEwABjMWBLZEB+xZ4o9V/npQ2MXB4U/
         P2irRN+4J1t1UKN9tvZ8AaeZyoe5cOx7qX7ZjmMI2y4miosKioeH0cmSgW/fQ7lTt8
         /UZYi/QDHsUivxUAROMtVkaEusV9q2mXyoUjYjuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yifeng Li <tomli@tomli.me>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Teddy Wang <teddy.wang@siliconmotion.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 4.14 41/77] fbdev: sm712fb: fix brightness control on reboot, dont set SR30
Date:   Thu, 23 May 2019 21:05:59 +0200
Message-Id: <20190523181725.844396449@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181719.982121681@linuxfoundation.org>
References: <20190523181719.982121681@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifeng Li <tomli@tomli.me>

commit 5481115e25e42b9215f2619452aa99c95f08492f upstream.

On a Thinkpad s30 (Pentium III / i440MX, Lynx3DM), rebooting with
sm712fb framebuffer driver would cause the role of brightness up/down
button to swap.

Experiments showed the FPR30 register caused this behavior. Moreover,
even if this register don't have side-effect on other systems, over-
writing it is also highly questionable, since it was originally
configurated by the motherboard manufacturer by hardwiring pull-down
resistors to indicate the type of LCD panel. We should not mess with
it.

Stop writing to the SR30 (a.k.a FPR30) register.

Signed-off-by: Yifeng Li <tomli@tomli.me>
Tested-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Teddy Wang <teddy.wang@siliconmotion.com>
Cc: <stable@vger.kernel.org>  # v4.4+
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/sm712fb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/sm712fb.c
+++ b/drivers/video/fbdev/sm712fb.c
@@ -1145,8 +1145,8 @@ static void sm7xx_set_timing(struct smtc
 
 		/* init SEQ register SR30 - SR75 */
 		for (i = 0; i < SIZE_SR30_SR75; i++)
-			if ((i + 0x30) != 0x62 && (i + 0x30) != 0x6a &&
-			    (i + 0x30) != 0x6b)
+			if ((i + 0x30) != 0x30 && (i + 0x30) != 0x62 &&
+			    (i + 0x30) != 0x6a && (i + 0x30) != 0x6b)
 				smtc_seqw(i + 0x30,
 					  vgamode[j].init_sr30_sr75[i]);
 


