Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59FD53AAA8
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730494AbfFIQqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:46:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730508AbfFIQqd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:46:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACD8D2081C;
        Sun,  9 Jun 2019 16:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098793;
        bh=LDAErhTgldvVUzf3wXt11d1c2wKcCbcc1Y/hoi6y5E8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ANk61pUxfvdUvPOeEsXNKFI/qBZW8ro8cx2KO9rJX0KGKzXCh8c6XHXXa56DuCjGP
         zL1mbSORt+yy9B3iCVKsM/4ghKBv6OdTRLilFt7TIctLiagoTVeWGrLHtFpwOBGU88
         iw2N2CLByuR4O5P9+zksQYg984lmcAF2JcAdG6Zk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Louis Li <Ching-shih.Li@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.1 63/70] drm/amdgpu: fix ring test failure issue during s3 in vce 3.0 (V2)
Date:   Sun,  9 Jun 2019 18:42:14 +0200
Message-Id: <20190609164132.727504869@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Louis Li <Ching-shih.Li@amd.com>

commit ce0e22f5d886d1b56c7ab4347c45b9ac5fcc058d upstream.

[What]
vce ring test fails consistently during resume in s3 cycle, due to
mismatch read & write pointers.
On debug/analysis its found that rptr to be compared is not being
correctly updated/read, which leads to this failure.
Below is the failure signature:
	[drm:amdgpu_vce_ring_test_ring] *ERROR* amdgpu: ring 12 test failed
	[drm:amdgpu_device_ip_resume_phase2] *ERROR* resume of IP block <vce_v3_0> failed -110
	[drm:amdgpu_device_resume] *ERROR* amdgpu_device_ip_resume failed (-110).

[How]
fetch rptr appropriately, meaning move its read location further down
in the code flow.
With this patch applied the s3 failure is no more seen for >5k s3 cycles,
which otherwise is pretty consistent.

V2: remove reduntant fetch of rptr

Signed-off-by: Louis Li <Ching-shih.Li@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vce.c
@@ -1072,7 +1072,7 @@ void amdgpu_vce_ring_emit_fence(struct a
 int amdgpu_vce_ring_test_ring(struct amdgpu_ring *ring)
 {
 	struct amdgpu_device *adev = ring->adev;
-	uint32_t rptr = amdgpu_ring_get_rptr(ring);
+	uint32_t rptr;
 	unsigned i;
 	int r, timeout = adev->usec_timeout;
 
@@ -1084,6 +1084,8 @@ int amdgpu_vce_ring_test_ring(struct amd
 	if (r)
 		return r;
 
+	rptr = amdgpu_ring_get_rptr(ring);
+
 	amdgpu_ring_write(ring, VCE_CMD_END);
 	amdgpu_ring_commit(ring);
 


