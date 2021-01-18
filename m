Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637FE2F9E8C
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390741AbhARLmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:42:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:37938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388852AbhARLmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:42:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EF1222227;
        Mon, 18 Jan 2021 11:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970105;
        bh=Iz9suBUobb5QOaUb3ui3gi1MHAkT4knNtmy5HQe/irg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HoWKFE6FY99qT6pC3NLtjqzjPTb0fU7+/8Y3KGowq2hBu8McDdrAwetTvyOolUo6P
         nA3RbNnKrnl0fPPmdxc40UEE3Lq9whJGxOD8N4daxLLIl2Jid4ZBj+fxyC0dBimcMx
         r0eughbWf3XtXxqqNKi0VJkvgttp74v37o25/Qgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Demers <alexandre.f.demers@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 009/152] drm/amdgpu: fix DRM_INFO flood if display core is not supported (bug 210921)
Date:   Mon, 18 Jan 2021 12:33:04 +0100
Message-Id: <20210118113353.215516490@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Demers <alexandre.f.demers@gmail.com>

commit ff9346dbabbb6595c5c20d90d88ae4a2247487a9 upstream.

This fix bug 210921 where DRM_INFO floods log when hitting an unsupported ASIC in
amdgpu_device_asic_has_dc_support(). This info should be only called once.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=210921
Signed-off-by: Alexandre Demers <alexandre.f.demers@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3008,7 +3008,7 @@ bool amdgpu_device_asic_has_dc_support(e
 #endif
 	default:
 		if (amdgpu_dc > 0)
-			DRM_INFO("Display Core has been requested via kernel parameter "
+			DRM_INFO_ONCE("Display Core has been requested via kernel parameter "
 					 "but isn't supported by ASIC, ignoring\n");
 		return false;
 	}


