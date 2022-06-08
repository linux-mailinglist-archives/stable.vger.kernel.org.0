Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C70754327A
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 16:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241287AbiFHOZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 10:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241272AbiFHOZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 10:25:50 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF4E10F1FD;
        Wed,  8 Jun 2022 07:25:49 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id y187so19052036pgd.3;
        Wed, 08 Jun 2022 07:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YEWWQkPtr+0wWPKLf4RG60UMZrCSWJiuPn/ljdOWHkQ=;
        b=DnhrmfXDffxsW4ZwNvNyg9aVMPj8/kYx9Ay8Yu9qbYd+4G7Mo38/WeH5zoJpA7/hys
         eGnxziXMpvdkpns0tBjO9rZRJnfkvbG4POnXXZNe3DQ2r+f7FlxQH4S81c5DHdvMaaU/
         1ukFtk7M5MXNy5D54/k0TVgAiv4O9kMHBIHR3prTEHaj9VBa0fdTZwn0f7qL/QjTkJxP
         wF9qze6wvmAzWA6ObBaVGYq1leeoIPPgCPFzY/Q/sQUSm9yW3F8c95lSyp5hlbxUcc17
         FPxQny4PObiyE9FKjIQytruREDxOWDKQLlrbeL+ZKHIsz1tJeucM0DJdI4usF+8AlY5i
         AXSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YEWWQkPtr+0wWPKLf4RG60UMZrCSWJiuPn/ljdOWHkQ=;
        b=EJyj01Kgf0NVc86S8J74gkVAXM0h5adQuSletJxKFjDdD0nJrAe8u0oHbrlVyG4p8Z
         jHDByythMVhQVGn9/N+J2sxXGm1mWLD6QcpyoZLaQC5u7xoaOHYxnj39XL1Aae2Y1TVu
         GHdp8Rvk4UUeezpXo7JSVv9gzWzVScGdQ9aPenbOZXGeVrq9Zd6ST+SnGuPV4NKfURgB
         luYJ7Fx0PgyDgmTIC9+w984gXi+ZXAyXxqrKeRCAvR3rw/Fwnd93zgIW7kgnL/CoPuCo
         0tLSbF0DGLXBXXsGO9dtC6ZJUgzQCZR2kSTywJ46V9G+ocs35/IDqtoTHqha3bBrC/XR
         bfiA==
X-Gm-Message-State: AOAM532sc8iqJ7tCWce6mJZfv31nfMZHfLLhOLUI6+6Khnzd/FlnMRQg
        EivybkHuImbG2cud+LV/e34=
X-Google-Smtp-Source: ABdhPJwihSZYdMxNyBKmSPfREhgO1r6dIGp7bQNy7vyJeunvOfRA0wxxFMrxh+KcwEiMvASQ8hCoUw==
X-Received: by 2002:a63:2cd8:0:b0:3fd:2121:aceb with SMTP id s207-20020a632cd8000000b003fd2121acebmr24917067pgs.173.1654698348867;
        Wed, 08 Jun 2022 07:25:48 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.3])
        by smtp.gmail.com with ESMTPSA id md22-20020a17090b23d600b001e6a230c2f5sm11026400pjb.34.2022.06.08.07.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 07:25:48 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     pavel@denx.de
Cc:     daniel@iogearbox.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, sashal@kernel.org,
        stable@vger.kernel.org, ytcoode@gmail.com
Subject: [PATCH] bpf: Fix excessive memory allocation in stack_map_alloc()
Date:   Wed,  8 Jun 2022 22:25:38 +0800
Message-Id: <20220608142538.3215426-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220608114049.GC9333@duo.ucw.cz>
References: <20220608114049.GC9333@duo.ucw.cz>
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

The 'n_buckets * (value_size + sizeof(struct stack_map_bucket))' part of
the allocated memory for 'smap' is never used, get rid of it.

Fixes: b936ca643ade ("bpf: rework memlock-based memory accounting for maps")
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Link: https://lore.kernel.org/bpf/20220407130423.798386-1-ytcoode@gmail.com
---
This is the modified version for 5.10, the original patch is:

[ Upstream commit b45043192b3e481304062938a6561da2ceea46a6 ]

It would be better if the new patch can be reviewed by someone else.

 kernel/bpf/stackmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 4575d2d60cb1..54fdcb78ad19 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -121,8 +121,8 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
 		return ERR_PTR(-E2BIG);
 
 	cost = n_buckets * sizeof(struct stack_map_bucket *) + sizeof(*smap);
-	cost += n_buckets * (value_size + sizeof(struct stack_map_bucket));
-	err = bpf_map_charge_init(&mem, cost);
+	err = bpf_map_charge_init(&mem, cost + n_buckets *
+				  (value_size + sizeof(struct stack_map_bucket)));
 	if (err)
 		return ERR_PTR(err);
 
-- 
2.36.0

