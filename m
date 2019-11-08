Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 714D2F54D6
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfKHSzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:55:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:52640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731643AbfKHSzT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:55:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAAC121D7B;
        Fri,  8 Nov 2019 18:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239319;
        bh=JqBJ33MfxgJoV04Jkn6Y2nD3m+tGGlp3H9Rs53UmXYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HJSRF6y/rPA1qXOwdfPHjdRuS1YPOM4CUXvNxsNnaM+gXyHaOh8b25PwqcGP3BmnX
         9SDgZfcI/Ver5SvPl7EVj4salZwOA7CzBl0ukA6c+eIqH22qDm4R6+EZETIfPrVqTh
         CcExgjWahOq50EHUsfAbv5O0n+M3domKfJaBf8OY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linus.walleij@linaro.org, rmk+kernel@armlinux.org.uk, Ard Biesheuvel" 
        <ardb@kernel.org>, Russell King <rmk+kernel@armlinux.org.uk>,
        "David A. Long" <dave.long@linaro.org>,
        Julien Thierry <julien.thierry@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.4 73/75] ARM: fix the cockup in the previous patch
Date:   Fri,  8 Nov 2019 19:50:30 +0100
Message-Id: <20191108174812.725818389@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174708.135680837@linuxfoundation.org>
References: <20191108174708.135680837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

Commit d6951f582cc50ba0ad22ef46b599740966599b14 upstream.

The intention in the previous patch was to only place the processor
tables in the .rodata section if big.Little was being built and we
wanted the branch target hardening, but instead (due to the way it
was tested) it ended up always placing the tables into the .rodata
section.

Although harmless, let's correct this anyway.

Fixes: 3a4d0c2172bc ("ARM: ensure that processor vtables is not lost after boot")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David A. Long <dave.long@linaro.org>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/proc-macros.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/mm/proc-macros.S
+++ b/arch/arm/mm/proc-macros.S
@@ -263,7 +263,7 @@
  * If we are building for big.Little with branch predictor hardening,
  * we need the processor function tables to remain available after boot.
  */
-#if 1 // defined(CONFIG_BIG_LITTLE) && defined(CONFIG_HARDEN_BRANCH_PREDICTOR)
+#if defined(CONFIG_BIG_LITTLE) && defined(CONFIG_HARDEN_BRANCH_PREDICTOR)
 	.section ".rodata"
 #endif
 	.type	\name\()_processor_functions, #object
@@ -301,7 +301,7 @@ ENTRY(\name\()_processor_functions)
 	.endif
 
 	.size	\name\()_processor_functions, . - \name\()_processor_functions
-#if 1 // defined(CONFIG_BIG_LITTLE) && defined(CONFIG_HARDEN_BRANCH_PREDICTOR)
+#if defined(CONFIG_BIG_LITTLE) && defined(CONFIG_HARDEN_BRANCH_PREDICTOR)
 	.previous
 #endif
 .endm


