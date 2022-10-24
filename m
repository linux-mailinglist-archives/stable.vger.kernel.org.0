Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0380960BA60
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234451AbiJXUgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbiJXUgO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:36:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51EFD11A94C;
        Mon, 24 Oct 2022 11:47:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A884ACE1361;
        Mon, 24 Oct 2022 12:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2A3C433D7;
        Mon, 24 Oct 2022 12:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614061;
        bh=eVeasfURuMgmaTvvToTss6SexbhGhp6bCKFrrjPznQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ENc/ghuXYOmQuslo5vEbfLIFNnbAUyIdP6ltAktPYGVwKZBZFY+m/PclSdEQv+SgR
         GKJrVh0g0+3ZruQGthTZbco9DnmvADvcyPdvx6HSswH5kmKVEUIWzoyHYh8Z9XZb1x
         eA6PwycAA6Q9aKd9mJJut/G12nmLcT2QGaloFTJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianglei Nie <niejianglei2021@163.com>,
        Lyude Paul <lyude@redhat.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.10 087/390] drm/nouveau: fix a use-after-free in nouveau_gem_prime_import_sg_table()
Date:   Mon, 24 Oct 2022 13:28:04 +0200
Message-Id: <20221024113026.324682327@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianglei Nie <niejianglei2021@163.com>

commit 540dfd188ea2940582841c1c220bd035a7db0e51 upstream.

nouveau_bo_init() is backed by ttm_bo_init() and ferries its return code
back to the caller. On failures, ttm will call nouveau_bo_del_ttm() and
free the memory.Thus, when nouveau_bo_init() returns an error, the gem
object has already been released. Then the call to nouveau_bo_ref() will
use the freed "nvbo->bo" and lead to a use-after-free bug.

We should delete the call to nouveau_bo_ref() to avoid the use-after-free.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 019cbd4a4feb ("drm/nouveau: Initialize GEM object before TTM object")
Cc: Thierry Reding <treding@nvidia.com>
Cc: <stable@vger.kernel.org> # v5.4+
Link: https://patchwork.freedesktop.org/patch/msgid/20220705132546.2247677-1-niejianglei2021@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_prime.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_prime.c
+++ b/drivers/gpu/drm/nouveau/nouveau_prime.c
@@ -89,7 +89,6 @@ struct drm_gem_object *nouveau_gem_prime
 	ret = nouveau_bo_init(nvbo, size, align, NOUVEAU_GEM_DOMAIN_GART,
 			      sg, robj);
 	if (ret) {
-		nouveau_bo_ref(NULL, &nvbo);
 		obj = ERR_PTR(ret);
 		goto unlock;
 	}


