Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 357E254056D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238812AbiFGR0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346263AbiFGRYN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:24:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FEA760E9;
        Tue,  7 Jun 2022 10:22:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D59DECE2015;
        Tue,  7 Jun 2022 17:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEADCC34115;
        Tue,  7 Jun 2022 17:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622528;
        bh=y268Ia38mDcy8oVClEGS/uTeQtbK8P1DKzIAcwjQsRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2qqYt5rIxB8zewUv6ceMpto59NW7v6+VbrO8IVW/bpOwHlMDNlZBc2Ncdojl7BHt1
         LpZWLbKGT3CvaHDlYKmqAKT+vRP7DAsktFP+L8J4xKlUS6Nh+GwKdPZ/rYAWxVg7Le
         C6v4iWKsyZ6POMBP0J6/Fb6jQ4gRe88Rqq52nUu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/452] m68k: atari: Make Atari ROM port I/O write macros return void
Date:   Tue,  7 Jun 2022 18:59:08 +0200
Message-Id: <20220607164911.270481433@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 30b5e6ef4a32ea4985b99200e06d6660a69f9246 ]

The macros implementing Atari ROM port I/O writes do not cast away their
output, unlike similar implementations for other I/O buses.
When they are combined using conditional expressions in the definitions of
outb() and friends, this triggers sparse warnings like:

    drivers/net/appletalk/cops.c:382:17: error: incompatible types in conditional expression (different base types):
    drivers/net/appletalk/cops.c:382:17:    unsigned char
    drivers/net/appletalk/cops.c:382:17:    void

Fix this by adding casts to "void".

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Michael Schmitz <schmitzmic@gmail.com>
Link: https://lore.kernel.org/r/c15bedc83d90a14fffcd5b1b6bfb32b8a80282c5.1653057096.git.geert@linux-m68k.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/include/asm/raw_io.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/include/asm/raw_io.h b/arch/m68k/include/asm/raw_io.h
index 80eb2396d01e..3ba40bc1dfaa 100644
--- a/arch/m68k/include/asm/raw_io.h
+++ b/arch/m68k/include/asm/raw_io.h
@@ -80,14 +80,14 @@
 	({ u16 __v = le16_to_cpu(*(__force volatile u16 *) (addr)); __v; })
 
 #define rom_out_8(addr, b)	\
-	({u8 __maybe_unused __w, __v = (b);  u32 _addr = ((u32) (addr)); \
+	(void)({u8 __maybe_unused __w, __v = (b);  u32 _addr = ((u32) (addr)); \
 	__w = ((*(__force volatile u8 *)  ((_addr | 0x10000) + (__v<<1)))); })
 #define rom_out_be16(addr, w)	\
-	({u16 __maybe_unused __w, __v = (w); u32 _addr = ((u32) (addr)); \
+	(void)({u16 __maybe_unused __w, __v = (w); u32 _addr = ((u32) (addr)); \
 	__w = ((*(__force volatile u16 *) ((_addr & 0xFFFF0000UL) + ((__v & 0xFF)<<1)))); \
 	__w = ((*(__force volatile u16 *) ((_addr | 0x10000) + ((__v >> 8)<<1)))); })
 #define rom_out_le16(addr, w)	\
-	({u16 __maybe_unused __w, __v = (w); u32 _addr = ((u32) (addr)); \
+	(void)({u16 __maybe_unused __w, __v = (w); u32 _addr = ((u32) (addr)); \
 	__w = ((*(__force volatile u16 *) ((_addr & 0xFFFF0000UL) + ((__v >> 8)<<1)))); \
 	__w = ((*(__force volatile u16 *) ((_addr | 0x10000) + ((__v & 0xFF)<<1)))); })
 
-- 
2.35.1



