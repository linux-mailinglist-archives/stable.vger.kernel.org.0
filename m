Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428E46AB539
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 05:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjCFEA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 23:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjCFEAp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 23:00:45 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC51F74B;
        Sun,  5 Mar 2023 20:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=4aGYejjB597mgiQZIbHKlJkYyDrDVt5t4jYswvUz7/M=; b=OGEUSvE17nE6gU+pUUq4hEqpoa
        Ludgfh7fJs61WUf5u/2uSYLU+lQ/wyKkfoyDx0FifHJhGiXPghTR7cbmPai7MVZOU9xOGp998pGma
        ro3fYBGeqoHPjxb0p7JKxpK2fPceIlBcp91CzdL1tKJHrp7aF2Nbpu45KnS8elOfWMQt+Jm4TiHjq
        vtySjfLRKe+E6dK5LIpyOBdHnMTEF63qYOsdak60oa3JiSkrLmoBUhXVpmDeu68E0Iuck5MV+RT6j
        sBhy/PWK6yiDgzPS6CmhtG1++1gu79FgwUWQRcjFDFVX23gFmmvbzIFlGUyQ5rYZ494EIP0mwqiWX
        Ilm8HaJg==;
Received: from [2601:1c2:980:9ec0::df2f] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pZ21i-00B9yD-Oc; Mon, 06 Mar 2023 04:00:42 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 6/7 v4] sh: fix Kconfig entry for NUMA => SMP
Date:   Sun,  5 Mar 2023 20:00:36 -0800
Message-Id: <20230306040037.20350-7-rdunlap@infradead.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230306040037.20350-1-rdunlap@infradead.org>
References: <20230306040037.20350-1-rdunlap@infradead.org>
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
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: linux-sh@vger.kernel.org
Cc: stable@vger.kernel.org
---
v2: skipped
v3: skipped
v4: refresh & resend

 arch/sh/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

diff -- a/arch/sh/Kconfig b/arch/sh/Kconfig
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -477,6 +477,8 @@ config CPU_SUBTYPE_SH7722
 	select CPU_SHX2
 	select ARCH_SHMOBILE
 	select ARCH_SPARSEMEM_ENABLE
+	select SYS_SUPPORTS_SMP
+	select SMP
 	select SYS_SUPPORTS_NUMA
 	select SYS_SUPPORTS_SH_CMT
 	select PINCTRL
@@ -487,6 +489,8 @@ config CPU_SUBTYPE_SH7366
 	select CPU_SHX2
 	select ARCH_SHMOBILE
 	select ARCH_SPARSEMEM_ENABLE
+	select SYS_SUPPORTS_SMP
+	select SMP
 	select SYS_SUPPORTS_NUMA
 	select SYS_SUPPORTS_SH_CMT
 
