Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 917BE45BAB1
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242489AbhKXMOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:14:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:39084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242758AbhKXMLV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:11:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEB2C610A0;
        Wed, 24 Nov 2021 12:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755583;
        bh=xRXtbWcAuubnsfOMKUQthc7tgrVDUFa3Bu4f/J71dD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nWGeE1NSafxyQ19Bt1mOTvufQvCwbaSKDWNVgYiRAPEQzjxXJ72Km32S3d/ML2n34
         tQ65hlUMLoDONZ4NSNkre0gEVyvjPW0CPixiRKS+dTnUlp54K1OG61+7uuyIjKKnYT
         s5tG1/fnZPXrUGEkc09Rw0p2gDCYRT0nyymkjnr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, hongao <hongao@uniontech.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.4 148/162] drm/amdgpu: fix set scaling mode Full/Full aspect/Center not works on vga and dvi connectors
Date:   Wed, 24 Nov 2021 12:57:31 +0100
Message-Id: <20211124115703.060606308@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
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
@@ -835,6 +835,7 @@ static int amdgpu_connector_vga_get_mode
 
 	amdgpu_connector_get_edid(connector);
 	ret = amdgpu_connector_ddc_get_modes(connector);
+	amdgpu_get_native_mode(connector);
 
 	return ret;
 }


