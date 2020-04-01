Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01AF519B39D
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733025AbgDAQgB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:36:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388557AbgDAQgA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:36:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2977120BED;
        Wed,  1 Apr 2020 16:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758959;
        bh=y93Yqnkx4Hl3ZA0sTp1vcKVcdEB/pEvRT2wpcf1fUPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lf6Q6a708oqWAE/ywEjYDyDsHCJ6nqWAzWL5UzlxK+OUZPb3cWQjOQYb7zrALTAj9
         T9Ve/Wow9va2e6wCxZRPJo+wRTJoyaMWyyqBgsKvMXuJmLWZdH49h83+CwupVUF+cX
         whBbrBp7hxXnzrnRE4YXVM9l3UvMbJZZGUopXeXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 030/102] kbuild: Disable -Wpointer-to-enum-cast
Date:   Wed,  1 Apr 2020 18:17:33 +0200
Message-Id: <20200401161538.731202411@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161530.451355388@linuxfoundation.org>
References: <20200401161530.451355388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit 82f2bc2fcc0160d6f82dd1ac64518ae0a4dd183f upstream.

Clang's -Wpointer-to-int-cast deviates from GCC in that it warns when
casting to enums. The kernel does this in certain places, such as device
tree matches to set the version of the device being used, which allows
the kernel to avoid using a gigantic union.

https://elixir.bootlin.com/linux/v5.5.8/source/drivers/ata/ahci_brcm.c#L428
https://elixir.bootlin.com/linux/v5.5.8/source/drivers/ata/ahci_brcm.c#L402
https://elixir.bootlin.com/linux/v5.5.8/source/include/linux/mod_devicetable.h#L264

To avoid a ton of false positive warnings, disable this particular part
of the warning, which has been split off into a separate diagnostic so
that the entire warning does not need to be turned off for clang. It
will be visible under W=1 in case people want to go about fixing these
easily and enabling the warning treewide.

Cc: stable@vger.kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/887
Link: https://github.com/llvm/llvm-project/commit/2a41b31fcdfcb67ab7038fc2ffb606fd50b83a84
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.extrawarn | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index d08b6fbdfa853..1532038f60055 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -70,5 +70,6 @@ KBUILD_CFLAGS += $(call cc-disable-warning, format)
 KBUILD_CFLAGS += $(call cc-disable-warning, sign-compare)
 KBUILD_CFLAGS += $(call cc-disable-warning, format-zero-length)
 KBUILD_CFLAGS += $(call cc-disable-warning, uninitialized)
+KBUILD_CFLAGS += $(call cc-disable-warning, pointer-to-enum-cast)
 endif
 endif
-- 
2.20.1



