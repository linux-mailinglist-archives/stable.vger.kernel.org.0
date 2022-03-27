Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C924E86BF
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 09:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiC0IAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 04:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiC0IAQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 04:00:16 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E2A1EC76;
        Sun, 27 Mar 2022 00:58:37 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id n7-20020a17090aab8700b001c6aa871860so12625225pjq.2;
        Sun, 27 Mar 2022 00:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=UT8NRfVPaniG62r1LWTa4ALoqhuyMOXc7nycNB8eTOA=;
        b=IiWm+MaVGSQWcTvPQHJw9oeiSuEafCApIsYcgLT9PcPKaKjO5U0l46UqswBFE7S4FM
         pTuWRpmyp/QUprWVEaZHaKqExU+zPaHnFcNINrjNWUbjef38YetTqjFCz3QeIwUxuaTg
         1Xlga1UqkyoFt+H0OQUp8Gdzw3HtqU5IGQl8Try+03ohb9NQqB4Nm4vG8F1lXCJQDOE0
         WFwxJ5taH2lOSTknX0C0Fvl8XXo7ueYxTyfUTDjtHqmKLsj3kPgyefk7soFmVO47vhH4
         RugDLjc6whGtUDvAkwhBQIIJN4CJv2D11lF/OjFdivACDcK8vMk1hReH4AsLSPA3+RDz
         LVHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=UT8NRfVPaniG62r1LWTa4ALoqhuyMOXc7nycNB8eTOA=;
        b=lLG3kFHdTgfoiFyVDM4Flw+S9zNAgPd5ck5mZBHrx9v9E8ukTpqAwau1aGeyKfLPJA
         ULGkGvPdQR1Y0M7Dva9TcO7h691A+7aFYJreUt49NeJS8zN/2l2HtbQQrWdINU2i+rl1
         sZUFoIfvL1WkMBjZqgqcrCuq7OQ6lB7q5TGgBfw+i+hB9z+iACU/SqxAFwAAQderJJmo
         QGfYV5kYGBNzP/6rkohUwhfb8tOedPnnHTj2V8vfbPtMRgpjEoNLUHP9NAdygrwdVUYt
         wQjQbQeTv9uUQrUuzYoHV8B16hN6vOdl0XOEzEvFvFK9kBlKOoQpgxFEenZx23pSNYVZ
         wyCA==
X-Gm-Message-State: AOAM5325W8hfAaknnyolG1SjS2NtNfrgaEafN0SPQtlSL41xBmzWSwRg
        pvd1ZaLFvrruJh64Z2DR6YDepVUGouA=
X-Google-Smtp-Source: ABdhPJyhzeqXeHB5NEFBpmEy8HKFAwwTzpPRxKd7M8ALdpLmqrObhT2u1f8FqSk0MuM5Zd5KZoyd6Q==
X-Received: by 2002:a17:90b:17c5:b0:1c6:3639:7daf with SMTP id me5-20020a17090b17c500b001c636397dafmr22491743pjb.105.1648367917077;
        Sun, 27 Mar 2022 00:58:37 -0700 (PDT)
Received: from localhost ([115.220.243.108])
        by smtp.gmail.com with ESMTPSA id d8-20020a056a00198800b004fab740dbe6sm11846197pfl.15.2022.03.27.00.58.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 27 Mar 2022 00:58:36 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     bskeggs@redhat.com, kherbst@redhat.com, lyude@redhat.com,
        airlied@linux.ie, daniel@ffwll.ch
Cc:     martin.peres@free.fr, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] clk: base: fix an incorrect NULL check on list iterator
Date:   Sun, 27 Mar 2022 15:58:24 +0800
Message-Id: <20220327075824.11806-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bug is here:
	if (nvkm_cstate_valid(clk, cstate, max_volt, clk->temp))
		return cstate;

The list iterator value 'cstate' will *always* be set and non-NULL
by list_for_each_entry_from_reverse(), so it is incorrect to assume
that the iterator value will be unchanged if the list is empty or no
element is found (In fact, it will be a bogus pointer to an invalid
structure object containing the HEAD). Also it missed a NULL check
at callsite and may lead to invalid memory access after that.

To fix this bug, just return 'encoder' when found, otherwise return
NULL. And add the NULL check.

Cc: stable@vger.kernel.org
Fixes: 1f7f3d91ad38a ("drm/nouveau/clk: Respect voltage limits in nvkm_cstate_prog")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c b/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c
index 57199be082fd..c2b5cc5f97ed 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c
@@ -135,10 +135,10 @@ nvkm_cstate_find_best(struct nvkm_clk *clk, struct nvkm_pstate *pstate,
 
 	list_for_each_entry_from_reverse(cstate, &pstate->list, head) {
 		if (nvkm_cstate_valid(clk, cstate, max_volt, clk->temp))
-			break;
+			return cstate;
 	}
 
-	return cstate;
+	return NULL;
 }
 
 static struct nvkm_cstate *
@@ -169,6 +169,8 @@ nvkm_cstate_prog(struct nvkm_clk *clk, struct nvkm_pstate *pstate, int cstatei)
 	if (!list_empty(&pstate->list)) {
 		cstate = nvkm_cstate_get(clk, pstate, cstatei);
 		cstate = nvkm_cstate_find_best(clk, pstate, cstate);
+		if (!cstate)
+			return -EINVAL;
 	} else {
 		cstate = &pstate->base;
 	}
-- 
2.17.1

