Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704866AEB24
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbjCGRkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232027AbjCGRkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:40:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA0099242
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:36:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2610B8199E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0B8C433D2;
        Tue,  7 Mar 2023 17:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210585;
        bh=YDH6YSNZw/uNjIOSTAm6SWhQX/bt1qskzo9zZHhwXX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jmItJW+sb53Ci5HROKoUnEpwXO2JcIOiQBK6q9PyTorj45UshxmU8k+gpDOQb2oGl
         UvAF00CHm+3E7mwPCGB1QBz7yIvc11s89AFc9+W+lD8rMI42dfI60jML2CsJbCnC6v
         1fTFhANXdKdnJhYHoZPe/A66+MFqP9xSUyi+Ztkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0587/1001] s390/vdso: Drop -shared from KBUILD_CFLAGS_64
Date:   Tue,  7 Mar 2023 17:55:59 +0100
Message-Id: <20230307170046.960808054@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit fd8589dce8107e2ce62e92f76089654462dd67b4 ]

When clang's -Qunused-arguments is dropped from KBUILD_CPPFLAGS, it
points out that there is a linking phase flag added to CFLAGS, which
will only be used for compiling

  clang-16: error: argument unused during compilation: '-shared' [-Werror,-Wunused-command-line-argument]

'-shared' is already present in ldflags-y so it can just be dropped.

Fixes: 2b2a25845d53 ("s390/vdso: Use $(LD) instead of $(CC) to link vDSO")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/vdso64/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/vdso64/Makefile b/arch/s390/kernel/vdso64/Makefile
index 9e2b95a222a98..1605ba45ac4c0 100644
--- a/arch/s390/kernel/vdso64/Makefile
+++ b/arch/s390/kernel/vdso64/Makefile
@@ -25,7 +25,7 @@ KBUILD_AFLAGS_64 := $(filter-out -m64,$(KBUILD_AFLAGS))
 KBUILD_AFLAGS_64 += -m64 -s
 
 KBUILD_CFLAGS_64 := $(filter-out -m64,$(KBUILD_CFLAGS))
-KBUILD_CFLAGS_64 += -m64 -fPIC -shared -fno-common -fno-builtin
+KBUILD_CFLAGS_64 += -m64 -fPIC -fno-common -fno-builtin
 ldflags-y := -fPIC -shared -soname=linux-vdso64.so.1 \
 	     --hash-style=both --build-id=sha1 -T
 
-- 
2.39.2



