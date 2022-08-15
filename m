Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49EC2593D10
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346236AbiHOUNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346562AbiHOULn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:11:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9086C491C8;
        Mon, 15 Aug 2022 11:57:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A7E2CCE129D;
        Mon, 15 Aug 2022 18:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D8DC433C1;
        Mon, 15 Aug 2022 18:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589872;
        bh=Qk6A5z5Pblx3Ub+fE3xuwH7Ai2Bhm0bhJE/MIKtqHqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IcuoVy93Fsj2RmE9W9/mt/+Mh6pK0FW6AwJNUOgoGvm6q/aTkKFQrp+Dl8Kqu641S
         LPe/wsWsdkXVC0aLC3YH2l99TQVTLQklWUUCDsuZNHgAqh+RwYOW8Ep97vU+3xiBOS
         7N/FCVm+qF9BX8Lag8pFBzUgbIZqYE1LQEB8x34U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 5.18 0076/1095] drm/shmem-helper: Add missing vunmap on error
Date:   Mon, 15 Aug 2022 19:51:15 +0200
Message-Id: <20220815180432.679327225@linuxfoundation.org>
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

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

commit df4aaf015775221dde8a51ee09edb919981f091e upstream.

The vmapping of dma-buf may succeed, but DRM SHMEM rejects the IOMEM
mapping, and thus, drm_gem_shmem_vmap_locked() should unvmap the IOMEM
before erroring out.

Cc: stable@vger.kernel.org
Fixes: 49a3f51dfeee ("drm/gem: Use struct dma_buf_map in GEM vmap ops and convert GEM backends")
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20220630200058.1883506-2-dmitry.osipenko@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -302,6 +302,7 @@ static int drm_gem_shmem_vmap_locked(str
 		ret = dma_buf_vmap(obj->import_attach->dmabuf, map);
 		if (!ret) {
 			if (WARN_ON(map->is_iomem)) {
+				dma_buf_vunmap(obj->import_attach->dmabuf, map);
 				ret = -EIO;
 				goto err_put_pages;
 			}


