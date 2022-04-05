Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4DEC4F39D7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378793AbiDELiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354020AbiDEKKs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:10:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60788C6242;
        Tue,  5 Apr 2022 02:56:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE76F6157A;
        Tue,  5 Apr 2022 09:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC82C385A3;
        Tue,  5 Apr 2022 09:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152600;
        bh=ordbT1ol/NytMCy2eDm57yDhNZz58uR1lbLYcHMG7BA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X3mSb92wBALZ8mhI7WdNxgFLCsMVMOvVP4P9jk2HvNtjU+opCIcRW6qDQBhX8qCz9
         BZc//NH1pfoNa1cAbI0MtVTLyviqpghN6iel/K68gf5734NpZg9BGCb5/bz7eHgcxn
         aklI1NGSg+ES2rbIM0BPDSgj4R/JnZEnCpKqKDY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 5.15 836/913] modpost: restore the warning message for missing symbol versions
Date:   Tue,  5 Apr 2022 09:31:38 +0200
Message-Id: <20220405070404.888997988@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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


