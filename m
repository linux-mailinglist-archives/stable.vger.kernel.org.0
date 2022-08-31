Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546DE5A7506
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 06:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiHaEZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 00:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiHaEZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 00:25:16 -0400
X-Greylist: delayed 456 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 30 Aug 2022 21:25:04 PDT
Received: from mail.avm.de (mail.avm.de [IPv6:2001:bf0:244:244::120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFB01A82F
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 21:25:03 -0700 (PDT)
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
        by mail.avm.de (Postfix) with ESMTPS;
        Wed, 31 Aug 2022 06:17:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
        t=1661919446; bh=RtxEuZ+wckvXMmGsj3oIdjnMgNf3m08GWQ7vjVjyvc8=;
        h=From:To:Cc:Subject:Date:From;
        b=KzFs+Ew7aEouI91lBJWG1uYTm9ri2KgeVfSRu0aZI5993xtzfsMCzhFFprolKoWac
         Nh1DViDFXEu4y2CtRid7lPCb93tpGkbU1Nor7r0epxUWOTO105jNEacBspfn8dsYtQ
         thgyWLVQNRp9ZJsyWu5MnlhpdqK4sLYhl79nh4MA=
Received: from buildd.core.avm.de (buildd-sv-01.avm.de [172.16.0.225])
        by mail-auth.avm.de (Postfix) with ESMTPA id 8BA6B8068E;
        Wed, 31 Aug 2022 06:17:27 +0200 (CEST)
Received: by buildd.core.avm.de (Postfix, from userid 1000)
        id 87686181E38; Wed, 31 Aug 2022 06:17:27 +0200 (CEST)
From:   Nicolas Schier <n.schier@avm.de>
To:     stable@vger.kernel.org
Cc:     Jing Leng <jleng@ambarella.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <n.schier@avm.de>
Subject: [PATCH 4.9/4.14/4.19] kbuild: Fix include path in scripts/Makefile.modpost
Date:   Wed, 31 Aug 2022 06:17:26 +0200
Message-Id: <20220831041726.1493298-1-n.schier@avm.de>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-purgate-ID: 149429::1661919446-AD71B03E-F9138E1B/0/0
X-purgate-type: clean
X-purgate-size: 1601
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate: clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
---
 scripts/Makefile.modpost | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 51884c7b8069..4eac2ecb35fb 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -51,8 +51,7 @@ obj := $(KBUILD_EXTMOD)
 src := $(obj)
 
 # Include the module's Makefile to find KBUILD_EXTRA_SYMBOLS
-include $(if $(wildcard $(KBUILD_EXTMOD)/Kbuild), \
-             $(KBUILD_EXTMOD)/Kbuild, $(KBUILD_EXTMOD)/Makefile)
+include $(if $(wildcard $(src)/Kbuild), $(src)/Kbuild, $(src)/Makefile)
 endif
 
 include scripts/Makefile.lib
-- 
2.37.2

