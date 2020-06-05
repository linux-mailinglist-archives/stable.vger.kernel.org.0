Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0E31EFA70
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbgFEORf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:17:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727893AbgFEORe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:17:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2E53206A2;
        Fri,  5 Jun 2020 14:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366653;
        bh=15vT6BO6SLJKvTbMECpr6jSBvhkfxGZDulCbFJ6eCMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z5K5zAZmbGxchPRs10jCIjZoYifgAHgqEkOe43YwY4P3fhRmzU2h4X/sS2JUUDCDy
         kZQhrSmmPprYZKaqVRxT/ENV1iV3QKCvFpukqA7GnQ3DRGTBJxI+XyIXNUen/5oSM9
         AUZmulu/xEEs899THeymBsNBLSIBeJ+JG4dXjNrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Young <dyoung@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 08/43] efi/earlycon: Fix early printk for wider fonts
Date:   Fri,  5 Jun 2020 16:14:38 +0200
Message-Id: <20200605140152.960471619@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140152.493743366@linuxfoundation.org>
References: <20200605140152.493743366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Young <dyoung@redhat.com>

[ Upstream commit 8f592ada59b321d248391bae175cd78a12972223 ]

When I play with terminus fonts I noticed the efi early printk does
not work because the earlycon code assumes font width is 8.

Here add the code to adapt with larger fonts.  Tested with all kinds
of kernel built-in fonts on my laptop. Also tested with a local draft
patch for 14x28 !bold terminus font.

Signed-off-by: Dave Young <dyoung@redhat.com>
Link: https://lore.kernel.org/r/20200412024927.GA6884@dhcp-128-65.nay.redhat.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/earlycon.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/earlycon.c b/drivers/firmware/efi/earlycon.c
index 5d4f84781aa0..a52236e11e5f 100644
--- a/drivers/firmware/efi/earlycon.c
+++ b/drivers/firmware/efi/earlycon.c
@@ -114,14 +114,16 @@ static void efi_earlycon_write_char(u32 *dst, unsigned char c, unsigned int h)
 	const u32 color_black = 0x00000000;
 	const u32 color_white = 0x00ffffff;
 	const u8 *src;
-	u8 s8;
-	int m;
+	int m, n, bytes;
+	u8 x;
 
-	src = font->data + c * font->height;
-	s8 = *(src + h);
+	bytes = BITS_TO_BYTES(font->width);
+	src = font->data + c * font->height * bytes + h * bytes;
 
-	for (m = 0; m < 8; m++) {
-		if ((s8 >> (7 - m)) & 1)
+	for (m = 0; m < font->width; m++) {
+		n = m % 8;
+		x = *(src + m / 8);
+		if ((x >> (7 - n)) & 1)
 			*dst = color_white;
 		else
 			*dst = color_black;
-- 
2.25.1



