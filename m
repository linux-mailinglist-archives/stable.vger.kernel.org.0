Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA675593B5E
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346329AbiHOUOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346772AbiHOUMK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:12:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712E485FAF;
        Mon, 15 Aug 2022 11:58:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4917BB8109E;
        Mon, 15 Aug 2022 18:58:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CACC433C1;
        Mon, 15 Aug 2022 18:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589897;
        bh=y5dOMvY/vtWmTZ442l2tNq7mMPfl2pLTBxrmgWBug+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1055WH18Hcli+c3zty9pKhxzp1JbRu/d7svU3iDuWwl55o/SqJaJNOf40sAo4AtA8
         UvEsCNQseGwq11o4CfWToJZKfj5mV+9veK/lR50Cx9dQiCSwSxze84DiGwo1bMktOc
         byjVMnAG9cwmzaNrqum1lp9fDxbiIXczvx1z7Ock=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        David Airlie <airlied@linux.ie>
Subject: [PATCH 5.18 0083/1095] drm/nouveau/kms: Fix failure path for creating DP connectors
Date:   Mon, 15 Aug 2022 19:51:22 +0200
Message-Id: <20220815180432.951391700@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

commit ca0367ca5d9216644b41f86348d6661f8d9e32d8 upstream.

It looks like that when we moved nouveau over to using drm_dp_aux_init()
and registering it's aux bus during late connector registration, we totally
forgot to fix the failure codepath in nouveau_connector_create() - as it
still seems to assume that drm_dp_aux_init() can fail (it can't).

So, let's fix that and also add a missing check to ensure that we've
properly allocated nv_connector->aux.name while we're at it.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: David Airlie <airlied@linux.ie>
Fixes: fd43ad9d47e7 ("drm/nouveau/kms/nv50-: Move AUX adapter reg to connector late register/early unregister")
Cc: <stable@vger.kernel.org> # v5.14+
Link: https://patchwork.freedesktop.org/patch/msgid/20220526204313.656473-1-lyude@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_connector.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -1361,13 +1361,11 @@ nouveau_connector_create(struct drm_devi
 		snprintf(aux_name, sizeof(aux_name), "sor-%04x-%04x",
 			 dcbe->hasht, dcbe->hashm);
 		nv_connector->aux.name = kstrdup(aux_name, GFP_KERNEL);
-		drm_dp_aux_init(&nv_connector->aux);
-		if (ret) {
-			NV_ERROR(drm, "Failed to init AUX adapter for sor-%04x-%04x: %d\n",
-				 dcbe->hasht, dcbe->hashm, ret);
+		if (!nv_connector->aux.name) {
 			kfree(nv_connector);
-			return ERR_PTR(ret);
+			return ERR_PTR(-ENOMEM);
 		}
+		drm_dp_aux_init(&nv_connector->aux);
 		fallthrough;
 	default:
 		funcs = &nouveau_connector_funcs;


