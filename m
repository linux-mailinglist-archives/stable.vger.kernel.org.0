Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC93C3A00E1
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235237AbhFHSsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:48:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234037AbhFHSql (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:46:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 078F1613E3;
        Tue,  8 Jun 2021 18:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177453;
        bh=ZydBe+WbxvdkA978sXK0CL0ac0+RQtvWqBWwEd+hHpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JmlSV6If6LM4RS9tduoc1CTMbv6XpaggvV5jIwf1oYR7UjBAs/MonYCzfjzJSNrul
         /KGh7ajfhXuERnFd/+p2oPR8c4silOmvZj1Uwe+Y7sC7cj8nIYvKVw37tycOFTPfjp
         fQxjJ49TPoDPQRznFb+PDusfgpE65kQATrRvau4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nirmoy Das <nirmoy.das@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 57/78] drm/amdgpu: make sure we unpin the UVD BO
Date:   Tue,  8 Jun 2021 20:27:26 +0200
Message-Id: <20210608175937.200831606@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nirmoy Das <nirmoy.das@amd.com>

commit 07438603a07e52f1c6aa731842bd298d2725b7be upstream.

Releasing pinned BOs is illegal now. UVD 6 was missing from:
commit 2f40801dc553 ("drm/amdgpu: make sure we unpin the UVD BO")

Fixes: 2f40801dc553 ("drm/amdgpu: make sure we unpin the UVD BO")
Cc: stable@vger.kernel.org
Signed-off-by: Nirmoy Das <nirmoy.das@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c
@@ -354,6 +354,7 @@ static int uvd_v6_0_enc_ring_test_ib(str
 
 error:
 	dma_fence_put(fence);
+	amdgpu_bo_unpin(bo);
 	amdgpu_bo_unreserve(bo);
 	amdgpu_bo_unref(&bo);
 	return r;


