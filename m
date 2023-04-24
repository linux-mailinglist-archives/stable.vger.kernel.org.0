Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E571E6ECE9D
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbjDXNd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbjDXNde (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:33:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC018691
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:33:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B60F61F13
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFFBC4339B;
        Mon, 24 Apr 2023 13:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343198;
        bh=6/kKVYXJzRQM0mGxKmBlwKj+X5zuM1kNAvxpjUjBpCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mGuGt/+zWUUlTvQtnh4VVqs5b+m8Ihg2Edmgml7Xv/TJV6v48Zvr1Wj21OzqMGbeG
         nLoRaExPfZzWkiwdHwiCmG8fF2KejvS71FRWzJISq47x4Qi7aC1OPo5JDpyieA7GOx
         s9A54GNA94OYB1Yylcv97pyKbP5oAunl6vtfN0A4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.2 101/110] gcc: disable -Warray-bounds for gcc-13 too
Date:   Mon, 24 Apr 2023 15:18:03 +0200
Message-Id: <20230424131140.349954542@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
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
@@ -894,18 +894,14 @@ config CC_IMPLICIT_FALLTHROUGH
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


