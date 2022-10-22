Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9BD608622
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbiJVHpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbiJVHoL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:44:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D410244738;
        Sat, 22 Oct 2022 00:42:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EDD160AD7;
        Sat, 22 Oct 2022 07:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0A1C433C1;
        Sat, 22 Oct 2022 07:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424313;
        bh=agcjuSq3bveQHzBFdiNuBuaHvt3WmD6K+sd8Pe9wgqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LkA7E4+CMKgfZCo13KkyP5TeU2yAxOmf6+MmwwPPlkL0NpoLShWFoSadT2qgqR+z4
         5bR6vetx/c0psq7abfTxE0cwoyXZ4/0fCxCfpRJ6nNlO0UMcRy5P4VC4UDx6xHQpz6
         LFVV+VIM7KNcZSpNDOOTj4ptiZnVIw03eLmO4ALE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 5.19 069/717] drm/virtio: Unlock reservations on dma_resv_reserve_fences() error
Date:   Sat, 22 Oct 2022 09:19:08 +0200
Message-Id: <20221022072427.384315035@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

commit 0f877398d30e1df657a31a62f7c7de1869b072b5 upstream.

Unlock reservations on dma_resv_reserve_fences() error to fix recursive
locking of the reservations when this error happens.

Cc: stable@vger.kernel.org
Fixes: c8d4c18bfbc4 ("dma-buf/drivers: make reserving a shared slot mandatory v4")
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20220630200726.1884320-5-dmitry.osipenko@collabora.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/virtio/virtgpu_gem.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/virtio/virtgpu_gem.c
+++ b/drivers/gpu/drm/virtio/virtgpu_gem.c
@@ -228,8 +228,10 @@ int virtio_gpu_array_lock_resv(struct vi
 
 	for (i = 0; i < objs->nents; ++i) {
 		ret = dma_resv_reserve_fences(objs->objs[i]->resv, 1);
-		if (ret)
+		if (ret) {
+			virtio_gpu_array_unlock_resv(objs);
 			return ret;
+		}
 	}
 	return ret;
 }


