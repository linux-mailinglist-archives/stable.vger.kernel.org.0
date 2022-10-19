Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A72C96042DA
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbiJSLK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232369AbiJSLJt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:09:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1935E107CC4;
        Wed, 19 Oct 2022 03:38:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AC17B823A7;
        Wed, 19 Oct 2022 09:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7783C433D7;
        Wed, 19 Oct 2022 09:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170417;
        bh=WsLm7DULaSh3XLEUh8TtPER6hSxauw/5gTEcKzR+ymA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qHIOTEOpCU7XnUUeOprUAYxWyjdvPt9t3kOs2xqhLLMnUvOsUF4W/ZpeqBehBx0Dl
         +Qk/qrfOu+42JgWLgRcWCd2w4CmYwCKh6NwKjz7C/aBgREzCf8Ymv0YAJaPDlWUQo6
         niFb8ZXJAsZzkSzhBDxVsl30/NHp4OZvhZAGGJXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yann Sionneau <ysionneau@kalray.eu>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 648/862] linux/export: use inline assembler to populate symbol CRCs
Date:   Wed, 19 Oct 2022 10:32:15 +0200
Message-Id: <20221019083318.553316034@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit f3304ecd7f060db1d4197fbdce5a503259f770d3 ]

Since commit 7b4537199a4a ("kbuild: link symbol CRCs at final link,
removing CONFIG_MODULE_REL_CRCS"), the module versioning on the
(non-upstreamed-yet) kvx Linux port is broken due to unexpected padding
for __crc_* symbols. The kvx GCC adds padding so u32 gets 8-byte
alignment instead of 4.

I do not know if this happens for upstream architectures in general,
but any compiler has the freedom to insert padding for faster access.

Use the inline assembler to directly specify the wanted data layout.
This is how we previously did before the breakage.

Link: https://lore.kernel.org/lkml/20220817161438.32039-1-ysionneau@kalray.eu/
Link: https://lore.kernel.org/linux-kbuild/31ce5305-a76b-13d7-ea55-afca82c46cf2@kalray.eu/
Fixes: 7b4537199a4a ("kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS")
Reported-by: Yann Sionneau <ysionneau@kalray.eu>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Tested-by: Yann Sionneau <ysionneau@kalray.eu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/export-internal.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/export-internal.h b/include/linux/export-internal.h
index c2b1d4fd5987..fe7e6ba918f1 100644
--- a/include/linux/export-internal.h
+++ b/include/linux/export-internal.h
@@ -10,8 +10,10 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 
-/* __used is needed to keep __crc_* for LTO */
 #define SYMBOL_CRC(sym, crc, sec)   \
-	u32 __section("___kcrctab" sec "+" #sym) __used __crc_##sym = crc
+	asm(".section \"___kcrctab" sec "+" #sym "\",\"a\""	"\n" \
+	    "__crc_" #sym ":"					"\n" \
+	    ".long " #crc					"\n" \
+	    ".previous"						"\n")
 
 #endif /* __LINUX_EXPORT_INTERNAL_H__ */
-- 
2.35.1



