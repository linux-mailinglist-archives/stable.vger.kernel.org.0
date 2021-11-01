Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3899244172F
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbhKAJeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:34:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232484AbhKAJcM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:32:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8696C6117A;
        Mon,  1 Nov 2021 09:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758656;
        bh=lcL9YykhwXtIsauYrMsyAo6kj0FnmWrgRJn4Pn/ASck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CzfyAZ+VYpLQDe6U0E4kKkmYsoluc8GkdCtA4takG8EyEHTspne1p84u0ACQ+rNlb
         Jqs1nywaqITlbaK+J6ccy2kfO9RtZzm7OSSPfw/Ec/jpEbCTaewFuZ68cA2QOoQ0z4
         tzMZBoGU37bWHfoSWJRpGnEcTg29DBTKwp0CYPBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Erhard F." <erhard_f@mailbox.org>, Huang Rui <ray.huang@amd.com>
Subject: [PATCH 5.4 22/51] drm/ttm: fix memleak in ttm_transfered_destroy
Date:   Mon,  1 Nov 2021 10:17:26 +0100
Message-Id: <20211101082505.681517249@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082500.203657870@linuxfoundation.org>
References: <20211101082500.203657870@linuxfoundation.org>
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
@@ -463,6 +463,7 @@ static void ttm_transfered_destroy(struc
 	struct ttm_transfer_obj *fbo;
 
 	fbo = container_of(bo, struct ttm_transfer_obj, base);
+	dma_resv_fini(&fbo->base.base._resv);
 	ttm_bo_put(fbo->bo);
 	kfree(fbo);
 }


