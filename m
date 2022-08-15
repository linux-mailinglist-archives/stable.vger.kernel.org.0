Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC803593E20
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344812AbiHOUhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346029AbiHOUej (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:34:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FE74D803;
        Mon, 15 Aug 2022 12:06:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 943DE61299;
        Mon, 15 Aug 2022 19:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0BDDC433C1;
        Mon, 15 Aug 2022 19:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590378;
        bh=f1QHJkEWBxe0y7ULk3wzJybIZKZvXufJ0WmRnppxYtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AkBMkvzmyZRCgRsybAnR6VBa73mZ0dXecyUeELJEPrZjWutpvrfZRq4wyPthHMR2s
         FshSrVJ/QMyFA5rFpuNEKnQhbaey+BGpAM7RyQl2myx6s518UH9lbg/acjTJRqoqfH
         5a6eRDkjPndc/Mi9xJ3G1/MYvBDZgOAOsDXypF28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Leng <jleng@ambarella.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0241/1095] kbuild: Fix include path in scripts/Makefile.modpost
Date:   Mon, 15 Aug 2022 19:54:00 +0200
Message-Id: <20220815180439.757015907@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

[ Upstream commit 23a0cb8e3225122496bfa79172005c587c2d64bf ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.modpost | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 48585c4d04ad..0273bf7375e2 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -87,8 +87,7 @@ obj := $(KBUILD_EXTMOD)
 src := $(obj)
 
 # Include the module's Makefile to find KBUILD_EXTRA_SYMBOLS
-include $(if $(wildcard $(KBUILD_EXTMOD)/Kbuild), \
-             $(KBUILD_EXTMOD)/Kbuild, $(KBUILD_EXTMOD)/Makefile)
+include $(if $(wildcard $(src)/Kbuild), $(src)/Kbuild, $(src)/Makefile)
 
 # modpost option for external modules
 MODPOST += -e
-- 
2.35.1



