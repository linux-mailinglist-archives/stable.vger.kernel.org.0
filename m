Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5A2498F2F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357669AbiAXTvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:51:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41942 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345039AbiAXToY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:44:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 688F661553;
        Mon, 24 Jan 2022 19:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42230C340E5;
        Mon, 24 Jan 2022 19:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053463;
        bh=a7QTSgbPCTGqbAutw257ceXltTtvuBEN4Cd5NrFUNCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DzXojJV8cwnYo0SEDqiiJP7oNDJBmvG0bGdBvLafWuQGmE7ArX7oMN6t7cqDJSoOa
         RWilv1L894MX6+kEnni4y+bsMsO1aLg/rK6h0NMwmvJmOyGcimZSE3KIJy70mskVaa
         gxGxgUNuiHTrs2a1l1N14tQka+OzYzJFmSvfvbXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        xinhui pan <xinhui.pan@amd.com>
Subject: [PATCH 5.10 041/563] drm/ttm: Put BO in its memory managers lru list
Date:   Mon, 24 Jan 2022 19:36:46 +0100
Message-Id: <20220124184025.849169194@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
@@ -789,6 +789,8 @@ int ttm_mem_evict_first(struct ttm_bo_de
 	ret = ttm_bo_evict(bo, ctx);
 	if (locked)
 		ttm_bo_unreserve(bo);
+	else
+		ttm_bo_move_to_lru_tail_unlocked(bo);
 
 	ttm_bo_put(bo);
 	return ret;


