Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D3D66A41C
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 21:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjAMUcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 15:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjAMUcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 15:32:21 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA45D2F5
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 12:32:20 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id a184so17017040pfa.9
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 12:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3820rMwJqNt52s3q83p14PRLj+o8+7nJ6J1i9mH77lk=;
        b=cdZzww5Urf+ol4TOJ6YM5LEj3sB6hk490f9e/0NADY9NUdHJFsvabc8Va6+91f5KH8
         hJyJVnYO6bD68r7m13OT859Nl8ZhEhB4P/cFtEerS0lW5R3BsJcOoOGTCyMmTnxZTH33
         bX53k9MgDJueoSEuPlSlrP/Zc+G0UoxI9bpi4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3820rMwJqNt52s3q83p14PRLj+o8+7nJ6J1i9mH77lk=;
        b=YNv+w0ucj6udrsUcpzz5m4kNlI1pGL/pP8/A9tNMuZWrlrQBlim3NVwFjdENsGqq2D
         8a+GnekB27hMjJoob0h3aUdl1Zvhiu554jvxxR2rVHP2xQbFycFSoW45Ongnd0zSvxql
         QJuPklcfoQ/aRvWdq8zkXv4/qpkHfVkKCEEFLI1eYTtI3BjpVmIsIzx7w61540YTyUYK
         pJ1pa0DZ0yvIJl14M9jRYWymJCiCgOuEOF+FRuwKKBavYJye7PZCjLKYF3pgp5qgQ0l1
         eWvjvUmR6Vr/G5ts+4lSn7WuCYg9JLD05pjEAzOcU4cjLAxlPLwj6/Esw0qbgIoo6tlL
         ahGQ==
X-Gm-Message-State: AFqh2kp0ywdImrnlMEVPOxSyu/ZH0PsencrgdTmXZ+8JxQqweMQgMSQh
        iaPvJqF+QgpU+bQrDBs9YX10RA==
X-Google-Smtp-Source: AMrXdXsuTG7BFAY0Qq/+oRg2kUdkXI4SHPZc+O1ZBOyCj9AeG3rifuNNnZqkcdymQ4qROIeoOPJSvg==
X-Received: by 2002:a05:6a00:2997:b0:582:1f25:5b8 with SMTP id cj23-20020a056a00299700b005821f2505b8mr50699112pfb.19.1673641940260;
        Fri, 13 Jan 2023 12:32:20 -0800 (PST)
Received: from localhost ([2620:15c:9d:2:bc37:510e:da6f:159f])
        by smtp.gmail.com with UTF8SMTPSA id z8-20020aa79e48000000b0058bb79beefcsm1780802pfq.123.2023.01.13.12.32.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 12:32:19 -0800 (PST)
From:   Daniel Verkamp <dverkamp@chromium.org>
To:     Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@suse.de>
Cc:     Jiri Slaby <jirislaby@kernel.org>, stable@vger.kernel.org,
        Daniel Verkamp <dverkamp@chromium.org>
Subject: [PATCH] x86: combine memmove FSRM and ERMS alternatives
Date:   Fri, 13 Jan 2023 12:32:17 -0800
Message-Id: <20230113203217.1111227-1-dverkamp@chromium.org>
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

