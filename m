Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC0FDD44D
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbfJRWFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:05:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729258AbfJRWFL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:05:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6A7920679;
        Fri, 18 Oct 2019 22:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436310;
        bh=K0t/5gdRAUZIWMHMVHKYMsEkOxWj+ixEwMT6gmbfnko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gePyJkW1HoOPIR+psCtLI8kyC6q0VBQsBM53rgFfeba8VHdJ3VMrqlfJxdmkrwTZm
         eYUPuhCLYbNqJFU81+1A/nBcCT2/XcbZ71eb+QTbTydSCBZSTa4iUxhxh6uiiREHuB
         vMv2JUQOngf7YeBTNYKmhpGtOoYRf/l4Gdbb3Pvk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>, linux-mips@linux-mips.org
Subject: [PATCH AUTOSEL 5.3 80/89] MIPS: include: Mark __xchg as __always_inline
Date:   Fri, 18 Oct 2019 18:03:15 -0400
Message-Id: <20191018220324.8165-80-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

[ Upstream commit 46f1619500d022501a4f0389f9f4c349ab46bb86 ]

Commit ac7c3e4ff401 ("compiler: enable CONFIG_OPTIMIZE_INLINING
forcibly") allows compiler to uninline functions marked as 'inline'.
In cace of __xchg this would cause to reference function
__xchg_called_with_bad_pointer, which is an error case
for catching bugs and will not happen for correct code, if
__xchg is inlined.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/cmpxchg.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/cmpxchg.h b/arch/mips/include/asm/cmpxchg.h
index 319522fa3a45e..2b61052e10c94 100644
--- a/arch/mips/include/asm/cmpxchg.h
+++ b/arch/mips/include/asm/cmpxchg.h
@@ -77,8 +77,8 @@ extern unsigned long __xchg_called_with_bad_pointer(void)
 extern unsigned long __xchg_small(volatile void *ptr, unsigned long val,
 				  unsigned int size);
 
-static inline unsigned long __xchg(volatile void *ptr, unsigned long x,
-				   int size)
+static __always_inline
+unsigned long __xchg(volatile void *ptr, unsigned long x, int size)
 {
 	switch (size) {
 	case 1:
-- 
2.20.1

