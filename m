Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 614B96C2578
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 00:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbjCTXNV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 19:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbjCTXNU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 19:13:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BD434C0C;
        Mon, 20 Mar 2023 16:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=VBdK0/Y4JqBgPMxacPgxZ9ztvbW86iUY79ITNsMQ6C8=; b=KeaDk1eTpGWhCEvi/fOy/KW+mV
        Yj1EzTN1s1jEKgM1aUneB5PVBdgtOLsO8O3e2TTwfWOggZd2TFr0D2XKquZtSIOnpfchSaif4+hCP
        RkACncjUU4NkgE8bJ5GXTk698BqcfOrpQRk6mQdlwkUajGCqsnXHiGWUBSkO2lTPJy/xC5SCkYN3u
        73g2+E8HWFGKqSrlFsTZTeQpx8xWV8g1giW5efCg5Gwizm0HkkvxEFiJhXXWVHjySxnvkFOOtGY6h
        jJpXGi+X0dg/v5N6ZZA87/kFKQGqGqRBltNMbdjHh3c+XMdVpM8kNgl+jmJegRghVGzi/GwpsCT0r
        Bu4QGKBQ==;
Received: from [2601:1c2:980:9ec0::21b4] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1peOgh-00Al4N-29;
        Mon, 20 Mar 2023 23:13:11 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Kuninori Morimoto <morimoto.kuninori@renesas.com>,
        linux-sh@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 6/7 v5] sh: fix Kconfig entry for NUMA => SMP
Date:   Mon, 20 Mar 2023 16:13:10 -0700
Message-Id: <20230320231310.28841-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix SUPERH builds that select SYS_SUPPORTS_NUMA but do not select
SYS_SUPPORTS_SMP and SMP.

kernel/sched/topology.c is only built for CONFIG_SMP and then the NUMA
code + data inside topology.c is only built when CONFIG_NUMA is
set/enabled, so these arch/sh/ configs need to select SMP and
SYS_SUPPORTS_SMP to build the NUMA support.

Fixes this build error in multiple SUPERH configs:

mm/page_alloc.o: In function `get_page_from_freelist':
page_alloc.c:(.text+0x2ca8): undefined reference to `node_reclaim_distance'

Fixes: 357d59469c11 ("sh: Tidy up dependencies for SH-2 build.")
Fixes: 9109a30e5a54 ("sh: add support for sh7366 processor")
Fixes: 55ba99eb211a ("sh: Add support for SH7786 CPU subtype.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: Kuninori Morimoto <morimoto.kuninori@renesas.com>
Cc: linux-sh@vger.kernel.org
Cc: stable@vger.kernel.org
---
v2: skipped
v3: skipped
v4: refresh & resend
v5: include CPU_SUBTYPE_SH7785 in this patch (Adrian)

 arch/sh/Kconfig |    6 ++++++
 1 file changed, 6 insertions(+)

diff -- a/arch/sh/Kconfig b/arch/sh/Kconfig
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -442,6 +442,8 @@ config CPU_SUBTYPE_SH7785
 	select CPU_SHX2
 	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_NUMA
+	select SYS_SUPPORTS_SMP
+	select SMP
 	select PINCTRL
 
 config CPU_SUBTYPE_SH7786
@@ -476,6 +478,8 @@ config CPU_SUBTYPE_SH7722
 	select CPU_SHX2
 	select ARCH_SHMOBILE
 	select ARCH_SPARSEMEM_ENABLE
+	select SYS_SUPPORTS_SMP
+	select SMP
 	select SYS_SUPPORTS_NUMA
 	select SYS_SUPPORTS_SH_CMT
 	select PINCTRL
@@ -486,6 +490,8 @@ config CPU_SUBTYPE_SH7366
 	select CPU_SHX2
 	select ARCH_SHMOBILE
 	select ARCH_SPARSEMEM_ENABLE
+	select SYS_SUPPORTS_SMP
+	select SMP
 	select SYS_SUPPORTS_NUMA
 	select SYS_SUPPORTS_SH_CMT
 
