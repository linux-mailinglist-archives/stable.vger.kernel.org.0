Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B67420F06
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237738AbhJDNaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:30:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237446AbhJDN2a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:28:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0289D6137D;
        Mon,  4 Oct 2021 13:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353166;
        bh=gstO0AvIrv/0Q9NjnFGBELz0a+QCjMDzz7lAhmlf72o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vLveilkk2AFtyZrn1ICRYpDCXYuNdn3SVC1g7qvBdR1zVjzbhYvnFGBzw/Renb9a0
         N3dOhbcfVgj3tQIOE9lmlUUcRFH9fkhIYasWh9s2GPGPO7Gng1kIlpWF7P03CkPLVQ
         FclmskWVzDVuRjegDu+NukPHhIfGhMgPu6CKNVQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Elver <elver@google.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Taras Madan <tarasmadan@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 021/172] kasan: fix Kconfig check of CC_HAS_WORKING_NOSANITIZE_ADDRESS
Date:   Mon,  4 Oct 2021 14:51:11 +0200
Message-Id: <20211004125045.642797519@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Elver <elver@google.com>

[ Upstream commit fa360beac4b62d54879a88b182afef4b369c9700 ]

In the main KASAN config option CC_HAS_WORKING_NOSANITIZE_ADDRESS is
checked for instrumentation-based modes.  However, if
HAVE_ARCH_KASAN_HW_TAGS is true all modes may still be selected.

To fix, also make the software modes depend on
CC_HAS_WORKING_NOSANITIZE_ADDRESS.

Link: https://lkml.kernel.org/r/20210910084240.1215803-1-elver@google.com
Fixes: 6a63a63ff1ac ("kasan: introduce CONFIG_KASAN_HW_TAGS")
Signed-off-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Taras Madan <tarasmadan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.kasan | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/Kconfig.kasan b/lib/Kconfig.kasan
index 1e2d10f86011..cdc842d090db 100644
--- a/lib/Kconfig.kasan
+++ b/lib/Kconfig.kasan
@@ -66,6 +66,7 @@ choice
 config KASAN_GENERIC
 	bool "Generic mode"
 	depends on HAVE_ARCH_KASAN && CC_HAS_KASAN_GENERIC
+	depends on CC_HAS_WORKING_NOSANITIZE_ADDRESS
 	select SLUB_DEBUG if SLUB
 	select CONSTRUCTORS
 	help
@@ -86,6 +87,7 @@ config KASAN_GENERIC
 config KASAN_SW_TAGS
 	bool "Software tag-based mode"
 	depends on HAVE_ARCH_KASAN_SW_TAGS && CC_HAS_KASAN_SW_TAGS
+	depends on CC_HAS_WORKING_NOSANITIZE_ADDRESS
 	select SLUB_DEBUG if SLUB
 	select CONSTRUCTORS
 	help
-- 
2.33.0



