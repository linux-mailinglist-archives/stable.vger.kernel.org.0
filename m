Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D8728B680
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730666AbgJLNea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:34:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730219AbgJLNeW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:34:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BD49221FC;
        Mon, 12 Oct 2020 13:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509633;
        bh=nwMIGLSalHH474XSDQpTti/ZrSxW2kIZ2qDns1dxeAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2oQEr3A7RbUhLUfzV9DW1iUdipmbOgoYaAtoplkgUHNo4sdboi5U5AMWpIX44bdtV
         B4ayuSDUaR6jFAIGqzGdtvcOApqK0/j5i3EkbkD/3RwTpVdEPDCIpbSaDTLnalAQwq
         hUrk0LoXeVEFyNu1QdjpgG571tMqSSFN36BZkgLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jean Delvare <jdelvare@suse.de>,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.9 06/54] drm/amdgpu: restore proper ref count in amdgpu_display_crtc_set_config
Date:   Mon, 12 Oct 2020 15:26:28 +0200
Message-Id: <20201012132629.892984644@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.585664421@linuxfoundation.org>
References: <20201012132629.585664421@linuxfoundation.org>
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
@@ -283,7 +283,7 @@ int amdgpu_crtc_set_config(struct drm_mo
 	   take the current one */
 	if (active && !adev->have_disp_power_ref) {
 		adev->have_disp_power_ref = true;
-		goto out;
+		return ret;
 	}
 	/* if we have no active crtcs, then drop the power ref
 	   we got before */


