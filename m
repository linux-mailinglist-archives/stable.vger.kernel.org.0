Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB044E85F2
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 07:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbiC0Fd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 01:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233643AbiC0Fd0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 01:33:26 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C4EB85C;
        Sat, 26 Mar 2022 22:31:48 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id f3so8585679pfe.2;
        Sat, 26 Mar 2022 22:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=T9ii1s/vDDaD1QA64Ks3s/bvtYbdmXDV59Ucnc6x+8M=;
        b=KDf55Yv5mpN2AkGspc9VfaKo0K2v900aUEgARfmtbxGdDUL6QXuvltflUnnxq9PkHt
         YhW79cDOHms4RxghCJ1odTS3nROpbDTpCnIHmpQ0gIsgSaHGWxR/Ajl+aqYrON7uxevK
         ZGbYyFQdZtH7S4orjIPps5iSgN/1w/8COOndrIemkzpS5iGeY6Fm3KpBjqrdsFfrOFVL
         iSwc8hN81KgS13LzY0muEQDppdLDaOI63J4hYMNlhm9atCWo8og4mXVlxxKGPjLdU3uY
         AHyqFXZQ4LoJ/FMpl6b2E4O6S3ZOb0KN+Y0yfnQw2Quy7wUbvzjmRUDB+CJNT8rRFKQ8
         lbZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=T9ii1s/vDDaD1QA64Ks3s/bvtYbdmXDV59Ucnc6x+8M=;
        b=F5/jbsKZ/4/1tqdELFTFzsYjcQwtEXSDCF6aAEIhxOfbVlihlIh9FRr5bY5AaLvTc2
         4nVeZh0Su6xMX8eiAhqTcp02ilb1sxJkW66Ez9fasVJaa3W0lBsida+GdJ6FgOC0ngd6
         YVeRCdr7FdDrrdILXgj+OAx2/LnMDfUNHpFMf8EQlV0+KI91jzrUU7K5xhbiWyoEgQTB
         BL0G/vIGoT2AfphhsLlFTosCGK4Js7MzhMENT4+NN4NalFcFrk3WbcPKxo/kKf90RvPx
         Df4078bIkpPsFMpKp/ulVDUk56aYoaqQjxlmnBwe88uTmMi9+ZTeEkATydsPZlJtbvTT
         IhEQ==
X-Gm-Message-State: AOAM531dCsEDdeNY6/vjZ6atO9qo2JJzbZaOvIROU8cesxhsedY+e0Zb
        LRFs0Wm3EJEQ8kWT/71Djy4=
X-Google-Smtp-Source: ABdhPJzkzp7Reb+gYTSiszuRxap2P3TtfajgbjK+Rluk16gl1IRBjl55f5DmGDmjeshiq0mHS3yx2A==
X-Received: by 2002:a05:6a00:849:b0:4fb:1112:c19f with SMTP id q9-20020a056a00084900b004fb1112c19fmr10667773pfk.74.1648359108089;
        Sat, 26 Mar 2022 22:31:48 -0700 (PDT)
Received: from localhost.localdomain ([115.220.243.108])
        by smtp.googlemail.com with ESMTPSA id f15-20020a056a001acf00b004fb2ad05521sm3894539pfv.215.2022.03.26.22.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 22:31:47 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     bskeggs@redhat.com
Cc:     kherbst@redhat.com, lyude@redhat.com, airlied@linux.ie,
        daniel@ffwll.ch, linux@roeck-us.net,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] device: fix missing check on list iterator
Date:   Sun, 27 Mar 2022 13:31:39 +0800
Message-Id: <20220327053139.2572-1-xiam0nd.tong@gmail.com>
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
	lo = pstate->base.domain[domain->name];

The list iterator 'pstate' will point to a bogus position containing
HEAD if the list is empty or no element is found. This case should
be checked before any use of the iterator, otherwise it will lead
to a invalid memory access.

To fix this bug, add an check. Use a new value 'iter' as the list
iterator, while use the old value 'pstate' as a dedicated variable
to point to the found element.

Cc: stable@vger.kernel.org
Fixes: 9838366c1597d ("drm/nouveau/device: initial control object class, with pstate control methods")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/gpu/drm/nouveau/nvkm/engine/device/ctrl.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/device/ctrl.c b/drivers/gpu/drm/nouveau/nvkm/engine/device/ctrl.c
index ce774579c89d..6b768635e8ba 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/device/ctrl.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/ctrl.c
@@ -72,7 +72,7 @@ nvkm_control_mthd_pstate_attr(struct nvkm_control *ctrl, void *data, u32 size)
 	} *args = data;
 	struct nvkm_clk *clk = ctrl->device->clk;
 	const struct nvkm_domain *domain;
-	struct nvkm_pstate *pstate;
+	struct nvkm_pstate *pstate = NULL, *iter;
 	struct nvkm_cstate *cstate;
 	int i = 0, j = -1;
 	u32 lo, hi;
@@ -103,11 +103,16 @@ nvkm_control_mthd_pstate_attr(struct nvkm_control *ctrl, void *data, u32 size)
 		return -EINVAL;
 
 	if (args->v0.state != NVIF_CONTROL_PSTATE_ATTR_V0_STATE_CURRENT) {
-		list_for_each_entry(pstate, &clk->states, head) {
-			if (i++ == args->v0.state)
+		list_for_each_entry(iter, &clk->states, head) {
+			if (i++ == args->v0.state) {
+				pstate = iter;
 				break;
+			}
 		}
 
+		if (!pstate)
+			return -EINVAL;
+
 		lo = pstate->base.domain[domain->name];
 		hi = lo;
 		list_for_each_entry(cstate, &pstate->list, head) {
-- 
2.17.1

