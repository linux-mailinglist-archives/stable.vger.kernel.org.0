Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA7144550F
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhKDOTm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:19:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231303AbhKDOSm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:18:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B406D611C3;
        Thu,  4 Nov 2021 14:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035364;
        bh=a1U+fdpBpOfMu76/Sz6e961i2CVYyOiIo/xb3TUYOv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1MORnjKDix3g5eioPKlvhZrAjv9VoOqIc8T9rwkaWeJ5v9xhXjC5dwfyT0Yw4P3gC
         3iNwlYxDDDVYFLIqBLNguuQE7WVz4Ty6GXIAaqRye7C9WpzPvAH/mXV0vuI7tJ/S6X
         ofZOtVX2EL4Ftb70oZDepziyzKrb7kTdqwWfO294=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Erhard F." <erhard_f@mailbox.org>, Huang Rui <ray.huang@amd.com>
Subject: [PATCH 5.4 8/9] Revert "drm/ttm: fix memleak in ttm_transfered_destroy"
Date:   Thu,  4 Nov 2021 15:13:01 +0100
Message-Id: <20211104141158.658350547@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211104141158.384397574@linuxfoundation.org>
References: <20211104141158.384397574@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit bd99782f3ca491879e8524c89b1c0f40071903bd which is
commit 0db55f9a1bafbe3dac750ea669de9134922389b5 upstream.

Seems that the older kernels can not handle this fix because, to quote
Christian:
	The problem is this memory leak could potentially happen with
	5.10 as wel, just much much much less likely.

	But my guess is that 5.10 is so buggy that when the leak does
	NOT happen we double free and obviously causing a crash.

So it needs to be reverted.

Link: https://lore.kernel.org/r/1a1cc125-9314-f569-a6c4-40fc4509a377@amd.com
Cc: Christian König <christian.koenig@amd.com>
Cc: Erhard F. <erhard_f@mailbox.org>
Cc: Erhard F. <erhard_f@mailbox.org>
Cc: Huang Rui <ray.huang@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ttm/ttm_bo_util.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -463,7 +463,6 @@ static void ttm_transfered_destroy(struc
 	struct ttm_transfer_obj *fbo;
 
 	fbo = container_of(bo, struct ttm_transfer_obj, base);
-	dma_resv_fini(&fbo->base.base._resv);
 	ttm_bo_put(fbo->bo);
 	kfree(fbo);
 }


