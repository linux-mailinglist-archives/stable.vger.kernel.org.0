Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C47866A421
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 21:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjAMUeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 15:34:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjAMUem (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 15:34:42 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368AA857C5
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 12:34:38 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id s3so14503585pfd.12
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 12:34:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3820rMwJqNt52s3q83p14PRLj+o8+7nJ6J1i9mH77lk=;
        b=kHBdSizysbruzyrKkLWKXWBkCLKtR0g+get6cr0XB7dcC1dX6/MwEjjvMmRO4iyoFb
         x60UI9S9wGw1LbV4BoMrPTiNgbaT2IsxVoyRYqyDIr8h24XfJqtnfUu8kcoIMuus2xIL
         eIVAhu9qkmj00Y6fmLtvQcx/HrlP0UaHYa+5M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3820rMwJqNt52s3q83p14PRLj+o8+7nJ6J1i9mH77lk=;
        b=vqDHJeAC7ggoO72QvPCsvPsC+TxDNU+qqR3hb+Bz38jGV1x/qsnUQq+Mdp8zAXS5yy
         ABfUFLV3m1oW57gnkpsa+I2pYm+77qyRz6/tYPMD6txJGBrqso4OzrrnW2gmnic5nhWn
         x61Hyj2a2AAKj42kYhqKWAdqwRvZwtg4ADsSlcxO3huaAlezxdgzJoF5oTVTD8KZkmt5
         8CUU5ULfGxIwNro2/fi+X/fs9UR33DdLjdDtlQCOVhsiTKYHhOgQI0bI5+rEOo2ghI2p
         dyAs9P94mzYAIwUFRl5ObUULppUr6UUdGV00x2OubX7IbkKT/soqAlboi70GrpVIJzdQ
         8ZaA==
X-Gm-Message-State: AFqh2koOQeQ2xgsQelhsAWyZMpe6EKv2yILSo043dI8MDcPh/yQ2cF83
        XrjcWlL8LPB/Kj0GRaK9tcquBQ==
X-Google-Smtp-Source: AMrXdXvm4hOrKF3ZKdX5w2dQ39nXVKb5Yx9Uv4IAYVf1Nn5SN0+TmbZZSgOhYMiE+xNBEaP8+ekV3w==
X-Received: by 2002:a05:6a00:993:b0:581:c2d3:dc5e with SMTP id u19-20020a056a00099300b00581c2d3dc5emr70341647pfg.11.1673642077827;
        Fri, 13 Jan 2023 12:34:37 -0800 (PST)
Received: from localhost ([2620:15c:9d:2:bc37:510e:da6f:159f])
        by smtp.gmail.com with UTF8SMTPSA id w65-20020a623044000000b0056c349f5c70sm14085347pfw.79.2023.01.13.12.34.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 12:34:37 -0800 (PST)
From:   Daniel Verkamp <dverkamp@chromium.org>
To:     x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@suse.de>
Cc:     Jiri Slaby <jirislaby@kernel.org>, stable@vger.kernel.org,
        Daniel Verkamp <dverkamp@chromium.org>
Subject: [PATCH] x86: combine memmove FSRM and ERMS alternatives
Date:   Fri, 13 Jan 2023 12:34:27 -0800
Message-Id: <20230113203427.1111689-1-dverkamp@chromium.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The x86-64 memmove code has two ALTERNATIVE statements in a row, one to
handle FSRM ("Fast Short REP MOVSB"), and one to handle ERMS ("Enhanced
REP MOVSB"). If either of these features is present, the goal is to jump
directly to a REP MOVSB; otherwise, some setup code that handles short
lengths is executed. The first comparison of a sequence of specific
small sizes is included in the first ALTERNATIVE, so it will be replaced
by NOPs if FSRM is set, and then (assuming ERMS is also set) execution
will fall through to the JMP to a REP MOVSB in the next ALTERNATIVE.

The two ALTERNATIVE invocations can be combined into a single instance
of ALTERNATIVE_2 to simplify and slightly shorten the code. If either
FSRM or ERMS is set, the first instruction in the memmove_begin_forward
path will be replaced with a jump to the REP MOVSB.

This also prevents a problem when FSRM is set but ERMS is not; in this
case, the previous code would have replaced both ALTERNATIVEs with NOPs
and skipped the first check for sizes less than 0x20 bytes. This
combination of CPU features is arguably a firmware bug, but this patch
makes the function robust against this badness.

Fixes: f444a5ff95dc ("x86/cpufeatures: Add support for fast short REP; MOVSB")
Signed-off-by: Daniel Verkamp <dverkamp@chromium.org>
---
 arch/x86/lib/memmove_64.S | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
index 724bbf83eb5b..1fc36dbd3bdc 100644
--- a/arch/x86/lib/memmove_64.S
+++ b/arch/x86/lib/memmove_64.S
@@ -38,8 +38,10 @@ SYM_FUNC_START(__memmove)
 
 	/* FSRM implies ERMS => no length checks, do the copy directly */
 .Lmemmove_begin_forward:
-	ALTERNATIVE "cmp $0x20, %rdx; jb 1f", "", X86_FEATURE_FSRM
-	ALTERNATIVE "", "jmp .Lmemmove_erms", X86_FEATURE_ERMS
+	ALTERNATIVE_2 \
+		"cmp $0x20, %rdx; jb 1f", \
+		"jmp .Lmemmove_erms", X86_FEATURE_FSRM, \
+		"jmp .Lmemmove_erms", X86_FEATURE_ERMS
 
 	/*
 	 * movsq instruction have many startup latency
-- 
2.39.0.314.g84b9a713c41-goog

