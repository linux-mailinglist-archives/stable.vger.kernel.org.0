Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0772FA8AC
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393086AbhARPGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 10:06:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:36932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390745AbhARLll (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:41:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38F4522227;
        Mon, 18 Jan 2021 11:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970081;
        bh=JuV+s/KeIzEShE7bSGVcyzHh1q02bTBuQmIL20AxEC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pmeb3l+c5uyX61AS73tZxEDjp6kPrFjf6gch24FqQnt8WdeU06F6owG+uO+ykQPVx
         zMfTZy5ziLh1HjobYEBlh6R1aOXarYqhYq7eZd2fv8vTrDSQ7DICIau9hVpwViRkR9
         WyftytENtcmFPiw8g1ST2/dHAJS9Gy8dICUSMhhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.10 029/152] mips: fix Section mismatch in reference
Date:   Mon, 18 Jan 2021 12:33:24 +0100
Message-Id: <20210118113354.177932943@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
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
@@ -1609,7 +1609,7 @@ static void __init loongson2_sc_init(voi
 	c->options |= MIPS_CPU_INCLUSIVE_CACHES;
 }
 
-static void __init loongson3_sc_init(void)
+static void loongson3_sc_init(void)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
 	unsigned int config2, lsize;
--- a/arch/mips/mm/sc-mips.c
+++ b/arch/mips/mm/sc-mips.c
@@ -146,7 +146,7 @@ static inline int mips_sc_is_activated(s
 	return 1;
 }
 
-static int __init mips_sc_probe_cm3(void)
+static int mips_sc_probe_cm3(void)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
 	unsigned long cfg = read_gcr_l2_config();
@@ -180,7 +180,7 @@ static int __init mips_sc_probe_cm3(void
 	return 0;
 }
 
-static inline int __init mips_sc_probe(void)
+static inline int mips_sc_probe(void)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
 	unsigned int config1, config2;


