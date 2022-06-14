Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B66C54B322
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 16:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245054AbiFNO0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 10:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244867AbiFNO0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 10:26:43 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92632FFF8;
        Tue, 14 Jun 2022 07:26:42 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 184so8624332pga.12;
        Tue, 14 Jun 2022 07:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HX6j/JD0P8ViHMlHg7WyYldgm56QAZWdqgVJ9jnPJgM=;
        b=ppu8W0HHefaAqCG7W5h72lu9tapfC3y65tgq+at8TKkuYvzp5WLB4XE5P7z3MtA+mr
         5RdO2qcuh2GpPFvg1Pbkm2aZWP4RqGnN5b66blbsvnXH5RfPVkwCYhC2B0nro210nse2
         HcRjubRYwB4jN3+zy0ikMhzqL4/DpsFtM77dBQEF2STszGm/oHuphGNucTY3FF7dUBAd
         VaQInJDu+x9Z9E3umk6UhUjH0A3YFptxM6ihJ6UinvvMd46kXGldy8VvG5W3JKpwTNOz
         d91e+lLgtjSvW9TVYh3LeV6YBM7Y1XFZukSegBA7uk6PCEy4BpQzRLhGvr5oSFJxdTEi
         JW8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HX6j/JD0P8ViHMlHg7WyYldgm56QAZWdqgVJ9jnPJgM=;
        b=58LxRdtION2OodgE7qiggqRmHATZrda2bc6VxnYOQl8FSLWsayJvUlcG/+IHsuzGhU
         jLFU5cMBx3McD4VPCdbXPOS6+gxnai0Ea3ubQLkvScY7sPsseIiOa5H3omjq1OY46p74
         rONDDxAinwSA08CZt+frIPtVd7NH6HEjcAZlj9kqsMO76FUXyqaC59SE49k89b65J0Vu
         /tmvMARcaeCblUy28ns5VSLbL7D90J7vKjDawaDTy1clGhFWcRCVz/xtdURLDzHSdfni
         8e9jnF0+5aBjUNkiq7TRyTnw8d2XGEwHRyx1vOJbljSs3zVD2XbQOj6cIoCUnqxvbeTG
         6xuQ==
X-Gm-Message-State: AOAM531rQe3q3KB6DO56zTRf0J0nq2aeqJlS3NxU9dfPf82Pe8X0a+6g
        gbCg9Ro0W1BWPoafbd/teag=
X-Google-Smtp-Source: ABdhPJwDYOdewme8SussyfdqonnOtEyn4v66iA7GLe/qy65ln/zKk85TLwbfZ6knvbX59HXs/kr+Cg==
X-Received: by 2002:a62:d045:0:b0:51b:fcf6:3add with SMTP id p66-20020a62d045000000b0051bfcf63addmr5088275pfg.68.1655216802241;
        Tue, 14 Jun 2022 07:26:42 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id m25-20020a637119000000b003f6ba49bc57sm7806752pgc.71.2022.06.14.07.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:26:41 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     daniel@iogearbox.net, linux-kernel@vger.kernel.org, pavel@denx.de,
        sashal@kernel.org, stable@vger.kernel.org, ytcoode@gmail.com,
        ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, bpf@vger.kernel.org
Subject: [PATCH] bpf: Fix incorrect memory charge cost calculation in stack_map_alloc()
Date:   Tue, 14 Jun 2022 22:26:22 +0800
Message-Id: <20220614142622.998611-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <YqbunqapIFiIVqOb@kroah.com>
References: <YqbunqapIFiIVqOb@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b45043192b3e481304062938a6561da2ceea46a6 upstream.

This is a backport of the original upstream patch for 5.4/5.10.

The original upstream patch has been applied to 5.4/5.10 branches, which
simply removed the line:

  cost += n_buckets * (value_size + sizeof(struct stack_map_bucket));

This is correct for upstream branch but incorrect for 5.4/5.10 branches,
as the 5.4/5.10 branches do not have the commit 370868107bf6 ("bpf:
Eliminate rlimit-based memory accounting for stackmap maps"), so the
bpf_map_charge_init() function has not been removed.

Currently the bpf_map_charge_init() function in 5.4/5.10 branches takes a
wrong memory charge cost, the

  attr->max_entries * (sizeof(struct stack_map_bucket) + (u64)value_size))

part is missing, let's fix it.

Cc: <stable@vger.kernel.org> # 5.4.y
Cc: <stable@vger.kernel.org> # 5.10.y
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
Note that the original upstream patch is currently applied to
linux-stable-rc/linux-5.4.y branch, not linux/linux-5.4.y, this patch
depends on that patch.

 kernel/bpf/stackmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index c19e669afba0..0c5bf98d5576 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -121,7 +121,8 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-E2BIG);
 
 	cost = n_buckets * sizeof(struct stack_map_bucket *) + sizeof(*smap);
-	err = bpf_map_charge_init(&mem, cost);
+	err = bpf_map_charge_init(&mem, cost + attr->max_entries *
+			   (sizeof(struct stack_map_bucket) + (u64)value_size));
 	if (err)
 		return ERR_PTR(err);
 
-- 
2.36.0

