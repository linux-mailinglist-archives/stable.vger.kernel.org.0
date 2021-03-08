Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28EC1330E21
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhCHMfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:35:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:44216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232064AbhCHMfL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:35:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E54864EBC;
        Mon,  8 Mar 2021 12:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206910;
        bh=Rh/ElCYixtjbU3HjllVEZDy8BptIUC+6CwBIuGiiYNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pkc4HSWIGGntrRL9r9t8v+rMYifDfyR8PUEHSwgXs12Pd/5Zp5Q0GZdRfo2aowz9D
         sQ1qV9hO+klQvxZp0Fbbb1M2YAvNhPlZVPo/o7XrIwivYki8bf33gNPkJ2Xa0WW79/
         ZhPSLGI/vL6tEIDb8ToNwlQRPaAvwiNoaVh0wDdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Wang <kevin1.wang@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 22/42] drm/amdgpu: fix parameter error of RREG32_PCIE() in amdgpu_regs_pcie
Date:   Mon,  8 Mar 2021 13:30:48 +0100
Message-Id: <20210308122719.214925954@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.120213856@linuxfoundation.org>
References: <20210308122718.120213856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
@@ -355,7 +355,7 @@ static ssize_t amdgpu_debugfs_regs_pcie_
 	while (size) {
 		uint32_t value;
 
-		value = RREG32_PCIE(*pos >> 2);
+		value = RREG32_PCIE(*pos);
 		r = put_user(value, (uint32_t *)buf);
 		if (r) {
 			pm_runtime_mark_last_busy(adev_to_drm(adev)->dev);
@@ -422,7 +422,7 @@ static ssize_t amdgpu_debugfs_regs_pcie_
 			return r;
 		}
 
-		WREG32_PCIE(*pos >> 2, value);
+		WREG32_PCIE(*pos, value);
 
 		result += 4;
 		buf += 4;


