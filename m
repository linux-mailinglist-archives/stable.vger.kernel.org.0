Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7CCB2A5676
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732696AbgKCU7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:59:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:35208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732595AbgKCU7u (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:59:50 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3DE522226;
        Tue,  3 Nov 2020 20:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437190;
        bh=NxqE1FSMd0WMwGTNxS+IXqBEYByHxythC4dwMbHPXrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rSM0gHGB0/TfuX62yizMpnQ18178SilpQxWB+Tj8h0SWaVkk3+a84Fvn8u/hShKQp
         0LfcIQ8qDJIjprC0GkE8Yuux7R1uwliqEDrt4YBZI7rSJuD/9wssgnoTWN7Pg1ie81
         FFScZx0tDzSf508aXY84EiaErgzJhn1M0WO/53RU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Madhav Chauhan <madhav.chauhan@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 184/214] drm/amdgpu: increase the reserved VM size to 2MB
Date:   Tue,  3 Nov 2020 21:37:12 +0100
Message-Id: <20201103203307.950048751@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

commit 55bb919be4e4973cd037a04f527ecc6686800437 upstream.

Ideally this should be a multiple of the VM block size.
2MB should at least fit for Vega/Navi.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Madhav Chauhan <madhav.chauhan@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
@@ -105,8 +105,8 @@ struct amdgpu_bo_list_entry;
 #define AMDGPU_MMHUB_0				1
 #define AMDGPU_MMHUB_1				2
 
-/* hardcode that limit for now */
-#define AMDGPU_VA_RESERVED_SIZE			(1ULL << 20)
+/* Reserve 2MB at top/bottom of address space for kernel use */
+#define AMDGPU_VA_RESERVED_SIZE			(2ULL << 20)
 
 /* max vmids dedicated for process */
 #define AMDGPU_VM_MAX_RESERVED_VMID	1


