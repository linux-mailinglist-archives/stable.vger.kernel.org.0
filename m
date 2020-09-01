Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6652A2592F1
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbgIAPTR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:19:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729526AbgIAPTA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:19:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40534206EB;
        Tue,  1 Sep 2020 15:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973539;
        bh=WGecJdVzW2/wkgbKsP9IV/jqaXHs7s6kSRuTSIbnzuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=12TORbobqbCZUCYG/liDev4xIJ2DetU6EuE54OQNlYAJvYOFPN8lrkNwtJR95Y80k
         kf9a4T0f00ifvS2SAlz1ZpkPba8OSzzrts9Rt5zV16DhQkwr5PBv0cH25cBxyGeVuA
         2L71OBweFm5d3nITgWLjVhEcgjN8M9O2E6QxkBUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Alexander Potapenko <glider@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Elena Petrova <lenaptr@google.com>,
        Marco Elver <elver@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Walter Wu <walter-zh.wu@mediatek.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 40/91] efi: provide empty efi_enter_virtual_mode implementation
Date:   Tue,  1 Sep 2020 17:10:14 +0200
Message-Id: <20200901150930.137256239@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150928.096174795@linuxfoundation.org>
References: <20200901150928.096174795@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>

[ Upstream commit 2c547f9da0539ad1f7ef7f08c8c82036d61b011a ]

When CONFIG_EFI is not enabled, we might get an undefined reference to
efi_enter_virtual_mode() error, if this efi_enabled() call isn't inlined
into start_kernel().  This happens in particular, if start_kernel() is
annodated with __no_sanitize_address.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Elena Petrova <lenaptr@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Walter Wu <walter-zh.wu@mediatek.com>
Link: http://lkml.kernel.org/r/6514652d3a32d3ed33d6eb5c91d0af63bf0d1a0c.1596544734.git.andreyknvl@google.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/efi.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 2dab158b74c45..598ee6ba5b18f 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -948,7 +948,11 @@ extern void *efi_get_pal_addr (void);
 extern void efi_map_pal_code (void);
 extern void efi_memmap_walk (efi_freemem_callback_t callback, void *arg);
 extern void efi_gettimeofday (struct timespec64 *ts);
+#ifdef CONFIG_EFI
 extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
+#else
+static inline void efi_enter_virtual_mode (void) {}
+#endif
 #ifdef CONFIG_X86
 extern void efi_late_init(void);
 extern void efi_free_boot_services(void);
-- 
2.25.1



