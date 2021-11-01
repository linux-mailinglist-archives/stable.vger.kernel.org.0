Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDB5441829
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbhKAJo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:44:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233963AbhKAJnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:43:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5A596137F;
        Mon,  1 Nov 2021 09:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758931;
        bh=kTNfSWKTJZM9Z1ZVaheYZFu9lohMJ/LsSz2kSUXjNNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0F6Z1t4rP0ZaCtCkXXn1P8inNzK35TEgexMnytQyd/xI2arHSeQL3GU8eUOjnibOl
         yx5moMzdRiRDfirN3TZ+1d6utNZqsM+BY6YngdgYq00rb3PXfRKYagdY5tg7l6Fg43
         SK133zj87aMTlrr2S6fyWoXdPcwB4K9W/EJJ7j1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Erhard F." <erhard_f@mailbox.org>, Huang Rui <ray.huang@amd.com>
Subject: [PATCH 5.14 043/125] drm/ttm: fix memleak in ttm_transfered_destroy
Date:   Mon,  1 Nov 2021 10:16:56 +0100
Message-Id: <20211101082541.337335588@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

commit 0db55f9a1bafbe3dac750ea669de9134922389b5 upstream.

We need to cleanup the fences for ghost objects as well.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reported-by: Erhard F. <erhard_f@mailbox.org>
Tested-by: Erhard F. <erhard_f@mailbox.org>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Bug: https://bugzilla.kernel.org/show_bug.cgi?id=214029
Bug: https://bugzilla.kernel.org/show_bug.cgi?id=214447
CC: <stable@vger.kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20211020173211.2247-1-christian.koenig@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ttm/ttm_bo_util.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -190,6 +190,7 @@ static void ttm_transfered_destroy(struc
 	struct ttm_transfer_obj *fbo;
 
 	fbo = container_of(bo, struct ttm_transfer_obj, base);
+	dma_resv_fini(&fbo->base.base._resv);
 	ttm_bo_put(fbo->bo);
 	kfree(fbo);
 }


