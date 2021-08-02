Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1CA3DD852
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234426AbhHBNvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:51:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234873AbhHBNuW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:50:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7224361101;
        Mon,  2 Aug 2021 13:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912212;
        bh=fvodgirbJz/RQvpMeDVfNe4kWcq9jASI9+NFQyIHmVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yg4wX2oJnfMGUcI0lO2hpAR8Wf28eZ6ORcJdjrHi5DXSV74kr8uXVrwhsoXQrrTE/
         FKLMlwiFjCYHmmAdWRwhUzYxRFKjfoGMqZlqQJD/qHkSnNmQ09BMg7E0wFicYh9IR4
         I5nykG1SC35HgEjh+dTmujqP4oSHy6SqUhSZmiT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, marc.c.dionne@gmail.com,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 28/30] powerpc/pseries: Fix regression while building external modules
Date:   Mon,  2 Aug 2021 15:45:06 +0200
Message-Id: <20210802134334.991094715@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134334.081433902@linuxfoundation.org>
References: <20210802134334.081433902@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

commit 333cf507465fbebb3727f5b53e77538467df312a upstream.

With commit c9f3401313a5 ("powerpc: Always enable queued spinlocks for
64s, disable for others") CONFIG_PPC_QUEUED_SPINLOCKS is always
enabled on ppc64le, external modules that use spinlock APIs are
failing.

  ERROR: modpost: GPL-incompatible module XXX.ko uses GPL-only symbol 'shared_processor'

Before the above commit, modules were able to build without any
issues. Also this problem is not seen on other architectures. This
problem can be workaround if CONFIG_UNINLINE_SPIN_UNLOCK is enabled in
the config. However CONFIG_UNINLINE_SPIN_UNLOCK is not enabled by
default and only enabled in certain conditions like
CONFIG_DEBUG_SPINLOCKS is set in the kernel config.

  #include <linux/module.h>
  spinlock_t spLock;

  static int __init spinlock_test_init(void)
  {
          spin_lock_init(&spLock);
          spin_lock(&spLock);
          spin_unlock(&spLock);
          return 0;
  }

  static void __exit spinlock_test_exit(void)
  {
  	printk("spinlock_test unloaded\n");
  }
  module_init(spinlock_test_init);
  module_exit(spinlock_test_exit);

  MODULE_DESCRIPTION ("spinlock_test");
  MODULE_LICENSE ("non-GPL");
  MODULE_AUTHOR ("Srikar Dronamraju");

Given that spin locks are one of the basic facilities for module code,
this effectively makes it impossible to build/load almost any non GPL
modules on ppc64le.

This was first reported at https://github.com/openzfs/zfs/issues/11172

Currently shared_processor is exported as GPL only symbol.
Fix this for parity with other architectures by exposing
shared_processor to non-GPL modules too.

Fixes: 14c73bd344da ("powerpc/vcpu: Assume dedicated processors as non-preempt")
Cc: stable@vger.kernel.org # v5.5+
Reported-by: marc.c.dionne@gmail.com
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210729060449.292780-1-srikar@linux.vnet.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -76,7 +76,7 @@
 #include "../../../../drivers/pci/pci.h"
 
 DEFINE_STATIC_KEY_FALSE(shared_processor);
-EXPORT_SYMBOL_GPL(shared_processor);
+EXPORT_SYMBOL(shared_processor);
 
 int CMO_PrPSP = -1;
 int CMO_SecPSP = -1;


