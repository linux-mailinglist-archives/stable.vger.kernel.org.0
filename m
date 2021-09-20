Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCB1411EC8
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345019AbhITRfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:35:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:34102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351216AbhITRcj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:32:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56E1361AEC;
        Mon, 20 Sep 2021 17:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157500;
        bh=1Xc480vfCc7bkYjQyN3dbBapztLefZiyxToPrtjCaQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FXoGQ5HkFPVyjX4aL81V5qhmXlaFTTToeha9BE5zcctDxM6FDZciuYKrrTihpD4/V
         715z1au2d6uOctV+YiGr3CSlHB92gJ/UDLADIuaOqpnComg1oDHiKyJ8gFtmQ2NfQ2
         jl1+cA2fvRRI4dKEBa3tHPmhYhhuiZSv+KTw5gEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Chris Zankel <chris@zankel.net>, linux-xtensa@linux-xtensa.org
Subject: [PATCH 4.19 002/293] xtensa: fix kconfig unmet dependency warning for HAVE_FUTEX_CMPXCHG
Date:   Mon, 20 Sep 2021 18:39:24 +0200
Message-Id: <20210920163933.343788249@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
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
@@ -25,7 +25,7 @@ config XTENSA
 	select HAVE_DMA_CONTIGUOUS
 	select HAVE_EXIT_THREAD
 	select HAVE_FUNCTION_TRACER
-	select HAVE_FUTEX_CMPXCHG if !MMU
+	select HAVE_FUTEX_CMPXCHG if !MMU && FUTEX
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_IRQ_TIME_ACCOUNTING
 	select HAVE_MEMBLOCK


