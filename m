Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCEF6ECDEE
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbjDXN20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbjDXN2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:28:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CD061BA
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:27:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAB1661D3E
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FF9C433D2;
        Mon, 24 Apr 2023 13:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342872;
        bh=nYYRro7bwihhg5VV6MrIjsbzsZvLhbFdrhYEIynNksQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p4YX7RcS3bDRlmCfZAoiSrlZveIXc6FiCh95zxa/VRx+dn5X1v6Ds5uBjj+6cIwsR
         o0hw+5Ne3rNa7smtIAZH58BMZjTncYnfUNA2tZed0J4gUE3kpDC0n+vq9uCIhqfaKW
         XaOx93MvFB5oq2mAlfYinrdB1XQcNh3wd4TNHQ+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.1 90/98] gcc: disable -Warray-bounds for gcc-13 too
Date:   Mon, 24 Apr 2023 15:17:53 +0200
Message-Id: <20230424131137.385303450@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 0da6e5fd6c3726723e275603426e09178940dace upstream.

We started disabling '-Warray-bounds' for gcc-12 originally on s390,
because it resulted in some warnings that weren't realistically fixable
(commit 8b202ee21839: "s390: disable -Warray-bounds").

That s390-specific issue was then found to be less common elsewhere, but
generic (see f0be87c42cbd: "gcc-12: disable '-Warray-bounds' universally
for now"), and then later expanded the version check was expanded to
gcc-11 (5a41237ad1d4: "gcc: disable -Warray-bounds for gcc-11 too").

And it turns out that I was much too optimistic in thinking that it's
all going to go away, and here we are with gcc-13 showing all the same
issues.  So instead of expanding this one version at a time, let's just
disable it for gcc-11+, and put an end limit to it only when we actually
find a solution.

Yes, I'm sure some of this is because the kernel just does odd things
(like our "container_of()" use, but also knowingly playing games with
things like linker tables and array layouts).

And yes, some of the warnings are likely signs of real bugs, but when
there are hundreds of false positives, that doesn't really help.

Oh well.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/Kconfig |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -892,18 +892,14 @@ config CC_IMPLICIT_FALLTHROUGH
 	default "-Wimplicit-fallthrough=5" if CC_IS_GCC && $(cc-option,-Wimplicit-fallthrough=5)
 	default "-Wimplicit-fallthrough" if CC_IS_CLANG && $(cc-option,-Wunreachable-code-fallthrough)
 
-# Currently, disable gcc-11,12 array-bounds globally.
-# We may want to target only particular configurations some day.
+# Currently, disable gcc-11+ array-bounds globally.
+# It's still broken in gcc-13, so no upper bound yet.
 config GCC11_NO_ARRAY_BOUNDS
 	def_bool y
 
-config GCC12_NO_ARRAY_BOUNDS
-	def_bool y
-
 config CC_NO_ARRAY_BOUNDS
 	bool
-	default y if CC_IS_GCC && GCC_VERSION >= 110000 && GCC_VERSION < 120000 && GCC11_NO_ARRAY_BOUNDS
-	default y if CC_IS_GCC && GCC_VERSION >= 120000 && GCC_VERSION < 130000 && GCC12_NO_ARRAY_BOUNDS
+	default y if CC_IS_GCC && GCC_VERSION >= 110000 && GCC11_NO_ARRAY_BOUNDS
 
 #
 # For architectures that know their GCC __int128 support is sound


