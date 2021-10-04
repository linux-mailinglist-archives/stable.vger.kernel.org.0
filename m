Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB75420F02
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237278AbhJDNaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:30:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237372AbhJDN2Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:28:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8714F61373;
        Mon,  4 Oct 2021 13:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353164;
        bh=MK0Q2HKneqGCulWa8H3AJBXIgOVcw1IeC78PnnTqs+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=isti96EMVO9BaszbuJzO8vMNeV7mBtwT9OGeypJB6GJO7zXZpRsqU2vDgVbzGJhpo
         /ZsbD+nbL2b9CZ/5fGjdYdKlZmeck/MBi1oBodTG9FRa0JvNelPQYhKO/LqKLExHei
         pYI+AIiJ3EIP8zxLvMQuudLkKKZe7KKrDvX8uO6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 020/172] NIOS2: fix kconfig unmet dependency warning for SERIAL_CORE_CONSOLE
Date:   Mon,  4 Oct 2021 14:51:10 +0200
Message-Id: <20211004125045.613533516@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit adfc8f9d2f9fefd880abc82cfbf62cbfe6539c97 ]

SERIAL_CORE_CONSOLE depends on TTY so EARLY_PRINTK should also
depend on TTY so that it does not select SERIAL_CORE_CONSOLE
inadvertently.

WARNING: unmet direct dependencies detected for SERIAL_CORE_CONSOLE
  Depends on [n]: TTY [=n] && HAS_IOMEM [=y]
  Selected by [y]:
  - EARLY_PRINTK [=y]

Fixes: e8bf5bc776ed ("nios2: add early printk support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/nios2/Kconfig.debug | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/nios2/Kconfig.debug b/arch/nios2/Kconfig.debug
index a8bc06e96ef5..ca1beb87f987 100644
--- a/arch/nios2/Kconfig.debug
+++ b/arch/nios2/Kconfig.debug
@@ -3,9 +3,10 @@
 config EARLY_PRINTK
 	bool "Activate early kernel debugging"
 	default y
+	depends on TTY
 	select SERIAL_CORE_CONSOLE
 	help
-	  Enable early printk on console
+	  Enable early printk on console.
 	  This is useful for kernel debugging when your machine crashes very
 	  early before the console code is initialized.
 	  You should normally say N here, unless you want to debug such a crash.
-- 
2.33.0



