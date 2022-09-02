Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F7E5AAE6E
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235620AbiIBMXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236081AbiIBMWh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:22:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A68D477D;
        Fri,  2 Sep 2022 05:21:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB03AB82A8B;
        Fri,  2 Sep 2022 12:21:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC50C433C1;
        Fri,  2 Sep 2022 12:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121288;
        bh=lFrJ5b/r1x+uUtrX8t1nEyxRMS2asjNZ1cChTPFOAK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kMGuasyU9dO74C5BCFW/0Rp9OZHpF+aXRQ2jKAg83KdXTT7cmaair5zwSekfVjYiN
         WNyFtSWiSkUy2xkQXdiwQK34sjX3RTmFtabDI/FCtwW5Lh8AL71BnvWsuJ5rZlcwS/
         vL14UzKWyA6Sv3mEeQtGQTpp0HVl81nUoWQrb1vQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Leng <jleng@ambarella.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <n.schier@avm.de>
Subject: [PATCH 4.9 21/31] kbuild: Fix include path in scripts/Makefile.modpost
Date:   Fri,  2 Sep 2022 14:18:47 +0200
Message-Id: <20220902121357.540870777@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121356.732130937@linuxfoundation.org>
References: <20220902121356.732130937@linuxfoundation.org>
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

From: Jing Leng <jleng@ambarella.com>

commit 23a0cb8e3225122496bfa79172005c587c2d64bf upstream.

When building an external module, if users don't need to separate the
compilation output and source code, they run the following command:
"make -C $(LINUX_SRC_DIR) M=$(PWD)". At this point, "$(KBUILD_EXTMOD)"
and "$(src)" are the same.

If they need to separate them, they run "make -C $(KERNEL_SRC_DIR)
O=$(KERNEL_OUT_DIR) M=$(OUT_DIR) src=$(PWD)". Before running the
command, they need to copy "Kbuild" or "Makefile" to "$(OUT_DIR)" to
prevent compilation failure.

So the kernel should change the included path to avoid the copy operation.

Signed-off-by: Jing Leng <jleng@ambarella.com>
[masahiro: I do not think "M=$(OUT_DIR) src=$(PWD)" is the official way,
but this patch is a nice clean up anyway.]
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
[nsc: updated context for v4.19]
Signed-off-by: Nicolas Schier <n.schier@avm.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile.modpost |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -50,8 +50,7 @@ obj := $(KBUILD_EXTMOD)
 src := $(obj)
 
 # Include the module's Makefile to find KBUILD_EXTRA_SYMBOLS
-include $(if $(wildcard $(KBUILD_EXTMOD)/Kbuild), \
-             $(KBUILD_EXTMOD)/Kbuild, $(KBUILD_EXTMOD)/Makefile)
+include $(if $(wildcard $(src)/Kbuild), $(src)/Kbuild, $(src)/Makefile)
 endif
 
 include scripts/Makefile.lib


