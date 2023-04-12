Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 323FC6DEFBD
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbjDLIxg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbjDLIx3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:53:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05E49762
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:53:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 161726318C
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3A7C433EF;
        Wed, 12 Apr 2023 08:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289564;
        bh=vdzjwGx0crus/MrqMWbowkFJ+jXWtZeht3nOZLLVkbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TC8N7ZABcm1clx8fIBCZ1VJuUIdXR4xR20yyKd1c7Z9BfzgagkMXAi+MrK7AjmCAn
         Gssnz38hO3VE9nJ+nAzM2/lYCsdzprrfG772nDUrVLX4+NE/HfFGId/10O+mKLeMNw
         EGKn4jBfoZ27giEw/Jok4R3godo9dajmrZh/tHdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Steven Price <steven.price@arm.com>
Subject: [PATCH 6.2 147/173] drm/panfrost: Fix the panfrost_mmu_map_fault_addr() error path
Date:   Wed, 12 Apr 2023 10:34:33 +0200
Message-Id: <20230412082844.040777900@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@collabora.com>

commit 764a2ab9eb56e1200083e771aab16186836edf1d upstream.

Make sure all bo->base.pages entries are either NULL or pointing to a
valid page before calling drm_gem_shmem_put_pages().

Reported-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: <stable@vger.kernel.org>
Fixes: 187d2929206e ("drm/panfrost: Add support for GPU heap allocations")
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210521093811.1018992-1-boris.brezillon@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panfrost/panfrost_mmu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -504,6 +504,7 @@ static int panfrost_mmu_map_fault_addr(s
 		if (IS_ERR(pages[i])) {
 			mutex_unlock(&bo->base.pages_lock);
 			ret = PTR_ERR(pages[i]);
+			pages[i] = NULL;
 			goto err_pages;
 		}
 	}


