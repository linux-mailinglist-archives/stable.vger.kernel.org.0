Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30E506A07CD
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 12:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233338AbjBWLyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 06:54:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234045AbjBWLyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 06:54:10 -0500
Received: from mail-ed1-x549.google.com (mail-ed1-x549.google.com [IPv6:2a00:1450:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D810354A0C
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 03:54:07 -0800 (PST)
Received: by mail-ed1-x549.google.com with SMTP id ec13-20020a0564020d4d00b004a621e993a8so14386550edb.13
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 03:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aqI5qRz1R2l92R95izh+z71292tP3IreESGLJDlY42w=;
        b=r5DLdzyiLefsEEbLLBNJXanRJcEV6piHQkD0uKbvvFGwGxZMeWUEZyqimk08IkkDgW
         sljfAcKxXzbHexzFzbfShoYNlJBhkd5Yimz9ECpYaz1JlOJNL8onMof/89jTGOqyvEod
         m7vlKRPwdSCOSVJ6zSy4puUAFrFe9qxzt7Dobqedwu4PwtgCeYaKBBdBSzVeHAqdTK61
         0d7++akMPINK2HYjPjMQ1EZnorjvmhN3IcxzRasHAU0Gfom+0s3o9j8G7CkZyJ8jr/KM
         AwVwa5Fe3mjT+6+2kvGxbt55Gax5wcwLxwQjWfengdR2wfpovOSCppjHfuXO6/feXB8l
         pG2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aqI5qRz1R2l92R95izh+z71292tP3IreESGLJDlY42w=;
        b=JUN2Njek7zEc9L1aH46OElzIvFWTlLXeIgIg70d6qyN3Yv+OQe6v2ECcBakwTejhbY
         gl0V/3WxzIqitE5s6cI6OnjqWRedM2z2DrvO4PHEBN3RXt7hhuo/CaAMFx2yeL7K+D4m
         44PISBmrbqT9CCKC6s5mp2WWMOkrAF+xkVVHF43TM8fXMPlsMHf31MlA0ZDkMsqQScR8
         yBB2qEepgIp6TpDEA5JdCgpxUc1BwzXUv9ec+WY2Set44ewwew2SZ0UccHrVozfT/D6r
         WeDB2xLvdhUUWJ7drX0imgaeaZNYmXbBjA5aeM77K0hNwPxCI6FcrZ6pdBYjR1wxtpLD
         9XTQ==
X-Gm-Message-State: AO0yUKWqNZh7oDcnUtq5QR39vj2Mks/lkxvjxoRtlivsRxDx8JO2EsGf
        Z9GrNGUCHP9QgPhZ6YkSsK+OsDCkDb6MXw==
X-Google-Smtp-Source: AK7set/4h+iHm/PkGUfEY5SE2abz0fqYl0ctlcK48eQu18xhDc5UlrdrQp0M76tx5+fa5TINSt+SWYwimd31UQ==
X-Received: from lux.lon.corp.google.com ([2a00:79e0:d:209:cf33:dc28:3e98:f5e9])
 (user=maennich job=sendgmr) by 2002:a17:906:76d0:b0:8de:e66a:d788 with SMTP
 id q16-20020a17090676d000b008dee66ad788mr4278993ejn.7.1677153246106; Thu, 23
 Feb 2023 03:54:06 -0800 (PST)
Date:   Thu, 23 Feb 2023 11:53:51 +0000
In-Reply-To: <20220201205624.652313-1-nathan@kernel.org>
Message-Id: <20230223115351.1241401-5-maennich@google.com>
Mime-Version: 1.0
References: <20220201205624.652313-1-nathan@kernel.org>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Subject: [PATCH v5.15 v2 4/4] lib/Kconfig.debug: Allow BTF + DWARF5 with
 pahole 1.21+
From:   Matthias Maennich <maennich@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     kernel-team@android.com, maennich@google.com,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 42d9b379e3e1790eafb87c799c9edfd0b37a37c7 ]

Commit 98cd6f521f10 ("Kconfig: allow explicit opt in to DWARF v5")
prevented CONFIG_DEBUG_INFO_DWARF5 from being selected when
CONFIG_DEBUG_INFO_BTF is enabled because pahole had issues with clang's
DWARF5 info. This was resolved by [1], which is in pahole v1.21.

Allow DEBUG_INFO_DWARF5 to be selected with DEBUG_INFO_BTF when using
pahole v1.21 or newer.

[1]: https://git.kernel.org/pub/scm/devel/pahole/pahole.git/commit/?id=7d8e829f636f47aba2e1b6eda57e74d8e31f733c

Change-Id: I9cc90f12abcc8a809bb263e31ec16766d9384e40
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220201205624.652313-6-nathan@kernel.org
Signed-off-by: Matthias Maennich <maennich@google.com>
---
 lib/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 944fd2ae756b..dbbd243c865f 100644
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
-- 
2.39.2.637.g21b0678d19-goog

