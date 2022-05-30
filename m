Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAFCF5380E9
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238245AbiE3N5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239026AbiE3Nzh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:55:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96B3954B1;
        Mon, 30 May 2022 06:38:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A054AB80DB3;
        Mon, 30 May 2022 13:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBC5C385B8;
        Mon, 30 May 2022 13:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917884;
        bh=y268Ia38mDcy8oVClEGS/uTeQtbK8P1DKzIAcwjQsRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rUbQNiCS0R9tu2kAhdpQIrTorVEGQftcLIbw/MwRJ1UY35SXRbOnJhNzTdbsBRGsF
         8v4+x6Dbyd1aolZRus3wWH49b4W8wRSYeiEIARRBuqeuP0PkIcoiCj28vbh/7zpvGY
         YFOTatkfbyX76OGVBYnoNMBi0Y4QYTWPW79XYiRTW4FdpnQt5ODHI6spoBXJlcVBqB
         obheVm2/F0RZq9JEtpnBMqgfD7OL9o2EG9xvclNh87H0T8XBPYmyfDVovnEPSz/7nw
         wVfgvbagBnjEpuV8K8yEMAH9Pq6PHT5wmkqIQrDb3ZCc1giHMFF1W7AnAE10aKMvaD
         6ODS0OfblqZQw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        kernel test robot <lkp@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-m68k@lists.linux-m68k.org
Subject: [PATCH AUTOSEL 5.17 127/135] m68k: atari: Make Atari ROM port I/O write macros return void
Date:   Mon, 30 May 2022 09:31:25 -0400
Message-Id: <20220530133133.1931716-127-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

