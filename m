Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E741223601
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390081AbfETMaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:30:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390079AbfETMaV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:30:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78A4120815;
        Mon, 20 May 2019 12:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355421;
        bh=0FbrDWa298P0Lw1YpNogfvug+ahYvm4drwjTmQXsT8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eVZCEe5rA6irdMakEpLObOVFbmQAdf0h1myaKd5awtQ8m12ellGx5kkfhN7p2v49i
         ZC4Yq/h/qGAN2XYpPVCuRibnGxcCZioqH1FgirVpXgJ6H4O3x91eVBRkLxk/G7JGHo
         HBI33U1dA5vDlAt+ypRFK2tuOwIf3doP2U2OyAjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 5.0 113/123] kbuild: turn auto.conf.cmd into a mandatory include file
Date:   Mon, 20 May 2019 14:14:53 +0200
Message-Id: <20190520115252.654159903@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit d2f8ae0e4c5c754f1b2a7b8388d19a1a977e698a upstream.

syncconfig is responsible for keeping auto.conf up-to-date, so if it
fails for any reason, the build must be terminated immediately.

However, since commit 9390dff66a52 ("kbuild: invoke syncconfig if
include/config/auto.conf.cmd is missing"), Kbuild continues running
even after syncconfig fails.

You can confirm this by intentionally making syncconfig error out:

#  diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
#  index 08ba146..307b9de 100644
#  --- a/scripts/kconfig/confdata.c
#  +++ b/scripts/kconfig/confdata.c
#  @@ -1023,6 +1023,9 @@ int conf_write_autoconf(int overwrite)
#          FILE *out, *tristate, *out_h;
#          int i;
#
#  +       if (overwrite)
#  +               return 1;
#  +
#          if (!overwrite && is_present(autoconf_name))
#                  return 0;

Then, syncconfig fails, but Make would not stop:

  $ make -s mrproper allyesconfig defconfig
  $ make
  scripts/kconfig/conf  --syncconfig Kconfig

  *** Error during sync of the configuration.

  make[2]: *** [scripts/kconfig/Makefile;69: syncconfig] Error 1
  make[1]: *** [Makefile;557: syncconfig] Error 2
  make: *** [include/config/auto.conf.cmd] Deleting file 'include/config/tristate.conf'
  make: Failed to remake makefile 'include/config/auto.conf'.
    SYSTBL  arch/x86/include/generated/asm/syscalls_32.h
    SYSHDR  arch/x86/include/generated/asm/unistd_32_ia32.h
    SYSHDR  arch/x86/include/generated/asm/unistd_64_x32.h
    SYSTBL  arch/x86/include/generated/asm/syscalls_64.h
  [ continue running ... ]

The reason is in the behavior of a pattern rule with multi-targets.

  %/auto.conf %/auto.conf.cmd %/tristate.conf: $(KCONFIG_CONFIG)
          $(Q)$(MAKE) -f $(srctree)/Makefile syncconfig

GNU Make knows this rule is responsible for making all the three files
simultaneously. As far as examined, auto.conf.cmd is the target in
question when this rule is invoked. It is probably because auto.conf.cmd
is included below the inclusion of auto.conf.

The inclusion of auto.conf is mandatory, while that of auto.conf.cmd
is optional. GNU Make does not care about the failure in the process
of updating optional include files.

I filed this issue (https://savannah.gnu.org/bugs/?56301) in case this
behavior could be improved somehow in future releases of GNU Make.
Anyway, it is quite easy to fix our Makefile.

Given that auto.conf is already a mandatory include file, there is no
reason to stick auto.conf.cmd optional. Make it mandatory as well.

Cc: linux-stable <stable@vger.kernel.org> # 5.0+
Fixes: 9390dff66a52 ("kbuild: invoke syncconfig if include/config/auto.conf.cmd is missing")
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
[commented out diff above to keep patch happy - gregkh]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -642,7 +642,7 @@ ifeq ($(may-sync-config),1)
 # Read in dependencies to all Kconfig* files, make sure to run syncconfig if
 # changes are detected. This should be included after arch/$(SRCARCH)/Makefile
 # because some architectures define CROSS_COMPILE there.
--include include/config/auto.conf.cmd
+include include/config/auto.conf.cmd
 
 # To avoid any implicit rule to kick in, define an empty command
 $(KCONFIG_CONFIG): ;


