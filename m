Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC91C6214C6
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbiKHOFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235020AbiKHOFA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:05:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE6B686B3
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:04:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C9F2611B7
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:04:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80ACFC433D6;
        Tue,  8 Nov 2022 14:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916298;
        bh=tAKWqDKsTA3xWZFdvAdpr5GjxGl/E3+Gq1dQoTETmFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E4cxK0xjuYczifVQcIY2ZYnqxyUYC60oLsOq9Cg7oCUcAM7K8Hwvy1n7+2HLNJZMP
         yhstQloyF4/tndoTxoZ0RXFo9HSe4o8BwvdTtGrvYP3Jp+zcRHgPnuLaSpT/AEJVir
         6qlEZA7xRhnrsN2oc+fiwvYprsfvT8C6NHPyI6yg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 122/144] parisc: Avoid printing the hardware path twice
Date:   Tue,  8 Nov 2022 14:39:59 +0100
Message-Id: <20221108133350.446611709@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 2b6ae0962b421103feb41a80406732944b0665b3 upstream.

Avoid that the hardware path is shown twice in the kernel log, and clean
up the output of the version numbers to show up in the same order as
they are listed in the hardware database in the hardware.c file.
Additionally, optimize the memory footprint of the hardware database
and mark some code as init code.

Fixes: cab56b51ec0e ("parisc: Fix device names in /proc/iomem")
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v4.9+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/hardware.h |   12 ++++++------
 arch/parisc/kernel/drivers.c       |   14 ++++++--------
 2 files changed, 12 insertions(+), 14 deletions(-)

--- a/arch/parisc/include/asm/hardware.h
+++ b/arch/parisc/include/asm/hardware.h
@@ -10,12 +10,12 @@
 #define SVERSION_ANY_ID		PA_SVERSION_ANY_ID
 
 struct hp_hardware {
-	unsigned short	hw_type:5;	/* HPHW_xxx */
-	unsigned short	hversion;
-	unsigned long	sversion:28;
-	unsigned short	opt;
-	const char	name[80];	/* The hardware description */
-};
+	unsigned int	hw_type:8;	/* HPHW_xxx */
+	unsigned int	hversion:12;
+	unsigned int	sversion:12;
+	unsigned char	opt;
+	unsigned char	name[59];	/* The hardware description */
+} __packed;
 
 struct parisc_device;
 
--- a/arch/parisc/kernel/drivers.c
+++ b/arch/parisc/kernel/drivers.c
@@ -882,15 +882,13 @@ void __init walk_central_bus(void)
 			&root);
 }
 
-static void print_parisc_device(struct parisc_device *dev)
+static __init void print_parisc_device(struct parisc_device *dev)
 {
-	char hw_path[64];
-	static int count;
+	static int count __initdata;
 
-	print_pa_hwpath(dev, hw_path);
-	pr_info("%d. %s at %pap [%s] { %d, 0x%x, 0x%.3x, 0x%.5x }",
-		++count, dev->name, &(dev->hpa.start), hw_path, dev->id.hw_type,
-		dev->id.hversion_rev, dev->id.hversion, dev->id.sversion);
+	pr_info("%d. %s at %pap { type:%d, hv:%#x, sv:%#x, rev:%#x }",
+		++count, dev->name, &(dev->hpa.start), dev->id.hw_type,
+		dev->id.hversion, dev->id.sversion, dev->id.hversion_rev);
 
 	if (dev->num_addrs) {
 		int k;
@@ -1079,7 +1077,7 @@ static __init int qemu_print_iodc_data(s
 
 
 
-static int print_one_device(struct device * dev, void * data)
+static __init int print_one_device(struct device * dev, void * data)
 {
 	struct parisc_device * pdev = to_parisc_device(dev);
 


