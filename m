Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A89B4B55E8
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 17:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349631AbiBNQSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 11:18:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356257AbiBNQSn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 11:18:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8683D49277
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 08:18:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2289D614C4
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 16:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B84C340E9;
        Mon, 14 Feb 2022 16:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644855514;
        bh=MxUELgouTCzynxz+OhbXL8S6pkcFTrJYcpK6L0QjaK0=;
        h=From:To:Cc:Subject:Date:From;
        b=hY7FA50Z9GLbILF8oloNEYwWctQ25YoD2jmrX4Op47TlOJDV3czDHcgoPxaNJfIC9
         IenFbec2uCkGK3lwjWueQiw5Fyw5j1Hr1Vz8lS56AepZSqqQhyFRcPBMX606PJ5y/d
         gk7WRz4UE/qvW5tDpE3ArlR4lMcJ1zh5JJkRmwTxyolzJ3dDoO6NFhpqt2pOGbMPO5
         aIJKn8QlT/lyHTYtRfuWtDSvLuwhUfYN6emPcNC5sCn0CrP6wwpFgQwTUJ3jhICCiO
         WX8KuYyGwiqZ//xMUsVXAkqn3KcuvZyI6uAWsnZ7FLevDdsxwuwyeGKsOcDmkL+iRt
         +QWK2KRT+LHnA==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>, stable@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.9 to 5.4] Makefile.extrawarn: Move -Wunaligned-access to W=1
Date:   Mon, 14 Feb 2022 09:16:42 -0700
Message-Id: <20220214161641.1818-1-nathan@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 1cf5f151d25fcca94689efd91afa0253621fb33a upstream.

-Wunaligned-access is a new warning in clang that is default enabled for
arm and arm64 under certain circumstances within the clang frontend (see
LLVM commit below). On v5.17-rc2, an ARCH=arm allmodconfig build shows
1284 total/70 unique instances of this warning (most of the instances
are in header files), which is quite noisy.

To keep a normal build green through CONFIG_WERROR, only show this
warning with W=1, which will allow automated build systems to catch new
instances of the warning so that the total number can be driven down to
zero eventually since catching unaligned accesses at compile time would
be generally useful.

Cc: stable@vger.kernel.org
Link: https://github.com/llvm/llvm-project/commit/35737df4dcd28534bd3090157c224c19b501278a
Link: https://github.com/ClangBuiltLinux/linux/issues/1569
Link: https://github.com/ClangBuiltLinux/linux/issues/1576
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
[nathan: Fix conflict due to lack of afe956c577b2d]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---

I am not sure how many people are using ToT clang with ARCH=arm on
stable but given how noisy this warning can be, I think it is worth
applying this to all applicable stable branches.

This applies to 4.9 through 5.4 with 'patch -Np1'.

 scripts/Makefile.extrawarn | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index ca08f2fe7c34..854e2ba9daa2 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -49,6 +49,7 @@ KBUILD_CFLAGS += -Wno-format
 KBUILD_CFLAGS += -Wno-sign-compare
 KBUILD_CFLAGS += -Wno-format-zero-length
 KBUILD_CFLAGS += $(call cc-disable-warning, pointer-to-enum-cast)
+KBUILD_CFLAGS += $(call cc-disable-warning, unaligned-access)
 endif
 
 endif

base-commit: 52871671099d1bb3fca5ed076029e4b937bfc053
-- 
2.35.1

