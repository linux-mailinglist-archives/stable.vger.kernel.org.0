Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C720330E64
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhCHMgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:36:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:46280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230342AbhCHMg0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:36:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF3A5651FF;
        Mon,  8 Mar 2021 12:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206986;
        bh=YWeU1KnKf/SHh08i/Qvb6i2gRS8i46xKYdXDHJRBZBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z9c2iHf1X0CZTMPEphAzSNAlf20rQDqSFNH97gwmFXSo2P5XirUC/ppjM2B6eWoHK
         tY+G6t1dkz11Hb2R8hBfc4Kwygmis9WeGLGFTiDuD/fm+HeI+DnR9LMUn6TClZPrY1
         RCZ/qhE8ER0oXf6JAH+KrrjwWUamyzSCNsqX8hws=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Wang <kevin1.wang@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 28/44] drm/amdgpu: fix parameter error of RREG32_PCIE() in amdgpu_regs_pcie
Date:   Mon,  8 Mar 2021 13:35:06 +0100
Message-Id: <20210308122719.947315475@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
References: <20210308122718.586629218@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Kevin Wang <kevin1.wang@amd.com>

commit 1aa46901ee51c1c5779b3b239ea0374a50c6d9ff upstream.

the register offset isn't needed division by 4 to pass RREG32_PCIE()

Signed-off-by: Kevin Wang <kevin1.wang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -356,7 +356,7 @@ static ssize_t amdgpu_debugfs_regs_pcie_
 	while (size) {
 		uint32_t value;
 
-		value = RREG32_PCIE(*pos >> 2);
+		value = RREG32_PCIE(*pos);
 		r = put_user(value, (uint32_t *)buf);
 		if (r) {
 			pm_runtime_mark_last_busy(adev_to_drm(adev)->dev);
@@ -423,7 +423,7 @@ static ssize_t amdgpu_debugfs_regs_pcie_
 			return r;
 		}
 
-		WREG32_PCIE(*pos >> 2, value);
+		WREG32_PCIE(*pos, value);
 
 		result += 4;
 		buf += 4;


