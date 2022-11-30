Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7181663DEAF
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiK3Sjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiK3Sjf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:39:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167D597031
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:39:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F77961D74
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD99C433D7;
        Wed, 30 Nov 2022 18:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833574;
        bh=jg29UixbMaXOtHQO1/q+5au2IcDVATzvDZAKVEnJ5Jk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dgkiL8f+epsmN2+iQVdwgHt4QWvqOErO6s/2iNRZ84oQTJXS47xVjtnklWRAEIUvg
         mLTzREewyRzRV7Q9OQwQXy3NQ+v8iXeemmRDmRWXPPTeqlQLjePnBNSlNV8LXDwLB/
         m8/2b1P2Q1GsRo2JHwz2P88hBFUGKP0IrqnFLVSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sam James <sam@gentoo.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 146/206] kbuild: fix -Wimplicit-function-declaration in license_is_gpl_compatible
Date:   Wed, 30 Nov 2022 19:23:18 +0100
Message-Id: <20221130180536.752407228@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sam James <sam@gentoo.org>

commit 50c697215a8cc22f0e58c88f06f2716c05a26e85 upstream.

Add missing <linux/string.h> include for strcmp.

Clang 16 makes -Wimplicit-function-declaration an error by default.
Unfortunately, out of tree modules may use this in configure scripts,
which means failure might cause silent miscompilation or misconfiguration.

For more information, see LWN.net [0] or LLVM's Discourse [1], gentoo-dev@ [2],
or the (new) c-std-porting mailing list [3].

[0] https://lwn.net/Articles/913505/
[1] https://discourse.llvm.org/t/configure-script-breakage-with-the-new-werror-implicit-function-declaration/65213
[2] https://archives.gentoo.org/gentoo-dev/message/dd9f2d3082b8b6f8dfbccb0639e6e240
[3] hosted at lists.linux.dev.

[akpm@linux-foundation.org: remember "linux/"]
Link: https://lkml.kernel.org/r/20221116182634.2823136-1-sam@gentoo.org
Signed-off-by: Sam James <sam@gentoo.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/license.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/license.h
+++ b/include/linux/license.h
@@ -2,6 +2,8 @@
 #ifndef __LICENSE_H
 #define __LICENSE_H
 
+#include <linux/string.h>
+
 static inline int license_is_gpl_compatible(const char *license)
 {
 	return (strcmp(license, "GPL") == 0


