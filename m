Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22FBE45C26B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343926AbhKXN3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:29:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:54122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344450AbhKXN0d (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:26:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A3EF61B95;
        Wed, 24 Nov 2021 12:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758197;
        bh=g4PQPZRmVF5jZ4tDy0Lm3pw9dAOdg4kw3/tlYfA2TK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMfpeeEzAmJhb8hmNqJEwO9WNEm5hqtSnLf6XfzO4k+lS3yQjJc156aQ0ShmAF9v1
         E2P/josqEAVySufoeavz4yqDqoWfyKiMVWQKH96ry0iRiB3QLToC8x36NsqmH6y7zm
         1AE+1ncv2sTH3z4Qm9Lb4DQtnTBASLppx4OFhLL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, hongao <hongao@uniontech.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 090/100] drm/amdgpu: fix set scaling mode Full/Full aspect/Center not works on vga and dvi connectors
Date:   Wed, 24 Nov 2021 12:58:46 +0100
Message-Id: <20211124115657.759962263@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
References: <20211124115654.849735859@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: hongao <hongao@uniontech.com>

commit bf552083916a7f8800477b5986940d1c9a31b953 upstream.

amdgpu_connector_vga_get_modes missed function amdgpu_get_native_mode
which assign amdgpu_encoder->native_mode with *preferred_mode result in
amdgpu_encoder->native_mode.clock always be 0. That will cause
amdgpu_connector_set_property returned early on:
if ((rmx_type != DRM_MODE_SCALE_NONE) &&
	(amdgpu_encoder->native_mode.clock == 0))
when we try to set scaling mode Full/Full aspect/Center.
Add the missing function to amdgpu_connector_vga_get_mode can fix this.
It also works on dvi connectors because
amdgpu_connector_dvi_helper_funcs.get_mode use the same method.

Signed-off-by: hongao <hongao@uniontech.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -829,6 +829,7 @@ static int amdgpu_connector_vga_get_mode
 
 	amdgpu_connector_get_edid(connector);
 	ret = amdgpu_connector_ddc_get_modes(connector);
+	amdgpu_get_native_mode(connector);
 
 	return ret;
 }


