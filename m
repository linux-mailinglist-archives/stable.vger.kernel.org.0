Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5164BDCA3
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348926AbiBUJXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:23:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349062AbiBUJU7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:20:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F9731536;
        Mon, 21 Feb 2022 01:07:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C88D9608C1;
        Mon, 21 Feb 2022 09:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C79C340E9;
        Mon, 21 Feb 2022 09:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434469;
        bh=QVHi1Fo2w+5SF4nm3Aba/ncolOFBS7ktXZEtqMSRG1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Je/OBJ4bkjTBP54eVGFhMVz+f34G2cZ7DVrPbLHfRlS8xWm0ORDJDTuUTnzLtmSoQ
         VDdFTiEF2qPH6GJWKzTo2Mn5rQ5u0ttqlYbHLRg/uqnu+MM4lWxtxA5d/qg8H2O4Dd
         otXyzWaym3Qca+8cmvU53+LkMwSkQb/ZagN5FF2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 019/196] parisc: Add ioread64_lo_hi() and iowrite64_lo_hi()
Date:   Mon, 21 Feb 2022 09:47:31 +0100
Message-Id: <20220221084931.536620132@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 18a1d5e1945385d9b5adc3fe11427ce4a9d2826e upstream.

It's a followup to the previous commit f15309d7ad5d ("parisc: Add
ioread64_hi_lo() and iowrite64_hi_lo()") which does only half of
the job. Add the rest, so we won't get a new kernel test robot
reports.

Fixes: f15309d7ad5d ("parisc: Add ioread64_hi_lo() and iowrite64_hi_lo()")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/lib/iomap.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/arch/parisc/lib/iomap.c
+++ b/arch/parisc/lib/iomap.c
@@ -346,6 +346,16 @@ u64 ioread64be(const void __iomem *addr)
 	return *((u64 *)addr);
 }
 
+u64 ioread64_lo_hi(const void __iomem *addr)
+{
+	u32 low, high;
+
+	low = ioread32(addr);
+	high = ioread32(addr + sizeof(u32));
+
+	return low + ((u64)high << 32);
+}
+
 u64 ioread64_hi_lo(const void __iomem *addr)
 {
 	u32 low, high;
@@ -419,6 +429,12 @@ void iowrite64be(u64 datum, void __iomem
 	}
 }
 
+void iowrite64_lo_hi(u64 val, void __iomem *addr)
+{
+	iowrite32(val, addr);
+	iowrite32(val >> 32, addr + sizeof(u32));
+}
+
 void iowrite64_hi_lo(u64 val, void __iomem *addr)
 {
 	iowrite32(val >> 32, addr + sizeof(u32));
@@ -530,6 +546,7 @@ EXPORT_SYMBOL(ioread32);
 EXPORT_SYMBOL(ioread32be);
 EXPORT_SYMBOL(ioread64);
 EXPORT_SYMBOL(ioread64be);
+EXPORT_SYMBOL(ioread64_lo_hi);
 EXPORT_SYMBOL(ioread64_hi_lo);
 EXPORT_SYMBOL(iowrite8);
 EXPORT_SYMBOL(iowrite16);
@@ -538,6 +555,7 @@ EXPORT_SYMBOL(iowrite32);
 EXPORT_SYMBOL(iowrite32be);
 EXPORT_SYMBOL(iowrite64);
 EXPORT_SYMBOL(iowrite64be);
+EXPORT_SYMBOL(iowrite64_lo_hi);
 EXPORT_SYMBOL(iowrite64_hi_lo);
 EXPORT_SYMBOL(ioread8_rep);
 EXPORT_SYMBOL(ioread16_rep);


