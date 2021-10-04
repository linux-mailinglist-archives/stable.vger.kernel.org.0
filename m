Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA3E420F72
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236945AbhJDNe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:34:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237701AbhJDNdI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:33:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C217263223;
        Mon,  4 Oct 2021 13:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353294;
        bh=vI/ThSmCYCnrsLHSHczvncB2LQJS+cvNs/OvwovcF64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BTVFE4kNHx7VKmoyUMHqbQGCODYxHXaW3CYRN0IuPK92waN/MeNi3G/FywUqZewtY
         uRCtNt2AQKFa55xkz90uzG/TKSgT0SH/hU/i9gdVKJZtnHk3Fd1ctwkdc6f72QUjTk
         5kFwNN6h8Ui/+HZlgzdfjRNCStd8BzlMHSTkJRx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hawking Zhang <Hawking.Zhang@amd.com>,
        Le Ma <Le.Ma@amd.com>, Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 072/172] drm/amdgpu: correct initial cp_hqd_quantum for gfx9
Date:   Mon,  4 Oct 2021 14:52:02 +0200
Message-Id: <20211004125047.321124595@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hawking Zhang <Hawking.Zhang@amd.com>

commit 9f52c25f59b504a29dda42d83ac1e24d2af535d4 upstream.

didn't read the value of mmCP_HQD_QUANTUM from correct
register offset

Signed-off-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Le Ma <Le.Ma@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -3598,7 +3598,7 @@ static int gfx_v9_0_mqd_init(struct amdg
 
 	/* set static priority for a queue/ring */
 	gfx_v9_0_mqd_set_priority(ring, mqd);
-	mqd->cp_hqd_quantum = RREG32(mmCP_HQD_QUANTUM);
+	mqd->cp_hqd_quantum = RREG32_SOC15(GC, 0, mmCP_HQD_QUANTUM);
 
 	/* map_queues packet doesn't need activate the queue,
 	 * so only kiq need set this field.


