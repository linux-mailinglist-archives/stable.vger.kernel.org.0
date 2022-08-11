Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8340B590232
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237369AbiHKQGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236999AbiHKQGh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:06:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86AD79F0E4;
        Thu, 11 Aug 2022 08:53:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E22C160F90;
        Thu, 11 Aug 2022 15:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B59C433D6;
        Thu, 11 Aug 2022 15:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233193;
        bh=1ZDNKUaaKB1KJ5JkHKzZ+5Yu9M3x19mVIHT/BUys0DI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TXWtOr8ccRhKGwpL3KMURN2GdvgYcwobZ80nelbLEpP1wqE8QMoySbNMDf2SSOMxm
         6FwK7EbV8NwcfWE+G0dXYMLbZ7Sd99OkAbPPcoWnR5gHbt92I9FPdgIHyzi4n/hhOt
         iR8ud2sGrkNwbt8nKfDYVlB3LetLO79HjXCLety2qcrV0TjfMxQdXovPUAr7WIgUkC
         xF8D/I2ljk8XMD6wAxb39CK+a5Q92RynqGC9xhygXKPNA7fyrkWHjRyqBlSiexvvxP
         q+Ppxz11Y/gprBXKbOG9Ag2V+6/FSLlodybFxZAcS35gGqVnV2yRoPfdixMS3bmrCj
         VcCQrq4+WeyHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Dooks <ben.dooks@sifive.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>,
        martin.lau@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 65/93] bpf: Fix check against plain integer v 'NULL'
Date:   Thu, 11 Aug 2022 11:41:59 -0400
Message-Id: <20220811154237.1531313-65-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Dooks <ben.dooks@sifive.com>

[ Upstream commit a2a5580fcbf808e7c2310e4959b62f9d2157fdb6 ]

When checking with sparse, btf_show_type_value() is causing a
warning about checking integer vs NULL when the macro is passed
a pointer, due to the 'value != 0' check. Stop sparse complaining
about any type-casting by adding a cast to the typeof(value).

This fixes the following sparse warnings:

kernel/bpf/btf.c:2579:17: warning: Using plain integer as NULL pointer
kernel/bpf/btf.c:2581:17: warning: Using plain integer as NULL pointer
kernel/bpf/btf.c:3407:17: warning: Using plain integer as NULL pointer
kernel/bpf/btf.c:3758:9: warning: Using plain integer as NULL pointer

Signed-off-by: Ben Dooks <ben.dooks@sifive.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20220714100322.260467-1-ben.dooks@sifive.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index feef799884d1..c6f6dedfc6e8 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -1099,7 +1099,8 @@ __printf(2, 3) static void btf_show(struct btf_show *show, const char *fmt, ...)
  */
 #define btf_show_type_value(show, fmt, value)				       \
 	do {								       \
-		if ((value) != 0 || (show->flags & BTF_SHOW_ZERO) ||	       \
+		if ((value) != (__typeof__(value))0 ||			       \
+		    (show->flags & BTF_SHOW_ZERO) ||			       \
 		    show->state.depth == 0) {				       \
 			btf_show(show, "%s%s" fmt "%s%s",		       \
 				 btf_show_indent(show),			       \
-- 
2.35.1

