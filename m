Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11492441830
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbhKAJpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:45:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234016AbhKAJnw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:43:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD5CF613AD;
        Mon,  1 Nov 2021 09:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758945;
        bh=0Jb+ZtKc3oPBJP7+yme89ilX2XntbeaN0ojNW0zHWUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K7jQALJpS1VvropSBoIWGilkKVEqPXL3mxkp8xxFevIkIuTF09WT3U7tTQiNSHevi
         ddS5+4QXuaR4Yi4waIjyB9LkVIkBLWqJh28xNIv+0eRBKFB5KoPJKSQ9GwGC3rWymg
         c0R6tFwvD7eIg+t2X/bk0MB1eh4UyPYyGfj3Z0p8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Liu <aaron.liu@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 049/125] drm/amdgpu: support B0&B1 external revision id for yellow carp
Date:   Mon,  1 Nov 2021 10:17:02 +0100
Message-Id: <20211101082542.523771288@linuxfoundation.org>
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

From: Aaron Liu <aaron.liu@amd.com>

commit 53c2ff8bcb06acd07e24a62e7f5a0247bd7c6f67 upstream.

B0 internal rev_id is 0x01, B1 internal rev_id is 0x02.
The external rev_id for B0 and B1 is 0x20.
The original expression is not suitable for B1.

v2: squash in fix for display code (Alex)

Signed-off-by: Aaron Liu <aaron.liu@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/nv.c                   |    2 +-
 drivers/gpu/drm/amd/display/include/dal_asic_id.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/nv.c
@@ -1237,7 +1237,7 @@ static int nv_common_early_init(void *ha
 			AMD_PG_SUPPORT_VCN_DPG |
 			AMD_PG_SUPPORT_JPEG;
 		if (adev->pdev->device == 0x1681)
-			adev->external_rev_id = adev->rev_id + 0x19;
+			adev->external_rev_id = 0x20;
 		else
 			adev->external_rev_id = adev->rev_id + 0x01;
 		break;
--- a/drivers/gpu/drm/amd/display/include/dal_asic_id.h
+++ b/drivers/gpu/drm/amd/display/include/dal_asic_id.h
@@ -227,7 +227,7 @@ enum {
 #define FAMILY_YELLOW_CARP                     146
 
 #define YELLOW_CARP_A0 0x01
-#define YELLOW_CARP_B0 0x1A
+#define YELLOW_CARP_B0 0x20
 #define YELLOW_CARP_UNKNOWN 0xFF
 
 #ifndef ASICREV_IS_YELLOW_CARP


