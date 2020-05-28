Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9191E607F
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 14:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388979AbgE1MLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 08:11:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388631AbgE1L4I (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 07:56:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BEDB21475;
        Thu, 28 May 2020 11:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590666968;
        bh=15vT6BO6SLJKvTbMECpr6jSBvhkfxGZDulCbFJ6eCMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OwLYj/yz0hVrt9cfz8s8sIG1J6tjLimtg909E7CujgWUS8hJMiYvzNFQSMuEzyDb1
         Ky9tq6qmewzTcayEyg0dn0XNwjkUhLcQFsWIFKRAsOsi/JJ1MojR/gowP3TZscr/Ro
         FectpEHnP8fN8c9xTw1VBo6g7fhW+CoRm5uQoNPU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Young <dyoung@redhat.com>, Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-efi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 06/47] efi/earlycon: Fix early printk for wider fonts
Date:   Thu, 28 May 2020 07:55:19 -0400
Message-Id: <20200528115600.1405808-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115600.1405808-1-sashal@kernel.org>
References: <20200528115600.1405808-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

