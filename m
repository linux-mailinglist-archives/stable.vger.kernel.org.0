Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFBDB6AF145
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbjCGSl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:41:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbjCGSlg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:41:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61670B32B8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:32:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D5101CE1C83
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36DFC433D2;
        Tue,  7 Mar 2023 18:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213739;
        bh=gqJnJUGl7wxn/SZ+P5h6Yr2ecI+jIRuAo9iv8iQb0mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2IEx4ONeohigFicR9Hv37jaBSAFHRm6Fs+sNEDaxXUOvzzemyAz2cXjGa4jdasNdl
         dLVDRmR4V8mP7FSt1mW7chCDJctIXZ7k5tcOTT0mPFdWokLcsXefCouJiNZN2f1ulq
         39ZEWa5b19kTpdEEVzCioqD616xjIpQXroy7bBVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sam James <sam@gentoo.org>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 573/885] gcc-plugins: drop -std=gnu++11 to fix GCC 13 build
Date:   Tue,  7 Mar 2023 17:58:27 +0100
Message-Id: <20230307170027.304717338@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sam James <sam@gentoo.org>

[ Upstream commit 5a6b64adc18d9adfb497a529ff004d59b6df151f ]

The latest GCC 13 snapshot (13.0.1 20230129) gives the following:
```
cc1: error: cannot load plugin ./scripts/gcc-plugins/randomize_layout_plugin.so
 :./scripts/gcc-plugins/randomize_layout_plugin.so: undefined symbol: tree_code_type
```

This ends up being because of https://gcc.gnu.org/git/gitweb.cgi?p=gcc.git;h=b0241ce6e37031
upstream in GCC which changes the visibility of some types used by the kernel's
plugin infrastructure like tree_code_type.

After discussion with the GCC folks, we found that the kernel needs to be building
plugins with the same flags used to build GCC - and GCC defaults to gnu++17
right now. The minimum GCC version needed to build the kernel is GCC 5.1
and GCC 5.1 already defaults to gnu++14 anyway, so just drop the flag, as
all GCCs that could be used to build GCC already default to an acceptable
version which was >= the version we forced via flags until now.

Bug: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108634
Signed-off-by: Sam James <sam@gentoo.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20230201230009.2252783-1-sam@gentoo.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gcc-plugins/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gcc-plugins/Makefile b/scripts/gcc-plugins/Makefile
index b34d11e226366..320afd3cf8e82 100644
--- a/scripts/gcc-plugins/Makefile
+++ b/scripts/gcc-plugins/Makefile
@@ -29,7 +29,7 @@ GCC_PLUGINS_DIR = $(shell $(CC) -print-file-name=plugin)
 plugin_cxxflags	= -Wp,-MMD,$(depfile) $(KBUILD_HOSTCXXFLAGS) -fPIC \
 		  -include $(srctree)/include/linux/compiler-version.h \
 		  -DPLUGIN_VERSION=$(call stringify,$(KERNELVERSION)) \
-		  -I $(GCC_PLUGINS_DIR)/include -I $(obj) -std=gnu++11 \
+		  -I $(GCC_PLUGINS_DIR)/include -I $(obj) \
 		  -fno-rtti -fno-exceptions -fasynchronous-unwind-tables \
 		  -ggdb -Wno-narrowing -Wno-unused-variable \
 		  -Wno-format-diag
-- 
2.39.2



