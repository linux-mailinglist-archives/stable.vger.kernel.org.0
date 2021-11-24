Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1070545BC69
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242498AbhKXMas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:30:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:42284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244315AbhKXM1C (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:27:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DDB661248;
        Wed, 24 Nov 2021 12:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756186;
        bh=zYXwbgEYWgxlYP9C7v/XibW1lWqX/jwOOw5A2yKDD6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=frWsVw6VSFG1hSEwK16NuH16Vr7sjXB8QglrCj1JllO/skhTR1VGTVOuC5cp04raI
         MOP4z9ya0+YHFy+yWg1R4EHNB7nPMML1ymYfY8iq/CwaI2zfB9SsBz+qbC8ph8CWxm
         rBWeQZfRVMA5WgnMashgvvGA5fYDw1m7TR+CnLG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, hongao <hongao@uniontech.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.9 197/207] drm/amdgpu: fix set scaling mode Full/Full aspect/Center not works on vga and dvi connectors
Date:   Wed, 24 Nov 2021 12:57:48 +0100
Message-Id: <20211124115710.329205326@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
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
@@ -844,6 +844,7 @@ static int amdgpu_connector_vga_get_mode
 
 	amdgpu_connector_get_edid(connector);
 	ret = amdgpu_connector_ddc_get_modes(connector);
+	amdgpu_get_native_mode(connector);
 
 	return ret;
 }


