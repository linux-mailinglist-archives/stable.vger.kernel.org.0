Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101F54BE1F7
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbiBUIvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 03:51:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344871AbiBUIva (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 03:51:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB7E2BCB;
        Mon, 21 Feb 2022 00:51:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3800B80E9E;
        Mon, 21 Feb 2022 08:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE643C340E9;
        Mon, 21 Feb 2022 08:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645433465;
        bh=E9F/O+mQYHL8w3t40Odt55FrpN5ng82YJzsgM/QiLqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mpJk2bxToXEhHaJK97UmcVLsf+ZNtX8WZSAkCAxvRXaBgpOAPeReMpxBkew1zFIXK
         LLFXx8mgrrsXtF8Dt8OiK0BUb1P7aOdXO46H5pQl8TN4K5435ALEb6yRL/N9Ba0gTk
         0Cu30stFlTg7S4dv19LNljdKEHy4Hdei0A4Se6pA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.9 01/33] Makefile.extrawarn: Move -Wunaligned-access to W=1
Date:   Mon, 21 Feb 2022 09:48:54 +0100
Message-Id: <20220221084908.615678129@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084908.568970525@linuxfoundation.org>
References: <20220221084908.568970525@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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

From: Nathan Chancellor <nathan@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/Makefile.extrawarn |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -71,5 +71,6 @@ KBUILD_CFLAGS += $(call cc-disable-warni
 KBUILD_CFLAGS += $(call cc-disable-warning, format-zero-length)
 KBUILD_CFLAGS += $(call cc-disable-warning, uninitialized)
 KBUILD_CFLAGS += $(call cc-disable-warning, pointer-to-enum-cast)
+KBUILD_CFLAGS += $(call cc-disable-warning, unaligned-access)
 endif
 endif


