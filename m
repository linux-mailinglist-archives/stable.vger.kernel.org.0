Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1B02597A1
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731946AbgIAQQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:16:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728415AbgIAPeP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:34:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2A4520E65;
        Tue,  1 Sep 2020 15:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974455;
        bh=KHsjzeFClu/PBCpyLqSj+E24Yre95oeen+xA2tfS3Tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O0hl3Puk9e8axvxWqjT71pNmmVmSPNmbylNWE0t1Bb+Iv4uslDU2/0OwqabAS21G0
         EVH757Ki4JnX2T8yBLWBBUycyd+ZnOppAKV2WymraXw3c159eDCxjPOAUSnwFrGkSK
         wsV/rWzyKjkNaihrQtD7G7Iz0Q6GSJYklg8JvegI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 182/214] drm/amdgpu: Fix buffer overflow in INFO ioctl
Date:   Tue,  1 Sep 2020 17:11:02 +0200
Message-Id: <20200901151001.680976580@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit b5b97cab55eb71daba3283c8b1d2cce456d511a1 upstream.

The values for "se_num" and "sh_num" come from the user in the ioctl.
They can be in the 0-255 range but if they're more than
AMDGPU_GFX_MAX_SE (4) or AMDGPU_GFX_MAX_SH_PER_SE (2) then it results in
an out of bounds read.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -638,8 +638,12 @@ static int amdgpu_info_ioctl(struct drm_
 		 * in the bitfields */
 		if (se_num == AMDGPU_INFO_MMR_SE_INDEX_MASK)
 			se_num = 0xffffffff;
+		else if (se_num >= AMDGPU_GFX_MAX_SE)
+			return -EINVAL;
 		if (sh_num == AMDGPU_INFO_MMR_SH_INDEX_MASK)
 			sh_num = 0xffffffff;
+		else if (sh_num >= AMDGPU_GFX_MAX_SH_PER_SE)
+			return -EINVAL;
 
 		if (info->read_mmr_reg.count > 128)
 			return -EINVAL;


