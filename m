Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A34859E17B
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357302AbiHWLOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357288AbiHWLNW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:13:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E09BB95B1;
        Tue, 23 Aug 2022 02:18:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0A1960F91;
        Tue, 23 Aug 2022 09:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA66AC433B5;
        Tue, 23 Aug 2022 09:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246279;
        bh=Dp0fSo0vbJGjVE30b7n9TYL0NaaBlzr5Q17hpUZeKsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2FF//5cU+26+Cu0S0VwTfNji5NTw1LmO147Ynv0OiSDd+IhmgJSS9IkIVNqRJ5UqK
         OLTLGrcNMKdu4dvWYZFWqr0pq3zRlK1zj7AdixJFNMGOQZwBVAabwoBrz9TqxLZGlV
         9hQfaaYq0VqsUN8eYhSywMtdpNnMCnEzQjdj/JZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 5.4 031/389] drm/gem: Properly annotate WW context on drm_gem_lock_reservations() error
Date:   Tue, 23 Aug 2022 10:21:49 +0200
Message-Id: <20220823080116.996007609@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

commit 2939deac1fa220bc82b89235f146df1d9b52e876 upstream.

Use ww_acquire_fini() in the error code paths. Otherwise lockdep
thinks that lock is held when lock's memory is freed after the
drm_gem_lock_reservations() error. The ww_acquire_context needs to be
annotated as "released", which fixes the noisy "WARNING: held lock freed!"
splat of VirtIO-GPU driver with CONFIG_DEBUG_MUTEXES=y and enabled lockdep.

Cc: stable@vger.kernel.org
Fixes: 7edc3e3b975b5 ("drm: Add helpers for locking an array of BO reservations.")
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20220630200405.1883897-2-dmitry.osipenko@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -1292,7 +1292,7 @@ retry:
 		ret = dma_resv_lock_slow_interruptible(obj->resv,
 								 acquire_ctx);
 		if (ret) {
-			ww_acquire_done(acquire_ctx);
+			ww_acquire_fini(acquire_ctx);
 			return ret;
 		}
 	}
@@ -1317,7 +1317,7 @@ retry:
 				goto retry;
 			}
 
-			ww_acquire_done(acquire_ctx);
+			ww_acquire_fini(acquire_ctx);
 			return ret;
 		}
 	}


