Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3261C1697
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729739AbgEANuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:50:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731225AbgEANjt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:39:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D12520757;
        Fri,  1 May 2020 13:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340388;
        bh=KIPoBk7K8wgI48MMKiOmelRUYbArjb3GQ1nhKoUkKeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jNy9D9LHlLchnRFWhxkqA4FOSQpnA+fSWmyTSSxEdVmn9i3cv9nOvMJqxJLDaGmU7
         /k0TnbKoQc1KefFndx75WZsub9UNKvHm5NDsJoU5/uHAdYxyVmhaGFVBXPH/beosET
         ZHN7D4kBuwjfDuVeBlWG3Mc14U3MJQSMZhGPXwX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Vitor Massaru Iha <vitor@massaru.org>,
        Brendan Higgins <brendanhiggins@google.com>
Subject: [PATCH 5.4 46/83] um: ensure `make ARCH=um mrproper` removes arch/$(SUBARCH)/include/generated/
Date:   Fri,  1 May 2020 15:23:25 +0200
Message-Id: <20200501131536.899363242@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131524.004332640@linuxfoundation.org>
References: <20200501131524.004332640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitor Massaru Iha <vitor@massaru.org>

commit 63ec90f18204f2fe072df108de8a021b28b1b173 upstream.

In this workflow:

$ make ARCH=um defconfig && make ARCH=um -j8
  [snip]
$ make ARCH=um mrproper
  [snip]
$ make ARCH=um defconfig O=./build_um && make ARCH=um -j8 O=./build_um
  [snip]
  CC      scripts/mod/empty.o
In file included from ../include/linux/types.h:6,
                 from ../include/linux/mod_devicetable.h:12,
                 from ../scripts/mod/devicetable-offsets.c:3:
../include/uapi/linux/types.h:5:10: fatal error: asm/types.h: No such file or directory
    5 | #include <asm/types.h>
      |          ^~~~~~~~~~~~~
compilation terminated.
make[2]: *** [../scripts/Makefile.build:100: scripts/mod/devicetable-offsets.s] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [/home/iha/sdb/opensource/lkmp/linux-kselftest.git/Makefile:1140: prepare0] Error 2
make[1]: Leaving directory '/home/iha/sdb/opensource/lkmp/linux-kselftest.git/build_um'
make: *** [Makefile:180: sub-make] Error 2

The cause of the error was because arch/$(SUBARCH)/include/generated files
weren't properly cleaned by `make ARCH=um mrproper`.

Fixes: a788b2ed81ab ("kbuild: check arch/$(SRCARCH)/include/generated before out-of-tree build")
Reported-by: Theodore Ts'o <tytso@mit.edu>
Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Vitor Massaru Iha <vitor@massaru.org>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Tested-by: Brendan Higgins <brendanhiggins@google.com>
Link: https://groups.google.com/forum/#!msg/kunit-dev/QmA27YEgEgI/hvS1kiz2CwAJ
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/um/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -140,6 +140,7 @@ export CFLAGS_vmlinux := $(LINK-y) $(LIN
 # When cleaning we don't include .config, so we don't include
 # TT or skas makefiles and don't clean skas_ptregs.h.
 CLEAN_FILES += linux x.i gmon.out
+MRPROPER_DIRS += arch/$(SUBARCH)/include/generated
 
 archclean:
 	@find . \( -name '*.bb' -o -name '*.bbg' -o -name '*.da' \


