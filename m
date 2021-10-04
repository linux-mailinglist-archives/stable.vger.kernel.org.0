Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C68420E78
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbhJDNZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:25:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236949AbhJDNXj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:23:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5C4861B70;
        Mon,  4 Oct 2021 13:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353017;
        bh=pKIv5ZIEhTmDZth8FWRdX463UbhpyPioYdH+f5mknIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GUbZMK0b0KlMiawdZavlBTfCA5JkSAHP93rnzvSBIkrZInFDP0JbfIDhd7xif/Ml/
         BA1jdPbknpWQDD0D735Dxt+Njx9nSbGnO6ywqW+CUminUBU2SaD01ouG4WXA0Bwniv
         J+GwHP4HOwU8iyUF7LtRiZw65vN/S12etXqmuut8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hawking Zhang <Hawking.Zhang@amd.com>,
        Le Ma <Le.Ma@amd.com>, Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 24/93] drm/amdgpu: correct initial cp_hqd_quantum for gfx9
Date:   Mon,  4 Oct 2021 14:52:22 +0200
Message-Id: <20211004125035.382811357@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
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
@@ -3542,7 +3542,7 @@ static int gfx_v9_0_mqd_init(struct amdg
 
 	/* set static priority for a queue/ring */
 	gfx_v9_0_mqd_set_priority(ring, mqd);
-	mqd->cp_hqd_quantum = RREG32(mmCP_HQD_QUANTUM);
+	mqd->cp_hqd_quantum = RREG32_SOC15(GC, 0, mmCP_HQD_QUANTUM);
 
 	/* map_queues packet doesn't need activate the queue,
 	 * so only kiq need set this field.


