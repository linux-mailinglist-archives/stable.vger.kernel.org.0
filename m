Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF9B676FBC
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbjAVPYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbjAVPYq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:24:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F5A222FA
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:24:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A6860CE0F4D
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E4CC433EF;
        Sun, 22 Jan 2023 15:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401080;
        bh=xPLwRDrW5IACGkyyuSEBErLQWEoxo9XPIYN11dxvzMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AiYwURVGTrD5rE6bmZbfd0HIb9GLu1rW0hCQjMzZWs6RJrYsuUvs2kfCszGICJCuY
         LM3bY6+TOskSaDidYtGAJhggnsCpLF5Rtz2Na66GFDJDK40u3pkfMEGTmXJBcyHNuI
         onLVWcMr9WyUlnxpoJwCeeVgMoAunZOfsEAa5x98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paul Walmsley <paul.walmsley@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Conor Dooley <conor.dooley@microchip.com>,
        Ron Economos <re@w6rz.net>
Subject: [PATCH 6.1 095/193] riscv: dts: sifive: fu740: fix size of pcie 32bit memory
Date:   Sun, 22 Jan 2023 16:03:44 +0100
Message-Id: <20230122150250.680555960@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
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

From: Ben Dooks <ben.dooks@codethink.co.uk>

commit 43d5f5d63699724d47f0d9e0eae516a260d232b4 upstream.

The 32-bit memory resource is needed for non-prefetchable memory
allocations on the PCIe bus, however with some cards (such as the
SM768) the system fails to allocate memory from this.

Checking the allocation against the datasheet, it looks like there
has been a mis-calcualation of the resource for the first memory
region (0x0060090000..0x0070ffffff) which in the data-sheet for
the fu740 (v1p2) is from 0x0060000000..0x007fffffff. Changing
this to allocate from 0x0060090000..0x007fffffff fixes the probing
issues.

Fixes: ae80d5148085 ("riscv: dts: Add PCIe support for the SiFive FU740-C000 SoC")
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: stable@vger.kernel.org
Tested-by: Ron Economos <re@w6rz.net> # from IRC
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/boot/dts/sifive/fu740-c000.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/boot/dts/sifive/fu740-c000.dtsi
+++ b/arch/riscv/boot/dts/sifive/fu740-c000.dtsi
@@ -328,7 +328,7 @@
 			bus-range = <0x0 0xff>;
 			ranges = <0x81000000  0x0 0x60080000  0x0 0x60080000 0x0 0x10000>,      /* I/O */
 				 <0x82000000  0x0 0x60090000  0x0 0x60090000 0x0 0xff70000>,    /* mem */
-				 <0x82000000  0x0 0x70000000  0x0 0x70000000 0x0 0x1000000>,    /* mem */
+				 <0x82000000  0x0 0x70000000  0x0 0x70000000 0x0 0x10000000>,    /* mem */
 				 <0xc3000000 0x20 0x00000000 0x20 0x00000000 0x20 0x00000000>;  /* mem prefetchable */
 			num-lanes = <0x8>;
 			interrupts = <56>, <57>, <58>, <59>, <60>, <61>, <62>, <63>, <64>;


