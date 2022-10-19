Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12FF4603C9C
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiJSIug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiJSIsw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:48:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0D08991A;
        Wed, 19 Oct 2022 01:46:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6270861828;
        Wed, 19 Oct 2022 08:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BCAC433D6;
        Wed, 19 Oct 2022 08:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169171;
        bh=KqCEdkhPcHZPtHS5XUueyb73weNWSVVYIaiahVplhzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CW39fem43/Fg3UnYqbn8fJ/LnBnVXfwkqEtkyB2X1jQPsDNGsC4eTYeZYmed8le7h
         Fx7IAPrK8QVBTfb/e17TwJ/Y5U/vXPwsH22+y981dEMYTGi/EIjisQLnJO5xIYye9F
         WoNJHoHRzZhLFHmeM3wDbvzt7ubMNUwVdwqhNPA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianglei Nie <niejianglei2021@163.com>,
        Lyude Paul <lyude@redhat.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.0 181/862] drm/nouveau: fix a use-after-free in nouveau_gem_prime_import_sg_table()
Date:   Wed, 19 Oct 2022 10:24:28 +0200
Message-Id: <20221019083257.955316963@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -71,7 +71,6 @@ struct drm_gem_object *nouveau_gem_prime
 	ret = nouveau_bo_init(nvbo, size, align, NOUVEAU_GEM_DOMAIN_GART,
 			      sg, robj);
 	if (ret) {
-		nouveau_bo_ref(NULL, &nvbo);
 		obj = ERR_PTR(ret);
 		goto unlock;
 	}


