Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA29556F9C3
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiGKJIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbiGKJH5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:07:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7522824BD1;
        Mon, 11 Jul 2022 02:07:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 140F461183;
        Mon, 11 Jul 2022 09:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24217C34115;
        Mon, 11 Jul 2022 09:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530454;
        bh=K6jNGp2dUuNiWhAggovJ4j01QWBZArB13C35cE1qd8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m2fov78FFlOSy9i4P6VekJJqeiT4gKFzmb2fvrqTyNiRLbEJyNX/cjxDddxzUimnN
         0Vk85lvMH98rACAMcIIwLh9O4lg8SOuzBOa40hZJxYOWpldVGdYdZrwUR02SfqPiI8
         LYwqEGw67seDOqgmdq+rotfYR1ZBMMklQb5k1o+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sachin Sant <sachinp@linux.ibm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.14 10/17] powerpc/powernv: delay rng platform device creation until later in boot
Date:   Mon, 11 Jul 2022 11:06:35 +0200
Message-Id: <20220711090536.567996594@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090536.245939953@linuxfoundation.org>
References: <20220711090536.245939953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 887502826549caa7e4215fd9e628f48f14c0825a upstream.

The platform device for the rng must be created much later in boot.
Otherwise it tries to connect to a parent that doesn't yet exist,
resulting in this splat:

  [    0.000478] kobject: '(null)' ((____ptrval____)): is not initialized, yet kobject_get() is being called.
  [    0.002925] [c000000002a0fb30] [c00000000073b0bc] kobject_get+0x8c/0x100 (unreliable)
  [    0.003071] [c000000002a0fba0] [c00000000087e464] device_add+0xf4/0xb00
  [    0.003194] [c000000002a0fc80] [c000000000a7f6e4] of_device_add+0x64/0x80
  [    0.003321] [c000000002a0fcb0] [c000000000a800d0] of_platform_device_create_pdata+0xd0/0x1b0
  [    0.003476] [c000000002a0fd00] [c00000000201fa44] pnv_get_random_long_early+0x240/0x2e4
  [    0.003623] [c000000002a0fe20] [c000000002060c38] random_init+0xc0/0x214

This patch fixes the issue by doing the platform device creation inside
of machine_subsys_initcall.

Fixes: f3eac426657d ("powerpc/powernv: wire up rng during setup_arch")
Cc: stable@vger.kernel.org
Reported-by: Sachin Sant <sachinp@linux.ibm.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Tested-by: Sachin Sant <sachinp@linux.ibm.com>
[mpe: Change "of node" to "platform device" in change log]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220630121654.1939181-1-Jason@zx2c4.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/powernv/rng.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/arch/powerpc/platforms/powernv/rng.c
+++ b/arch/powerpc/platforms/powernv/rng.c
@@ -176,12 +176,8 @@ static int __init pnv_get_random_long_ea
 		    NULL) != pnv_get_random_long_early)
 		return 0;
 
-	for_each_compatible_node(dn, NULL, "ibm,power-rng") {
-		if (rng_create(dn))
-			continue;
-		/* Create devices for hwrng driver */
-		of_platform_device_create(dn, NULL, NULL);
-	}
+	for_each_compatible_node(dn, NULL, "ibm,power-rng")
+		rng_create(dn);
 
 	if (!ppc_md.get_random_seed)
 		return 0;
@@ -205,10 +201,18 @@ void __init pnv_rng_init(void)
 
 static int __init pnv_rng_late_init(void)
 {
+	struct device_node *dn;
 	unsigned long v;
+
 	/* In case it wasn't called during init for some other reason. */
 	if (ppc_md.get_random_seed == pnv_get_random_long_early)
 		pnv_get_random_long_early(&v);
+
+	if (ppc_md.get_random_seed == powernv_get_random_long) {
+		for_each_compatible_node(dn, NULL, "ibm,power-rng")
+			of_platform_device_create(dn, NULL, NULL);
+	}
+
 	return 0;
 }
 machine_subsys_initcall(powernv, pnv_rng_late_init);


