Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA31EEE6B
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388002AbfKDWOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:14:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:39732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389164AbfKDWHS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:07:18 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 992212190F;
        Mon,  4 Nov 2019 22:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905238;
        bh=OPQh/w0HN7ptn6tENX2+5V6kRqT+2oS1MekYamXmnGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tIfj/tHu0GmvdSMe86ucVbWpFlSAh5peYxJfHWze3ZxGfJTsRyEH53a+Sy70v1vwW
         lFZJ+Hwyej+Y7/NndhPuD1mL/6UBisf1S77JFS17yYT4q64OeVmYq6TMUklglm5hQS
         rEb+bgbrKIvtanVLKNhQsleV51YySt36apvRFu3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 049/163] arm64: Default to building compat vDSO with clang when CONFIG_CC_IS_CLANG
Date:   Mon,  4 Nov 2019 22:43:59 +0100
Message-Id: <20191104212143.742987092@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

[ Upstream commit 24ee01a927bfe56c66429ec4b1df6955a814adc8 ]

Rather than force the use of GCC for the compat cross-compiler, instead
extract the target from CROSS_COMPILE_COMPAT and pass it to clang if the
main compiler is clang.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 9743b50bdee7d..5858d6e449268 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -47,7 +47,11 @@ $(warning Detected assembler with broken .inst; disassembly will be unreliable)
   endif
 endif
 
+ifeq ($(CONFIG_CC_IS_CLANG), y)
+COMPATCC ?= $(CC) --target=$(notdir $(CROSS_COMPILE_COMPAT:%-=%))
+else
 COMPATCC ?= $(CROSS_COMPILE_COMPAT)gcc
+endif
 export COMPATCC
 
 ifeq ($(CONFIG_GENERIC_COMPAT_VDSO), y)
-- 
2.20.1



