Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 505FB17FA05
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730357AbgCJNCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:02:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728164AbgCJNCJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:02:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF80824649;
        Tue, 10 Mar 2020 13:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845328;
        bh=i2Tx8WkeRwQGYG6tH6M0qmIaYvU0N/cvVTJvJ9JVPgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g4kY2txUxdqCqOS97EtvbbXdIUzuybSk/mP2kdsfGl1Y5vJoaB64+dhavFTGz0gAl
         Q6+RSW8bI+T/U6DtktFR0mpkttmrygrEyLCjR/CFe/Jfky3XcxR1BRlTlFy3PyC7BT
         92UwlCya4N5/PNvxSRqlvUZxYE2W0FRVEDAr9NXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Ahzo <Ahzo@tutanota.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.5 143/189] drm/ttm: fix leaking fences via ttm_buffer_object_transfer
Date:   Tue, 10 Mar 2020 13:39:40 +0100
Message-Id: <20200310123654.294757668@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ahzo <Ahzo@tutanota.com>

commit 8c8c06207bcfc5a7e5918fc0a0f7f7b9a2e196d6 upstream.

Set the drm_device to NULL, so that the newly created buffer object
doesn't appear to use the embedded gem object.

This is necessary, because otherwise no corresponding dma_resv_fini for
the dma_resv_init is called, resulting in a memory leak.

The dma_resv_fini in ttm_bo_release_list is only called if the embedded
gem object is not used, which is determined by checking if the
drm_device is NULL.

Bug: https://gitlab.freedesktop.org/drm/amd/issues/958
Fixes: 1e053b10ba60 ("drm/ttm: use gem reservation object")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Ahzo <Ahzo@tutanota.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/355089/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ttm/ttm_bo_util.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -516,6 +516,7 @@ static int ttm_buffer_object_transfer(st
 		fbo->base.base.resv = &fbo->base.base._resv;
 
 	dma_resv_init(&fbo->base.base._resv);
+	fbo->base.base.dev = NULL;
 	ret = dma_resv_trylock(&fbo->base.base._resv);
 	WARN_ON(!ret);
 


