Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1E81161220
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 13:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgBQMeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 07:34:16 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:51863 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727233AbgBQMeQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Feb 2020 07:34:16 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id f0ea0cd6;
        Mon, 17 Feb 2020 12:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=49D27kxg0UWqMr8a6T9SalhHZ+w=; b=UJO8TtfU1Hx+eOb/I3EB
        CrU8nDXdFXqRXaUutOstVnwV0ZcP57ei9qASI3om6mcD6+rNQS7W63YkPpBqN4Te
        CzDQ90ewcK8Y32CP4dVA3QXFYLfWx0n83GApYPyvV/zhlGJ2zwXSaTrEczYVnxg3
        WBbNBdlxIkGXN6pcCimWFx7I/WUsuYKVnxVjV+crr4a+gE6QjWqsZfbnWILbmckP
        49RcYRsBKHh8NKlHwFzuzSvXvfbjplTr1Qflx21EVcxC7nj/2tVedAcfN2U0WfAe
        nn8gjhHUjy1kLVJe2TuG28sdvISLB3nLTpTrnIh6n1vQXve6pusT9K1tAmLMSvsq
        YQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5961f11e (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 17 Feb 2020 12:31:45 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     ardb@kernel.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [PATCH] efi: READ_ONCE rng seed size before munmap
Date:   Mon, 17 Feb 2020 13:33:54 +0100
Message-Id: <20200217123354.21140-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This function is consistent with using size instead of seed->size
(except for one place that this patch fixes), but it reads seed->size
without using READ_ONCE, which means the compiler might still do
something unwanted. So, this commit simply adds the READ_ONCE
wrapper.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: stable@vger.kernel.org
---
 drivers/firmware/efi/efi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 621220ab3d0e..21ea99f65113 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -552,7 +552,7 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 
 		seed = early_memremap(efi.rng_seed, sizeof(*seed));
 		if (seed != NULL) {
-			size = seed->size;
+			size = READ_ONCE(seed->size);
 			early_memunmap(seed, sizeof(*seed));
 		} else {
 			pr_err("Could not map UEFI random seed!\n");
@@ -562,7 +562,7 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 					      sizeof(*seed) + size);
 			if (seed != NULL) {
 				pr_notice("seeding entropy pool\n");
-				add_bootloader_randomness(seed->bits, seed->size);
+				add_bootloader_randomness(seed->bits, size);
 				early_memunmap(seed, sizeof(*seed) + size);
 			} else {
 				pr_err("Could not map UEFI random seed!\n");
-- 
2.25.0

