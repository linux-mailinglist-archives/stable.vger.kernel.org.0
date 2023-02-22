Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5185669F365
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 12:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbjBVLXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 06:23:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbjBVLXi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 06:23:38 -0500
Received: from mail-ed1-x54a.google.com (mail-ed1-x54a.google.com [IPv6:2a00:1450:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7761D2C65F
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 03:23:27 -0800 (PST)
Received: by mail-ed1-x54a.google.com with SMTP id b1-20020aa7dc01000000b004ad062fee5eso10181222edu.17
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 03:23:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=D/IVoT6kbM/UtfR7s3dMh2SCTGIBOfUuX6JJnWJ+IwE=;
        b=Mdt0lnS7mkfTzOlIkWZGAfn2CNhhjY/+6NOaqjsir6sOkhYbTuaVd9+5Q8CiyWOUK5
         M55HqjaHZpVYsmIBsKa4LhgN/2/Va/jhzCIWBzjlLCWncOvEexCXSs4p1AKQl58pbTlk
         Svrs3WiNe435EY1pyEkrO5+WJxC/U2pfTr3GU/2kmfGJ+Blv+XQjT0c16tFS/fbAIEY9
         pIZGYmdzFGs//GZKHkJBqaz+Nku+cl6zLyNnuPKyhjPkdhFhAEnzq7wJ/cktgAG20UGx
         bdZQ80lyuMeiEzvdfgRXFKYRXNc5Kn2etdbq7V2NnYqgVijtsrwirIA+2WvmgV9p4TEt
         JzcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D/IVoT6kbM/UtfR7s3dMh2SCTGIBOfUuX6JJnWJ+IwE=;
        b=6SXn3b0GJIfwXBCnn6Dmp3GS1tuM23ZaFIedLW7APaUcNQg+LQDEAZfNMQ2GYlwbLb
         ZBmLnl/O0HIIkbpv8p9C3DuJWJksxRwSC5ngsgEYVillB8hyDdjlrk76ZcVwUI1VaUYi
         QCqIjK0gZqK8SF8DrvfT5VZbxGvaDOFMFGQoXRKKQv8SWRtSpOfzVHpOMszWcwdMZszm
         Usej/KO5LuxMJGMUdzNlrABUMhx4r6kd1/0YB56MUnKriR7MAEg7G+NIzKeug9od5/qV
         oSU6iliFptoiT8RUo9NWb6TZrdkhPnfwUwZpjrX4Dhvn+k9YKCSNI9MnMiXIWdCvruoB
         NB3Q==
X-Gm-Message-State: AO0yUKXqzj2ezOXIdfhDAelNxz/1OmleiryQn+9yJfC08hochxrYJHIY
        RHbUkZuUzixjTtt7saPOyEvLaL84pHYecA==
X-Google-Smtp-Source: AK7set8mrOZB3VFNWOkj4p+YxajaUNjVz9R6h/g8mcDXigj3yFq+Um+6vmXjxKfiQvlSkRah1b/2AptvfbDDZw==
X-Received: from lux.lon.corp.google.com ([2a00:79e0:d:209:35a9:4800:d90c:e9bc])
 (user=maennich job=sendgmr) by 2002:a17:906:5ad0:b0:878:790b:b7fd with SMTP
 id x16-20020a1709065ad000b00878790bb7fdmr7119681ejs.14.1677065006123; Wed, 22
 Feb 2023 03:23:26 -0800 (PST)
Date:   Wed, 22 Feb 2023 11:21:47 +0000
In-Reply-To: <20220201205624.652313-1-nathan@kernel.org>
Message-Id: <20230222112141.278066-6-maennich@google.com>
Mime-Version: 1.0
References: <20220201205624.652313-1-nathan@kernel.org>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Subject: [PATCH 5/5] lib/Kconfig.debug: Allow BTF + DWARF5 with pahole 1.21+
From:   maennich@google.com
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

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
---
 lib/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 0743c9567d7e..dd86de130cdf 100644
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

