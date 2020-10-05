Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3572A283B67
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728867AbgJEPlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:41:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727260AbgJEP2R (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:28:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CC1320874;
        Mon,  5 Oct 2020 15:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911696;
        bh=+uCky5ErRI0DNHvHp9nXKGNBnPirwBCPrYE75m7NQbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pc2KM/X2zmBLlk27iJt7ni9wZ0zsaCmdbE6bhpomWO9d64XzQqDLEobPazpRV+LO9
         5o/NX4nOBU1wnEuZnT4K76Gf2OV5bG9RVo406Dbg5NBj8DzAiMBJPObiFn/YIrk28h
         r1FQSI+LAbvJU3s5/fqgs186bjdjFq7KLVx4OCD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jean Delvare <jdelvare@suse.de>,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.19 12/38] drm/amdgpu: restore proper ref count in amdgpu_display_crtc_set_config
Date:   Mon,  5 Oct 2020 17:26:29 +0200
Message-Id: <20201005142109.262545314@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142108.650363140@linuxfoundation.org>
References: <20201005142108.650363140@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean Delvare <jdelvare@suse.de>

commit a39d0d7bdf8c21ac7645c02e9676b5cb2b804c31 upstream.

A recent attempt to fix a ref count leak in
amdgpu_display_crtc_set_config() turned out to be doing too much and
"fixed" an intended decrease as if it were a leak. Undo that part to
restore the proper balance. This is the very nature of this function
to increase or decrease the power reference count depending on the
situation.

Consequences of this bug is that the power reference would
eventually get down to 0 while the display was still in use,
resulting in that display switching off unexpectedly.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Fixes: e008fa6fb415 ("drm/amdgpu: fix ref count leak in amdgpu_display_crtc_set_config")
Cc: stable@vger.kernel.org
Cc: Navid Emamdoost <navid.emamdoost@gmail.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
@@ -290,7 +290,7 @@ int amdgpu_display_crtc_set_config(struc
 	   take the current one */
 	if (active && !adev->have_disp_power_ref) {
 		adev->have_disp_power_ref = true;
-		goto out;
+		return ret;
 	}
 	/* if we have no active crtcs, then drop the power ref
 	   we got before */


