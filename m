Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D0C5903B4
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 18:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238182AbiHKQ0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 12:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238247AbiHKQZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 12:25:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92A2A1A7A;
        Thu, 11 Aug 2022 09:07:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60638B821AE;
        Thu, 11 Aug 2022 16:07:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BEBC433D6;
        Thu, 11 Aug 2022 16:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660234029;
        bh=6wrUVHRx6YBZ/Aj6pjAU+ueDZZAwJea2FnolakYDpuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o4PLpadlv8+Lqx5pJRa7lwGyFmidqzA42D4lpue9tX1TqvsAohcjmNW7qEYN1sXRB
         LjurMlD3hf1ouX1wSG0hPYycg7YfWQPMiY3vhooq5SWXzIWuSnDqa5UtUcxBgmkYLe
         tot6SmKNhiHEmKHKeeWEbHOTjXzzYj/9L1bYh2u+XUfIvy/C7lLLzyTEu7WHmXv9AT
         HqhStkCMv0GmC5KaIwfuVU1gyDds5qBkqLcUuO3U3/b5n3Y3vbQyfProhZO/8ZXQ7s
         if/8K6fNSv+fa6fo+ITU6GX9FUG1xtgamXajwvYVyTgr3XW2FRbNDwWjqggzNua5NZ
         gYr4QLrUYNgug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Dooks <ben.dooks@sifive.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>,
        martin.lau@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 33/46] bpf: Fix check against plain integer v 'NULL'
Date:   Thu, 11 Aug 2022 12:03:57 -0400
Message-Id: <20220811160421.1539956-33-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160421.1539956-1-sashal@kernel.org>
References: <20220811160421.1539956-1-sashal@kernel.org>
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
index dc497eaf2266..52b712caa746 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -972,7 +972,8 @@ __printf(2, 3) static void btf_show(struct btf_show *show, const char *fmt, ...)
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

