Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E912328DAC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241260AbhCATPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:15:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241029AbhCATLD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:11:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FA4B64F9C;
        Mon,  1 Mar 2021 17:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619612;
        bh=DWZ3pK/jmt/+ZAEw5AcDxxcpf5sJ42lwJvEL4f1PAYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VYNd/lLF/Pxg10kYod8X1YTVEirVkaUKSxajC5lMt511NGGy0tLj3FaDE8dz969RT
         NiKFG+gNmUNgc9ZJ3+kQZV6fJyimWbaurYqRDzRwG2vZpRl/WGC2g9p44cxRV3rYRB
         c1+skfNUtb9WWZigCCStwpGs62MXS4j3AE+L5kek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 517/663] drm/amdgpu: Set reference clock to 100Mhz on Renoir (v2)
Date:   Mon,  1 Mar 2021 17:12:45 +0100
Message-Id: <20210301161207.436130823@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 6e80fb8ab04f6c4f377e2fd422bdd1855beb7371 upstream.

Fixes the rlc reference clock used for GPU timestamps.
Value is 100Mhz.  Confirmed with hardware team.

v2: reword commit message.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1480
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/soc15.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -246,6 +246,8 @@ static u32 soc15_get_xclk(struct amdgpu_
 {
 	u32 reference_clock = adev->clock.spll.reference_freq;
 
+	if (adev->asic_type == CHIP_RENOIR)
+		return 10000;
 	if (adev->asic_type == CHIP_RAVEN)
 		return reference_clock / 4;
 


