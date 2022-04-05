Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D50604F2C17
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245246AbiDEIyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241032AbiDEIco (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E7EB6D25;
        Tue,  5 Apr 2022 01:26:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C178B81B13;
        Tue,  5 Apr 2022 08:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F70C385A2;
        Tue,  5 Apr 2022 08:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147165;
        bh=ordbT1ol/NytMCy2eDm57yDhNZz58uR1lbLYcHMG7BA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j0me1tNXYldifSaWky/ag3w01hbX73M9fI6jJT6gU/lTI2dbUHWYPtSkOE4ioFsf9
         Mx6Fw/PjIL+UXe+eH3x+/UhC/dT7nteOUc1LzdwrMVgwFqJRbyRfsOfmXq/ZXzZ2hx
         R5qp7D3JWR8k/5btHWAcn9+uai36nrksPIxaafr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 5.17 1025/1126] modpost: restore the warning message for missing symbol versions
Date:   Tue,  5 Apr 2022 09:29:32 +0200
Message-Id: <20220405070437.567790746@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Masahiro Yamada <masahiroy@kernel.org>

commit bf5c0c2231bcab677e5cdfb7f73e6c79f6d8c2d4 upstream.

This log message was accidentally chopped off.

I was wondering why this happened, but checking the ML log, Mark
precisely followed my suggestion [1].

I just used "..." because I was too lazy to type the sentence fully.
Sorry for the confusion.

[1]: https://lore.kernel.org/all/CAK7LNAR6bXXk9-ZzZYpTqzFqdYbQsZHmiWspu27rtsFxvfRuVA@mail.gmail.com/

Fixes: 4a6795933a89 ("kbuild: modpost: Explicitly warn about unprototyped symbols")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/mod/modpost.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -669,7 +669,7 @@ static void handle_modversion(const stru
 	unsigned int crc;
 
 	if (sym->st_shndx == SHN_UNDEF) {
-		warn("EXPORT symbol \"%s\" [%s%s] version ...\n"
+		warn("EXPORT symbol \"%s\" [%s%s] version generation failed, symbol will not be versioned.\n"
 		     "Is \"%s\" prototyped in <asm/asm-prototypes.h>?\n",
 		     symname, mod->name, mod->is_vmlinux ? "" : ".ko",
 		     symname);


