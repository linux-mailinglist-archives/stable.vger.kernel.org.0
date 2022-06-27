Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5AE55D378
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235429AbiF0L3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235373AbiF0L2t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:28:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC2D65B0;
        Mon, 27 Jun 2022 04:27:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B78E61460;
        Mon, 27 Jun 2022 11:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B6AC3411D;
        Mon, 27 Jun 2022 11:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329251;
        bh=X6teW0KhDjIByImFmOErKxYMhlrwTw+PCdBRdEMHqUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9ML+l9lopt7DhxmQ0niH0RavmkYN/EJzSTq8ijcKTaxhD4yRAyYbzEVBOiPiXKmk
         E71wA7PX0TSbVeVcMk7dQFih7VMlAESUU2lNUd/pc3R6I615KqtzafjgmR8XaUhwZ/
         UUKYbC4XuT+Ypfxp9CgQ/lV2zsNatkoJ+M7y8Hac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 5.10 101/102] kbuild: link vmlinux only once for CONFIG_TRIM_UNUSED_KSYMS (2nd attempt)
Date:   Mon, 27 Jun 2022 13:21:52 +0200
Message-Id: <20220627111936.461651583@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
References: <20220627111933.455024953@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 53632ba87d9f302a8d97a11ec2f4f4eec7bb75ea upstream.

If CONFIG_TRIM_UNUSED_KSYMS is enabled and the kernel is built from
a pristine state, the vmlinux is linked twice.

Commit 3fdc7d3fe4c0 ("kbuild: link vmlinux only once for
CONFIG_TRIM_UNUSED_KSYMS") explains why this happens, but it did not fix
the issue at all.

Now I realized I had applied a wrong patch.

In v1 patch [1], the autoksyms_recursive target correctly recurses to
"$(MAKE) -f $(srctree)/Makefile autoksyms_recursive".

In v2 patch [2], I accidentally dropped the diff line, and it recurses to
"$(MAKE) -f $(srctree)/Makefile vmlinux".

Restore the code I intended in v1.

[1]: https://lore.kernel.org/linux-kbuild/1521045861-22418-8-git-send-email-yamada.masahiro@socionext.com/
[2]: https://lore.kernel.org/linux-kbuild/1521166725-24157-8-git-send-email-yamada.masahiro@socionext.com/

Fixes: 3fdc7d3fe4c0 ("kbuild: link vmlinux only once for CONFIG_TRIM_UNUSED_KSYMS")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Tested-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -1156,7 +1156,7 @@ KBUILD_MODULES := 1
 
 autoksyms_recursive: descend modules.order
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/adjust_autoksyms.sh \
-	  "$(MAKE) -f $(srctree)/Makefile vmlinux"
+	  "$(MAKE) -f $(srctree)/Makefile autoksyms_recursive"
 endif
 
 autoksyms_h := $(if $(CONFIG_TRIM_UNUSED_KSYMS), include/generated/autoksyms.h)


