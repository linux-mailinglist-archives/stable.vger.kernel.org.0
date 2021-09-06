Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308E2401BBF
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242810AbhIFM7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 08:59:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242323AbhIFM6s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:58:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B69E061057;
        Mon,  6 Sep 2021 12:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933064;
        bh=VENqdq+HkTiw4Yh4g4a6fxcjvRQDGMjRGGVT37S2/Ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BOm9et2leBx6HgRrEKvjWdMv6mzNVlsvbVVrGNH7j+aEchmd/OZr4Sge1y3eZCCAc
         +hjtId2VCxosc3Li8EHWXPzaBhZjUTKRmaSFlsp9pXu2YO8O58OBe636uti1lEAKJ9
         rGapMWmHWlQSuCThYAVFUX8PTHetXfn3rsj1U2NA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Chris Zankel <chris@zankel.net>, linux-xtensa@linux-xtensa.org
Subject: [PATCH 5.13 16/24] xtensa: fix kconfig unmet dependency warning for HAVE_FUTEX_CMPXCHG
Date:   Mon,  6 Sep 2021 14:55:45 +0200
Message-Id: <20210906125449.649085343@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125449.112564040@linuxfoundation.org>
References: <20210906125449.112564040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit ed5aacc81cd41efc4d561e14af408d1003f7b855 upstream.

XTENSA should only select HAVE_FUTEX_CMPXCHG when FUTEX is
set/enabled. This prevents a kconfig warning.

WARNING: unmet direct dependencies detected for HAVE_FUTEX_CMPXCHG
  Depends on [n]: FUTEX [=n]
  Selected by [y]:
  - XTENSA [=y] && !MMU [=n]

Fixes: d951ba21b959 ("xtensa: nommu: select HAVE_FUTEX_CMPXCHG")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: linux-xtensa@linux-xtensa.org
Message-Id: <20210526070337.28130-1-rdunlap@infradead.org>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -30,7 +30,7 @@ config XTENSA
 	select HAVE_DMA_CONTIGUOUS
 	select HAVE_EXIT_THREAD
 	select HAVE_FUNCTION_TRACER
-	select HAVE_FUTEX_CMPXCHG if !MMU
+	select HAVE_FUTEX_CMPXCHG if !MMU && FUTEX
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_IRQ_TIME_ACCOUNTING
 	select HAVE_PCI


