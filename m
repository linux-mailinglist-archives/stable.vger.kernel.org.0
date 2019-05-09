Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D80991921F
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfEISsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:48:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727525AbfEISsO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:48:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3231217F5;
        Thu,  9 May 2019 18:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427693;
        bh=r/gG9fHbgSH+e8w0+yw+2NRJygv2eH5liffGZQMgvFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oEDdUYVsX5e4P3xVO7ru4qzQ64fQVIhnYfEfsL8qIsQKx541+zci5GCDgNbQGQQIo
         qdnladPp3RPdEYcmvDdPMVwf2oufrOqvXfBBcUumpxNSYxzkqqDIoJosfGNCms0hxe
         XdjqeA+akDrOw++WZUh2hkUWBL+ppZIhgGgihHkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Tianci Yin <tianci.yin@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 34/66] drm/amd/display: fix cursor black issue
Date:   Thu,  9 May 2019 20:42:09 +0200
Message-Id: <20190509181305.612568910@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181301.719249738@linuxfoundation.org>
References: <20190509181301.719249738@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c1cefe115d1cdc460014483319d440b2f0d07c68 ]

[Why]
the member sdr_white_level of struct dc_cursor_attributes was not
initialized, then the random value result that
dcn10_set_cursor_sdr_white_level() set error hw_scale value 0x20D9(normal
value is 0x3c00), this cause the black cursor issue.

[how]
just initilize the obj of struct dc_cursor_attributes to zero to avoid
the random value.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Tianci Yin <tianci.yin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 2b8b892eb846f..76ee2de43ea66 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4028,6 +4028,7 @@ static void handle_cursor_update(struct drm_plane *plane,
 	amdgpu_crtc->cursor_width = plane->state->crtc_w;
 	amdgpu_crtc->cursor_height = plane->state->crtc_h;
 
+	memset(&attributes, 0, sizeof(attributes));
 	attributes.address.high_part = upper_32_bits(address);
 	attributes.address.low_part  = lower_32_bits(address);
 	attributes.width             = plane->state->crtc_w;
-- 
2.20.1



