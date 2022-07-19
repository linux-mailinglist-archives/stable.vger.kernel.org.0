Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1805579DB9
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242603AbiGSMyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242057AbiGSMxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:53:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47AD91CF5;
        Tue, 19 Jul 2022 05:21:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C58E86183D;
        Tue, 19 Jul 2022 12:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6070C341C6;
        Tue, 19 Jul 2022 12:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233260;
        bh=YiegBnLb7fzcdAG/9lSyNYztOpy0PPrHib+C+dJG+4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GjQkwO8sLoCAlIw1paD6lj9l4+rdfpin+FAT/aw+8NmIGuQsb4Xyujj9qti25xQMl
         GLQ0IX7Q0H/V7RVLnueORGuBUil9cFy0N6w8a3iI5XsrqmOO0mYxJlfEU9Y+zaLrHR
         RDdasUdAujp0LaHs9MlHJ2VgP7UBfkoYPY53Dc3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        kernel test robot <lkp@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.18 033/231] sh: convert nommu io{re,un}map() to static inline functions
Date:   Tue, 19 Jul 2022 13:51:58 +0200
Message-Id: <20220719114716.896280861@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit d684e0a52d36f8939eda30a0f31ee235ee4ee741 upstream.

Recently, nommu iounmap() was converted from a static inline function to a
macro again, basically reverting commit 4580ba4ad2e6b8dd ("sh: Convert
iounmap() macros to inline functions").  With -Werror, this leads to build
failures like:

    drivers/iio/adc/xilinx-ams.c: In function `ams_iounmap_ps':
    drivers/iio/adc/xilinx-ams.c:1195:14: error: unused variable `ams' [-Werror=unused-variable]
     1195 |  struct ams *ams = data;
	  |              ^~~

Fix this by replacing the macros for ioremap() and iounmap() by static
inline functions, based on <asm-generic/io.h>.

Link: https://lkml.kernel.org/r/8d1b1766260961799b04035e7bc39a7f59729f72.1655708312.git.geert+renesas@glider.be
Fixes: 13f1fc870dd74713 ("sh: move the ioremap implementation out of line")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sh/include/asm/io.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/sh/include/asm/io.h
+++ b/arch/sh/include/asm/io.h
@@ -271,8 +271,12 @@ static inline void __iomem *ioremap_prot
 #endif /* CONFIG_HAVE_IOREMAP_PROT */
 
 #else /* CONFIG_MMU */
-#define iounmap(addr)		do { } while (0)
-#define ioremap(offset, size)	((void __iomem *)(unsigned long)(offset))
+static inline void __iomem *ioremap(phys_addr_t offset, size_t size)
+{
+	return (void __iomem *)(unsigned long)offset;
+}
+
+static inline void iounmap(volatile void __iomem *addr) { }
 #endif /* CONFIG_MMU */
 
 #define ioremap_uc	ioremap


