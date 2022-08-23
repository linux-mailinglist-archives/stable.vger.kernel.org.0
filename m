Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B4F59E0BA
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352684AbiHWKNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353208AbiHWKLD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:11:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C743F7E330;
        Tue, 23 Aug 2022 01:56:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABF34614E7;
        Tue, 23 Aug 2022 08:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCA7C433C1;
        Tue, 23 Aug 2022 08:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244972;
        bh=kGnKy4ot8MT8zCT9ellggAB0zIaX/bDGSKngr+K3OEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HAHpxZ4yp9vXmGp+3I4b3o7MTsI0nQfY0M5IsP5An2cdAJOBRjfaXS97S37nP0sSk
         3i8TkIFQBEbgiylTUHqtZdZseytkY7sSFnn1jF7RTPybYN95ad5i3vRJHMNST+G83y
         aBfDki3hR3ge7qmDH7wIfqDrAaPwvlvmKydJqZmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yury Norov <yury.norov@gmail.com>,
        Erhard Furtner <erhard_f@mailbox.org>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.15 152/244] gcc-plugins: Undefine LATENT_ENTROPY_PLUGIN when plugin disabled for a file
Date:   Tue, 23 Aug 2022 10:25:11 +0200
Message-Id: <20220823080104.259578002@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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

From: Andrew Donnellan <ajd@linux.ibm.com>

commit 012e8d2034f1bda8863435cd589636e618d6a659 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile.gcc-plugins |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -6,7 +6,7 @@ gcc-plugin-$(CONFIG_GCC_PLUGIN_LATENT_EN
 gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_LATENT_ENTROPY)		\
 		+= -DLATENT_ENTROPY_PLUGIN
 ifdef CONFIG_GCC_PLUGIN_LATENT_ENTROPY
-    DISABLE_LATENT_ENTROPY_PLUGIN += -fplugin-arg-latent_entropy_plugin-disable
+    DISABLE_LATENT_ENTROPY_PLUGIN += -fplugin-arg-latent_entropy_plugin-disable -ULATENT_ENTROPY_PLUGIN
 endif
 export DISABLE_LATENT_ENTROPY_PLUGIN
 


