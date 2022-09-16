Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6755BB183
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 19:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiIPRMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 13:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiIPRMS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 13:12:18 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA70DA0631;
        Fri, 16 Sep 2022 10:12:17 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id p187so6895577oia.9;
        Fri, 16 Sep 2022 10:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=LirYKyUrrXRfiabE61pSwhQWGNWxCjVXrwyWVfwvBlg=;
        b=ZLwKehYRdG2/ghV0H8TwLvbikNeAG7SZ6tgYtpcXxcyqTcaAvvwkKLVFjyhKFyXEzT
         7aBVDt9gZc11wFkq/FAGFbPKzyNeqLn1wMGxbhQSenC3hXYZDAmYeZGAKngQYA9QDb1/
         Jhd79j3mXfINnfAueiaaUFmbwicgVIpWAjbslcVySryTIYUbh55jIRYoRqdge1BOqZIi
         rCXCZgI/bzV1vx2nLaa5TIExcwcJnjDjJN8Kt8alONpqZ7jG86/cZUMDaSdWjjpJtoEm
         Ngot9PuRaDJZ8l4pEsyKeVzwaV1MZYg3VlRwHzkrl05eFLmp3Ab0i5YwUmYNBQvRR/5r
         89vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=LirYKyUrrXRfiabE61pSwhQWGNWxCjVXrwyWVfwvBlg=;
        b=AK5xAATJp8+VYpCwtIg62iHiwlWZTCXB7tcLWeMT0Vk1oVP7/8WFDgmKihWvYoceiI
         WwDoyg5pmAXUEX4NJG4y571RH0VvI6FI5+SKaYkIQWXUnk5SN7U0g/eNWL2v7WT/3j42
         QLUPRjKlyucOezLbqS9hf9ICcLHPI44IhlrppgDZR0sUh/VwWk3CLPcsuHKsExNcJXCA
         5CCfg4z3oWZ2CdlHHjA1uM9/OxLgeeJ9MTxTL+tVe3Qnql3mP5W8ES0Ib2TKj8WsJ0IS
         84I/nlKbXuCc+RS+VnMX2kohNWuQVdP/hGvUc7cI9fkqFLYnywK9ZQKHIDhbN5MHkqji
         3otA==
X-Gm-Message-State: ACrzQf1LwwW8gdQ6PsWlL/UZF2Glzk3Xj/ikcPoGdUuXxJVlbx5mZyYz
        DU6uOcsag7StPZxPvDjXpKiIJWecEzfV0Q==
X-Google-Smtp-Source: AMsMyM7lDI79+KL4DdjyiA27yPWYrKjVaRfeC9owSrUqBHfx+fi8nOmCVnRp2ttq9ltBBONorzLh+w==
X-Received: by 2002:a05:6808:21a3:b0:345:3202:e2a1 with SMTP id be35-20020a05680821a300b003453202e2a1mr2879904oib.268.1663348336763;
        Fri, 16 Sep 2022 10:12:16 -0700 (PDT)
Received: from tx3000mach.io (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id c18-20020a4ac312000000b00435ae9a836asm9430092ooq.15.2022.09.16.10.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 10:12:15 -0700 (PDT)
From:   Martin Rodriguez Reboredo <yakoyoku@gmail.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Thorsten Leemhuis <linux@leemhuis.info>
Subject: [PATCH stable 5.19] kbuild: Add skip_encoding_btf_enum64 option to pahole
Date:   Fri, 16 Sep 2022 14:12:34 -0300
Message-Id: <20220916171234.841556-1-yakoyoku@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

New pahole (version 1.24) generates by default new BTF_KIND_ENUM64 BTF tag,
which is not supported by stable kernel.

As a result the kernel with CONFIG_DEBUG_INFO_BTF option will fail to
compile with following error:

  BTFIDS  vmlinux
FAILED: load BTF from vmlinux: Invalid argument

New pahole provides --skip_encoding_btf_enum64 option to skip BTF_KIND_ENUM64
generation and produce BTF supported by stable kernel.

Adding this option to scripts/pahole-flags.sh.

This change does not have equivalent commit in linus tree, because linus tree
has support for BTF_KIND_ENUM64 tag, so it does not need to be disabled.

Signed-off-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 scripts/pahole-flags.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/pahole-flags.sh b/scripts/pahole-flags.sh
index 0d99ef17e4a5..d4f3d63cb434 100755
--- a/scripts/pahole-flags.sh
+++ b/scripts/pahole-flags.sh
@@ -20,4 +20,8 @@ if [ "${pahole_ver}" -ge "122" ]; then
 	extra_paholeopt="${extra_paholeopt} -j"
 fi
 
+if [ "${pahole_ver}" -ge "124" ]; then
+	extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_enum64"
+fi
+
 echo ${extra_paholeopt}
-- 
2.37.3

