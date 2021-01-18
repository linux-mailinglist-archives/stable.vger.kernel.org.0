Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4CBB2FA9DB
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437081AbhARTO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:14:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:34158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390490AbhARLiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 511AA229F0;
        Mon, 18 Jan 2021 11:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969891;
        bh=9EyhAMPQJR9gfoc9wUHB3iNTPkxEYBXjkF2AAWS0kUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ubkxspOjuy5zwFmkWh1QbES/V5zcOLLsvhHzNLiOT9EqvFHe+7r1Gs29bTHE/pvL7
         Jtca62+cbAVRdveplXUlAI3P3x5L1Zsse3j3ihdjPQT/XL6jViRl1Um9NUowZr2llB
         wYQQZi7m1jS4MCvq2buFgCkYjvK0KYvtn4XBF9N4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.4 06/76] mips: fix Section mismatch in reference
Date:   Mon, 18 Jan 2021 12:34:06 +0100
Message-Id: <20210118113341.288296200@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anders Roxell <anders.roxell@linaro.org>

commit ad4fddef5f2345aa9214e979febe2f47639c10d9 upstream.

When building mips tinyconfig with clang the following error show up:

WARNING: modpost: vmlinux.o(.text+0x1940c): Section mismatch in reference from the function r4k_cache_init() to the function .init.text:loongson3_sc_init()
The function r4k_cache_init() references
the function __init loongson3_sc_init().
This is often because r4k_cache_init lacks a __init
annotation or the annotation of loongson3_sc_init is wrong.

Remove marked __init from function loongson3_sc_init(),
mips_sc_probe_cm3(), and mips_sc_probe().

Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/mm/c-r4k.c   |    2 +-
 arch/mips/mm/sc-mips.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -1576,7 +1576,7 @@ static void __init loongson2_sc_init(voi
 	c->options |= MIPS_CPU_INCLUSIVE_CACHES;
 }
 
-static void __init loongson3_sc_init(void)
+static void loongson3_sc_init(void)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
 	unsigned int config2, lsize;
--- a/arch/mips/mm/sc-mips.c
+++ b/arch/mips/mm/sc-mips.c
@@ -147,7 +147,7 @@ static inline int mips_sc_is_activated(s
 	return 1;
 }
 
-static int __init mips_sc_probe_cm3(void)
+static int mips_sc_probe_cm3(void)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
 	unsigned long cfg = read_gcr_l2_config();
@@ -181,7 +181,7 @@ static int __init mips_sc_probe_cm3(void
 	return 0;
 }
 
-static inline int __init mips_sc_probe(void)
+static inline int mips_sc_probe(void)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
 	unsigned int config1, config2;


