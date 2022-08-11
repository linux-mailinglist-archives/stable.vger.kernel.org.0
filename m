Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A80F6590338
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237663AbiHKQVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237521AbiHKQUW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:20:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C27CAEDB4;
        Thu, 11 Aug 2022 09:02:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3868E61380;
        Thu, 11 Aug 2022 16:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C2CC433B5;
        Thu, 11 Aug 2022 16:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233738;
        bh=Zu6ijkkJgaNWsevWxt6/GR63axzBMS3cxG1chMQKBkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/lGnwCokrdINPmu5iUKXYA2EIoNYCYNd4bpHXjvN/hk+iVCS6uTy+qE2eK/Vc8tj
         O71jAgHUJuSNWfQjG4weqK6iQFiJSaud2BjXQnhPtcZ7BZweAyrFv9hFWuTqJVMhyx
         MTNDGDq+JRYzINTuIR1Cpq2HaiCpw8sh46S2BQqJ/f1asTt7Lv7bpwK+TNzrHtAXZY
         qe/LMrNzMWgqOuzW7G2ZErg+/wea/AxtRJB8uK31uPrXGsfVWMD13ZMrIcP9k3+Ljr
         UsQWGZMOsS6fYsTsFcwf95iQeDKVO+DEIIlY8Ra3rgVnyhqAyqS0qSOdIreWDuTf1t
         LdRwDspnEoYjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Dooks <ben.dooks@sifive.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>,
        martin.lau@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 52/69] bpf: Fix check against plain integer v 'NULL'
Date:   Thu, 11 Aug 2022 11:56:01 -0400
Message-Id: <20220811155632.1536867-52-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811155632.1536867-1-sashal@kernel.org>
References: <20220811155632.1536867-1-sashal@kernel.org>
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
index 3cfba41a0829..cf89c99d4f28 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -1013,7 +1013,8 @@ __printf(2, 3) static void btf_show(struct btf_show *show, const char *fmt, ...)
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

