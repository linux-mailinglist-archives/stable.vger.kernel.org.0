Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C26561C9C
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236165AbiF3OAX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 10:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236797AbiF3N7g (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:59:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F032427C3;
        Thu, 30 Jun 2022 06:52:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C18E3B82AED;
        Thu, 30 Jun 2022 13:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385FFC34115;
        Thu, 30 Jun 2022 13:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597141;
        bh=xfVKWAN7dZP6tDpOaNa0Xen3miKWJorW1sLauxWrqCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2CmtP1cGsdW+El2uhgPYC+JhhIc1UHZBCdxUMfUAB5a+S9wifkXQYB9pVyj1UnEG
         EzjMH5w6AIaTPaxsSzTJgbSDli9obZ+XG3Qsn64Jr5pic0jFL9saJIrNPbgmjzA9IU
         n0zGNgHEwrHsQdopHGq6VKp093LaI3p1TNAyHpXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 4.19 41/49] kbuild: link vmlinux only once for CONFIG_TRIM_UNUSED_KSYMS (2nd attempt)
Date:   Thu, 30 Jun 2022 15:46:54 +0200
Message-Id: <20220630133235.087412571@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133233.910803744@linuxfoundation.org>
References: <20220630133233.910803744@linuxfoundation.org>
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
@@ -1017,7 +1017,7 @@ PHONY += autoksyms_recursive
 autoksyms_recursive: $(vmlinux-deps)
 ifdef CONFIG_TRIM_UNUSED_KSYMS
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/adjust_autoksyms.sh \
-	  "$(MAKE) -f $(srctree)/Makefile vmlinux"
+	  "$(MAKE) -f $(srctree)/Makefile autoksyms_recursive"
 endif
 
 # For the kernel to actually contain only the needed exported symbols,


