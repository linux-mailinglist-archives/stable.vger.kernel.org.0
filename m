Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9670F6A0A35
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbjBWNNa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234558AbjBWNN0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:13:26 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FFF302B0
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:13:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 301C6CE2023
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272C8C433EF;
        Thu, 23 Feb 2023 13:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157948;
        bh=3iwinffmvL1HpY/O0e5w/9MKwVPpjlypDTtI5PrmMEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cgXAbVM2IplI+EnKP62ZvUU5arZaUd8kNkvdNm3xtbyvis9blOJf5YZ1ADENnn1sQ
         iTlzOKocVri7tcU7iEXBn64b1SaaPjkP8Vkws2TcfillsjlcSIVCmiF+lfp4XVW8h3
         qr9y5FVjeGje6IzLQ/rJWPeUrIl1iZyq+WpAsQf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Matthias Maennich <maennich@google.com>
Subject: [PATCH 5.15 35/36] lib/Kconfig.debug: Allow BTF + DWARF5 with pahole 1.21+
Date:   Thu, 23 Feb 2023 14:07:11 +0100
Message-Id: <20230223130430.666971176@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130429.072633724@linuxfoundation.org>
References: <20230223130429.072633724@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 42d9b379e3e1790eafb87c799c9edfd0b37a37c7 upstream.

Commit 98cd6f521f10 ("Kconfig: allow explicit opt in to DWARF v5")
prevented CONFIG_DEBUG_INFO_DWARF5 from being selected when
CONFIG_DEBUG_INFO_BTF is enabled because pahole had issues with clang's
DWARF5 info. This was resolved by [1], which is in pahole v1.21.

Allow DEBUG_INFO_DWARF5 to be selected with DEBUG_INFO_BTF when using
pahole v1.21 or newer.

[1]: https://git.kernel.org/pub/scm/devel/pahole/pahole.git/commit/?id=7d8e829f636f47aba2e1b6eda57e74d8e31f733c

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220201205624.652313-6-nathan@kernel.org
Signed-off-by: Matthias Maennich <maennich@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -302,7 +302,7 @@ config DEBUG_INFO_DWARF4
 config DEBUG_INFO_DWARF5
 	bool "Generate DWARF Version 5 debuginfo"
 	depends on !CC_IS_CLANG || AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502 && AS_HAS_NON_CONST_LEB128)
-	depends on !DEBUG_INFO_BTF
+	depends on !DEBUG_INFO_BTF || PAHOLE_VERSION >= 121
 	help
 	  Generate DWARF v5 debug info. Requires binutils 2.35.2, gcc 5.0+ (gcc
 	  5.0+ accepts the -gdwarf-5 flag but only had partial support for some


