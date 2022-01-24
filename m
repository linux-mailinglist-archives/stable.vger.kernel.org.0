Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A164998ED
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453765AbiAXVau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450662AbiAXVVI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:21:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4203CC0604D5;
        Mon, 24 Jan 2022 12:15:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03487B8122D;
        Mon, 24 Jan 2022 20:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4D1C340E5;
        Mon, 24 Jan 2022 20:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055334;
        bh=Of7o8sUp1oF0WnG3m2QjNpOrdoJeej0KI0tKW8m4LpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWggblfSrHy+k88gY4OJy9rItJfft5HNzntYLCyritFZlqc6Xzf4o0xKtdid0j59b
         1wevG6FHckwW7EnPncAPUmjlQ+nie4YRX1BIARuApvec9Q6qciMMMNekvbyJtxhDp9
         EpxLJk7EYe4+JAXpi6TGSYYtbK5AwJCqhkVp6M60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        xinhui pan <xinhui.pan@amd.com>
Subject: [PATCH 5.15 075/846] drm/ttm: Put BO in its memory managers lru list
Date:   Mon, 24 Jan 2022 19:33:12 +0100
Message-Id: <20220124184103.575400530@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: xinhui pan <xinhui.pan@amd.com>

commit 781050b0a3164934857c300bb0bc291e38c26b6f upstream.

After we move BO to a new memory region, we should put it to
the new memory manager's lru list regardless we unlock the resv or not.

Cc: stable@vger.kernel.org
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: xinhui pan <xinhui.pan@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211110043149.57554-1-xinhui.pan@amd.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ttm/ttm_bo.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -724,6 +724,8 @@ int ttm_mem_evict_first(struct ttm_devic
 	ret = ttm_bo_evict(bo, ctx);
 	if (locked)
 		ttm_bo_unreserve(bo);
+	else
+		ttm_bo_move_to_lru_tail_unlocked(bo);
 
 	ttm_bo_put(bo);
 	return ret;


