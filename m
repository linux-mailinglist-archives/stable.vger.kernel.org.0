Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A39276B48AF
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233772AbjCJPFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233900AbjCJPFE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:05:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00F76FFF6;
        Fri, 10 Mar 2023 06:58:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3842F61A60;
        Fri, 10 Mar 2023 14:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21271C4339B;
        Fri, 10 Mar 2023 14:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460207;
        bh=0c03yv2yV54bjuZYZpO/e8nXYQRtPfKHOb0arqMEtQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yggWlCvC3WriYxmHeA6kkcuUv0tSTnPsLhNe+xL4mHYvlJDUP9mC8mhCYLuHEX6OE
         BW0JR/Ao53upf2fhBQfeGgqkAoRG0i+2tAo4GM6876Gmg+JwJNSkK1w/hRJ0tsiJxj
         26l38K9aKnNu5vOETlIfDPOvjMW8DjaIxvmyVmmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Dengcheng Zhu <dzhu@wavecomp.com>,
        John Crispin <john@phrozen.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        "Steven J. Hill" <Steven.Hill@imgtec.com>,
        Qais Yousef <Qais.Yousef@imgtec.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 259/529] MIPS: vpe-mt: drop physical_memsize
Date:   Fri, 10 Mar 2023 14:36:42 +0100
Message-Id: <20230310133816.965801835@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 91dc288f4edf0d768e46c2c6d33e0ab703403459 ]

When neither LANTIQ nor MIPS_MALTA is set, 'physical_memsize' is not
declared. This causes the build to fail with:

mips-linux-ld: arch/mips/kernel/vpe-mt.o: in function `vpe_run':
arch/mips/kernel/vpe-mt.c:(.text.vpe_run+0x280): undefined reference to `physical_memsize'

LANTIQ is not using 'physical_memsize' and MIPS_MALTA's use of it is
self-contained in mti-malta/malta-dtshim.c.
Use of physical_memsize in vpe-mt.c appears to be unused, so eliminate
this loader mode completely and require VPE programs to be compiled with
DFLT_STACK_SIZE and DFLT_HEAP_SIZE defined.

Fixes: 9050d50e2244 ("MIPS: lantiq: Set physical_memsize")
Fixes: 1a2a6d7e8816 ("MIPS: APRP: Split VPE loader into separate files.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/all/202302030625.2g3E98sY-lkp@intel.com/
Cc: Dengcheng Zhu <dzhu@wavecomp.com>
Cc: John Crispin <john@phrozen.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Philippe Mathieu-Daudé <philmd@linaro.org>
Cc: "Steven J. Hill" <Steven.Hill@imgtec.com>
Cc: Qais Yousef <Qais.Yousef@imgtec.com>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: James Hogan <jhogan@kernel.org>
Cc: linux-mips@vger.kernel.org
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/vpe.h | 1 -
 arch/mips/kernel/vpe-mt.c   | 7 +++----
 arch/mips/lantiq/prom.c     | 6 ------
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/mips/include/asm/vpe.h b/arch/mips/include/asm/vpe.h
index 80e70dbd1f641..012731546cf60 100644
--- a/arch/mips/include/asm/vpe.h
+++ b/arch/mips/include/asm/vpe.h
@@ -104,7 +104,6 @@ struct vpe_control {
 	struct list_head tc_list;       /* Thread contexts */
 };
 
-extern unsigned long physical_memsize;
 extern struct vpe_control vpecontrol;
 extern const struct file_operations vpe_fops;
 
diff --git a/arch/mips/kernel/vpe-mt.c b/arch/mips/kernel/vpe-mt.c
index 9fd7cd48ea1d2..496ed8f362f62 100644
--- a/arch/mips/kernel/vpe-mt.c
+++ b/arch/mips/kernel/vpe-mt.c
@@ -92,12 +92,11 @@ int vpe_run(struct vpe *v)
 	write_tc_c0_tchalt(read_tc_c0_tchalt() & ~TCHALT_H);
 
 	/*
-	 * The sde-kit passes 'memsize' to __start in $a3, so set something
-	 * here...  Or set $a3 to zero and define DFLT_STACK_SIZE and
-	 * DFLT_HEAP_SIZE when you compile your program
+	 * We don't pass the memsize here, so VPE programs need to be
+	 * compiled with DFLT_STACK_SIZE and DFLT_HEAP_SIZE defined.
 	 */
+	mttgpr(7, 0);
 	mttgpr(6, v->ntcs);
-	mttgpr(7, physical_memsize);
 
 	/* set up VPE1 */
 	/*
diff --git a/arch/mips/lantiq/prom.c b/arch/mips/lantiq/prom.c
index 3f568f5aae2d1..2729a4b63e187 100644
--- a/arch/mips/lantiq/prom.c
+++ b/arch/mips/lantiq/prom.c
@@ -22,12 +22,6 @@
 DEFINE_SPINLOCK(ebu_lock);
 EXPORT_SYMBOL_GPL(ebu_lock);
 
-/*
- * This is needed by the VPE loader code, just set it to 0 and assume
- * that the firmware hardcodes this value to something useful.
- */
-unsigned long physical_memsize = 0L;
-
 /*
  * this struct is filled by the soc specific detection code and holds
  * information about the specific soc type, revision and name
-- 
2.39.2



