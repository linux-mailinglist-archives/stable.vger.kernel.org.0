Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B77A171BAC
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387612AbgB0OEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:04:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:40906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387608AbgB0OEd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:04:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02D6224656;
        Thu, 27 Feb 2020 14:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812273;
        bh=rOI0t9RzGir2DjflE4Nm04I1/feyMEd+TxAH4NnWaNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tICRW15WVEXcRv5qwgLXoTd+CAwPBRW/ogvg7uw8ArwzOEQ3lZ7zxEU7DHRQoWWz8
         3lJAJ2LJB+re2Syhr22fLni2FzyURf7XhvxhlKw0IEfMR0hEu2BvjnldoXVZ9T6KSv
         wwyoY/92cnrFfpXsmOezn8+Gcn6i6WfPPwAJsS8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 4.19 50/97] drm/amdgpu/soc15: fix xclk for raven
Date:   Thu, 27 Feb 2020 14:36:58 +0100
Message-Id: <20200227132222.796136919@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132214.553656188@linuxfoundation.org>
References: <20200227132214.553656188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit c657b936ea98630ef5ba4f130ab1ad5c534d0165 upstream.

It's 25 Mhz (refclk / 4).  This fixes the interpretation
of the rlc clock counter.

Acked-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/soc15.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -205,7 +205,12 @@ static u32 soc15_get_config_memsize(stru
 
 static u32 soc15_get_xclk(struct amdgpu_device *adev)
 {
-	return adev->clock.spll.reference_freq;
+	u32 reference_clock = adev->clock.spll.reference_freq;
+
+	if (adev->asic_type == CHIP_RAVEN)
+		return reference_clock / 4;
+
+	return reference_clock;
 }
 
 


