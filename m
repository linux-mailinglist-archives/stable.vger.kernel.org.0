Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2956A64E2AB
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 21:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiLOU7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 15:59:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiLOU7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 15:59:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51CF54364;
        Thu, 15 Dec 2022 12:59:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 170E561F20;
        Thu, 15 Dec 2022 20:59:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72051C433EF;
        Thu, 15 Dec 2022 20:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671137979;
        bh=aaj88OBy6RA6IAm2Gbs7UT8naRH5VZXH1KM9oreYnP4=;
        h=Date:To:From:Subject:From;
        b=VIbMOApoBQqb73tFwFTJjvKN/Q1gw+cNivWg3MnXMkC46sFOJIxSZgonPEFoJjIVn
         hHVnuIvSmRHb6mLSAUZ8zSCwxZr2yV09cP3+IhIpd9wy/eFiB7DpcQRhSktpvB5cyQ
         KWQ7m6DUsYsjJO65qjpoAhdVA/E37MEgFMdein1Q=
Date:   Thu, 15 Dec 2022 12:59:38 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        glider@google.com, elver@google.com, dvyukov@google.com,
        arnd@arndb.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-export-kmsan_handle_urb.patch added to mm-hotfixes-unstable branch
Message-Id: <20221215205939.72051C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: kmsan: export kmsan_handle_urb
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kmsan-export-kmsan_handle_urb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-export-kmsan_handle_urb.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kmsan: export kmsan_handle_urb
Date: Thu, 15 Dec 2022 17:26:57 +0100

USB support can be in a loadable module, and this causes a link failure
with KMSAN:

ERROR: modpost: "kmsan_handle_urb" [drivers/usb/core/usbcore.ko] undefined!

Export the symbol so it can be used by this module.

Link: https://lkml.kernel.org/r/20221215162710.3802378-1-arnd@kernel.org
Fixes: 553a80188a5d ("kmsan: handle memory sent to/from USB")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/hooks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kmsan/hooks.c~kmsan-export-kmsan_handle_urb
+++ a/mm/kmsan/hooks.c
@@ -260,6 +260,7 @@ void kmsan_handle_urb(const struct urb *
 					       urb->transfer_buffer_length,
 					       /*checked*/ false);
 }
+EXPORT_SYMBOL_GPL(kmsan_handle_urb);
 
 static void kmsan_handle_dma_page(const void *addr, size_t size,
 				  enum dma_data_direction dir)
_

Patches currently in -mm which might be from arnd@arndb.de are

kmsan-include-linux-vmalloch.patch
kmsan-export-kmsan_handle_urb.patch

