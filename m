Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176824417C9
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbhKAJkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:40:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233236AbhKAJh7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:37:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 577A061362;
        Mon,  1 Nov 2021 09:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758823;
        bh=Oc7DV+8+K8FyEgu1j+qnv+3akbMOQp0p8JM75XW6WhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MrWCr+IIC4GQF0jtzSvmSX6JG36ldNXBUvZgUVRYvqU40goTNoF/SmzaiVFt8B3rZ
         wZeTD5SZiPFBmCKwda1IBy21ouBdyadqoV5Zm36wB5UriVHKvKqivIlWC+AEG2/ivq
         CGXlNpOUQlKO+Tb+jJRoui/I9c9ii6SCPdKHINbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Erhard F." <erhard_f@mailbox.org>, Huang Rui <ray.huang@amd.com>
Subject: [PATCH 5.10 32/77] drm/ttm: fix memleak in ttm_transfered_destroy
Date:   Mon,  1 Nov 2021 10:17:20 +0100
Message-Id: <20211101082518.624936309@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
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
@@ -322,6 +322,7 @@ static void ttm_transfered_destroy(struc
 	struct ttm_transfer_obj *fbo;
 
 	fbo = container_of(bo, struct ttm_transfer_obj, base);
+	dma_resv_fini(&fbo->base.base._resv);
 	ttm_bo_put(fbo->bo);
 	kfree(fbo);
 }


