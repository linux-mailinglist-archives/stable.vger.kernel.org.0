Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9AC524BCB6
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgHTMvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:51:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728845AbgHTJnv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:43:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18BF9207DE;
        Thu, 20 Aug 2020 09:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916631;
        bh=GtoAiz2dXQyGy3F3OjN1t/VVSZB76SNZaVG7ljVY/TI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XqZmmG1EPIUX2/57H/Pb/0sNIQHsxkuhIUJA0BXleK7wfCh53+hpPoJpnMGs4DDtN
         6gigje0heGsppsRQ9Gdn3ILdmhwHSeGTt1IbpoKSzlePQez6OOYh2kfD0O1J7joQZW
         PBQAuJ1AasKGbmvluvl7E172uQI6YnU2x8qZ4MaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Huang Rui <ray.huang@amd.com>
Subject: [PATCH 5.7 197/204] drm/amdgpu: fix ordering of psp suspend
Date:   Thu, 20 Aug 2020 11:21:34 +0200
Message-Id: <20200820091616.019837757@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexdeucher@gmail.com>

The ordering of psp_tmr_terminate() and psp_asd_unload()
got reversed when the patches were applied to stable.

This patch does not exist in Linus' tree because the ordering
is correct there.  It got reversed when the patches were applied
to stable.  This patch is for stable only.

Fixes: 22ff658396b446 ("drm/amdgpu: asd function needs to be unloaded in suspend phase")
Fixes: 2c41c968c6f648 ("drm/amdgpu: add TMR destory function for psp")
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.7.x
Cc: Huang Rui <ray.huang@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -1679,15 +1679,15 @@ static int psp_suspend(void *handle)
 		}
 	}
 
-	ret = psp_tmr_terminate(psp);
+	ret = psp_asd_unload(psp);
 	if (ret) {
-		DRM_ERROR("Falied to terminate tmr\n");
+		DRM_ERROR("Failed to unload asd\n");
 		return ret;
 	}
 
-	ret = psp_asd_unload(psp);
+	ret = psp_tmr_terminate(psp);
 	if (ret) {
-		DRM_ERROR("Failed to unload asd\n");
+		DRM_ERROR("Falied to terminate tmr\n");
 		return ret;
 	}
 


