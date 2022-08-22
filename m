Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D717D59C006
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 15:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbiHVNDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 09:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234756AbiHVNDQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 09:03:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688AB308
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 06:03:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 279D7B811D7
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 13:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84116C433C1;
        Mon, 22 Aug 2022 13:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661173392;
        bh=kSuH6EJXr1hu8iKCXNDP+Z5Fvq6wYBqKayqYTan5x5A=;
        h=Subject:To:Cc:From:Date:From;
        b=2XiqRzsZ5EsMukVaITSzVr8aO81bIeGzyLSViGMnd52TawGArQOzB8LAE9/ki4uXJ
         TtMZvhdo3acPCiTmMCICHibq5mywk1pZL9gpMlLkZEtSzqnvAJAMoRjZDfQ8KqhhVA
         mkzUcZhplc8CpNtOHQyj3tCwn9Fx0+/rfIjci66k=
Subject: FAILED: patch "[PATCH] gcc-plugins: Undefine LATENT_ENTROPY_PLUGIN when plugin" failed to apply to 4.14-stable tree
To:     ajd@linux.ibm.com, erhard_f@mailbox.org, keescook@chromium.org,
        yury.norov@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 15:03:10 +0200
Message-ID: <16611733905943@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 012e8d2034f1bda8863435cd589636e618d6a659 Mon Sep 17 00:00:00 2001
From: Andrew Donnellan <ajd@linux.ibm.com>
Date: Tue, 16 Aug 2022 15:17:20 +1000
Subject: [PATCH] gcc-plugins: Undefine LATENT_ENTROPY_PLUGIN when plugin
 disabled for a file

Commit 36d4b36b6959 ("lib/nodemask: inline next_node_in() and
node_random()") refactored some code by moving node_random() from
lib/nodemask.c to include/linux/nodemask.h, thus requiring nodemask.h to
include random.h, which conditionally defines add_latent_entropy()
depending on whether the macro LATENT_ENTROPY_PLUGIN is defined.

This broke the build on powerpc, where nodemask.h is indirectly included
in arch/powerpc/kernel/prom_init.c, part of the early boot machinery that
is excluded from the latent entropy plugin using
DISABLE_LATENT_ENTROPY_PLUGIN. It turns out that while we add a gcc flag
to disable the actual plugin, we don't undefine LATENT_ENTROPY_PLUGIN.

This leads to the following:

    CC      arch/powerpc/kernel/prom_init.o
  In file included from ./include/linux/nodemask.h:97,
                   from ./include/linux/mmzone.h:17,
                   from ./include/linux/gfp.h:7,
                   from ./include/linux/xarray.h:15,
                   from ./include/linux/radix-tree.h:21,
                   from ./include/linux/idr.h:15,
                   from ./include/linux/kernfs.h:12,
                   from ./include/linux/sysfs.h:16,
                   from ./include/linux/kobject.h:20,
                   from ./include/linux/pci.h:35,
                   from arch/powerpc/kernel/prom_init.c:24:
  ./include/linux/random.h: In function 'add_latent_entropy':
  ./include/linux/random.h:25:46: error: 'latent_entropy' undeclared (first use in this function); did you mean 'add_latent_entropy'?
     25 |         add_device_randomness((const void *)&latent_entropy, sizeof(latent_entropy));
        |                                              ^~~~~~~~~~~~~~
        |                                              add_latent_entropy
  ./include/linux/random.h:25:46: note: each undeclared identifier is reported only once for each function it appears in
  make[2]: *** [scripts/Makefile.build:249: arch/powerpc/kernel/prom_init.o] Fehler 1
  make[1]: *** [scripts/Makefile.build:465: arch/powerpc/kernel] Fehler 2
  make: *** [Makefile:1855: arch/powerpc] Error 2

Change the DISABLE_LATENT_ENTROPY_PLUGIN flags to undefine
LATENT_ENTROPY_PLUGIN for files where the plugin is disabled.

Cc: Yury Norov <yury.norov@gmail.com>
Fixes: 38addce8b600 ("gcc-plugins: Add latent_entropy plugin")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216367
Link: https://lore.kernel.org/linuxppc-dev/alpine.DEB.2.22.394.2208152006320.289321@ramsan.of.borg/
Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220816051720.44108-1-ajd@linux.ibm.com

diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index 692d64a70542..e4deaf5fa571 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -4,7 +4,7 @@ gcc-plugin-$(CONFIG_GCC_PLUGIN_LATENT_ENTROPY)	+= latent_entropy_plugin.so
 gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_LATENT_ENTROPY)		\
 		+= -DLATENT_ENTROPY_PLUGIN
 ifdef CONFIG_GCC_PLUGIN_LATENT_ENTROPY
-    DISABLE_LATENT_ENTROPY_PLUGIN += -fplugin-arg-latent_entropy_plugin-disable
+    DISABLE_LATENT_ENTROPY_PLUGIN += -fplugin-arg-latent_entropy_plugin-disable -ULATENT_ENTROPY_PLUGIN
 endif
 export DISABLE_LATENT_ENTROPY_PLUGIN
 

