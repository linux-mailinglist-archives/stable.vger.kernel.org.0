Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2091859D342
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242078AbiHWIMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242168AbiHWIKt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:10:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2465B6A49A;
        Tue, 23 Aug 2022 01:08:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0594B81C17;
        Tue, 23 Aug 2022 08:08:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04F8C433D7;
        Tue, 23 Aug 2022 08:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242080;
        bh=teKc3lF5mfoEsKS9IbpH7Y4FTQyLnvHdoT5FLMkSxxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c0+QzzjjVNetgG9FuSWeDhNMoxdLtDXwfa5km2KVvO39IxGi6o6hFCow0nCHbfJZq
         oYPXTUzCbMUfvC+nV7n+GzEVphH88XJoa3kRqnq1lN7EpImTtJbISfjX2d8wweRvPa
         9a2pL2VNILayqt83ZM4CWC5/t84KOQr/VjS27Orw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Yury Norov <yury.norov@gmail.com>,
        Allison Randal <allison@lohutok.net>,
        Joe Perches <joe@perches.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Torsten Hilbrich <torsten.hilbrich@secunet.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
Subject: [PATCH 4.9 016/101] include/uapi/linux/swab.h: fix userspace breakage, use __BITS_PER_LONG for swap
Date:   Tue, 23 Aug 2022 10:02:49 +0200
Message-Id: <20220823080035.188734677@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit 467d12f5c7842896d2de3ced74e4147ee29e97c8 upstream.

QEMU has a funny new build error message when I use the upstream kernel
headers:

      CC      block/file-posix.o
    In file included from /home/cborntra/REPOS/qemu/include/qemu/timer.h:4,
                     from /home/cborntra/REPOS/qemu/include/qemu/timed-average.h:29,
                     from /home/cborntra/REPOS/qemu/include/block/accounting.h:28,
                     from /home/cborntra/REPOS/qemu/include/block/block_int.h:27,
                     from /home/cborntra/REPOS/qemu/block/file-posix.c:30:
    /usr/include/linux/swab.h: In function `__swab':
    /home/cborntra/REPOS/qemu/include/qemu/bitops.h:20:34: error: "sizeof" is not defined, evaluates to 0 [-Werror=undef]
       20 | #define BITS_PER_LONG           (sizeof (unsigned long) * BITS_PER_BYTE)
          |                                  ^~~~~~
    /home/cborntra/REPOS/qemu/include/qemu/bitops.h:20:41: error: missing binary operator before token "("
       20 | #define BITS_PER_LONG           (sizeof (unsigned long) * BITS_PER_BYTE)
          |                                         ^
    cc1: all warnings being treated as errors
    make: *** [/home/cborntra/REPOS/qemu/rules.mak:69: block/file-posix.o] Error 1
    rm tests/qemu-iotests/socket_scm_helper.o

This was triggered by commit d5767057c9a ("uapi: rename ext2_swab() to
swab() and share globally in swab.h").  That patch is doing

  #include <asm/bitsperlong.h>

but it uses BITS_PER_LONG.

The kernel file asm/bitsperlong.h provide only __BITS_PER_LONG.

Let us use the __ variant in swap.h

Link: http://lkml.kernel.org/r/20200213142147.17604-1-borntraeger@de.ibm.com
Fixes: d5767057c9a ("uapi: rename ext2_swab() to swab() and share globally in swab.h")
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: Allison Randal <allison@lohutok.net>
Cc: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: William Breathitt Gray <vilhelm.gray@gmail.com>
Cc: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Hans-Christian Noren Egtvedt <hegtvedt@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/swab.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/uapi/linux/swab.h
+++ b/include/uapi/linux/swab.h
@@ -134,9 +134,9 @@ static inline __attribute_const__ __u32
 
 static __always_inline unsigned long __swab(const unsigned long y)
 {
-#if BITS_PER_LONG == 64
+#if __BITS_PER_LONG == 64
 	return __swab64(y);
-#else /* BITS_PER_LONG == 32 */
+#else /* __BITS_PER_LONG == 32 */
 	return __swab32(y);
 #endif
 }


