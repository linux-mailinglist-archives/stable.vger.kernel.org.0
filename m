Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9192D401BF0
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243537AbhIFNAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 09:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242356AbhIFM7v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Sep 2021 08:59:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC08860F92;
        Mon,  6 Sep 2021 12:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630933126;
        bh=VENqdq+HkTiw4Yh4g4a6fxcjvRQDGMjRGGVT37S2/Ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OQpuc2uL/2kgMD5/jCZL8F/Dbp/cXOKNBE1AaJOcT8CBIHiSt7k3a1cq6cSHujBVH
         qXpIh6r+wpfo7xwlCJFveaEISLDpJWQbxmGRxyDS43G6iw1ysxagljkjOts8EXNHKj
         Pw6Wm880s0SLOrV7xXPi2Tte78gFldN3Bj7pWGiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Chris Zankel <chris@zankel.net>, linux-xtensa@linux-xtensa.org
Subject: [PATCH 5.14 03/14] xtensa: fix kconfig unmet dependency warning for HAVE_FUTEX_CMPXCHG
Date:   Mon,  6 Sep 2021 14:55:49 +0200
Message-Id: <20210906125448.270475364@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210906125448.160263393@linuxfoundation.org>
References: <20210906125448.160263393@linuxfoundation.org>
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


