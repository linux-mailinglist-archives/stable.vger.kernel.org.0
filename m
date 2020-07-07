Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715E32171A3
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgGGPXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729347AbgGGPXA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:23:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1DFC2065D;
        Tue,  7 Jul 2020 15:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135379;
        bh=Q8fB8wIWAkntYlaLQqD7YhS0waYCcldxL0PkeKniStw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tp5f/hgezPcLXFxYb3b734rPQVzWxXtp6WcY2vvV/O8uUSIcFFnBic9LffKdc7MQR
         +qsSuJTjwiz+6xLtjAfPkpvW0x/PqLZ1/EHBKPCc2l1TBaNOzqpAUwSGJtMvvZ2DuA
         knk2xo+JWSX4hKayMW2Po3iYe2a0e6VqQMjkYVuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        John Clements <John.Clements@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 018/112] drm/amdgpu: fix non-pointer dereference for non-RAS supported
Date:   Tue,  7 Jul 2020 17:16:23 +0200
Message-Id: <20200707145801.863243602@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit a9d82d2f91297679cfafd7e61c4bccdca6cd550d ]

Backtrace on gpu recover test on Navi10.

[ 1324.516681] RIP: 0010:amdgpu_ras_set_error_query_ready+0x15/0x20 [amdgpu]
[ 1324.523778] Code: 4c 89 f7 e8 cd a2 a0 d8 e9 99 fe ff ff 45 31 ff e9 91 fe ff ff 0f 1f 44 00 00 55 48 85 ff 48 89 e5 74 0e 48 8b 87 d8 2b 01 00 <40> 88 b0 38 01 00 00 5d c3 66 90 0f 1f 44 00 00 55 31 c0 48 85 ff
[ 1324.543452] RSP: 0018:ffffaa1040e4bd28 EFLAGS: 00010286
[ 1324.549025] RAX: 0000000000000000 RBX: ffff911198b20000 RCX: 0000000000000000
[ 1324.556217] RDX: 00000000000c0a01 RSI: 0000000000000000 RDI: ffff911198b20000
[ 1324.563514] RBP: ffffaa1040e4bd28 R08: 0000000000001000 R09: ffff91119d0028c0
[ 1324.570804] R10: ffffffff9a606b40 R11: 0000000000000000 R12: 0000000000000000
[ 1324.578413] R13: ffffaa1040e4bd70 R14: ffff911198b20000 R15: 0000000000000000
[ 1324.586464] FS:  00007f4441cbf540(0000) GS:ffff91119ed80000(0000) knlGS:0000000000000000
[ 1324.595434] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1324.601345] CR2: 0000000000000138 CR3: 00000003fcdf8004 CR4: 00000000003606e0
[ 1324.608694] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1324.616303] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1324.623678] Call Trace:
[ 1324.626270]  amdgpu_device_gpu_recover+0x6e7/0xc50 [amdgpu]
[ 1324.632018]  ? seq_printf+0x4e/0x70
[ 1324.636652]  amdgpu_debugfs_gpu_recover+0x50/0x80 [amdgpu]
[ 1324.643371]  seq_read+0xda/0x420
[ 1324.647601]  full_proxy_read+0x5c/0x90
[ 1324.652426]  __vfs_read+0x1b/0x40
[ 1324.656734]  vfs_read+0x8e/0x130
[ 1324.660981]  ksys_read+0xa7/0xe0
[ 1324.665201]  __x64_sys_read+0x1a/0x20
[ 1324.669907]  do_syscall_64+0x57/0x1c0
[ 1324.674517]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1324.680654] RIP: 0033:0x7f44417cf081

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: John Clements <John.Clements@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index aa6148d12d5a4..b0aa4e1ed4df7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -82,13 +82,13 @@ static bool amdgpu_ras_check_bad_page(struct amdgpu_device *adev,
 
 void amdgpu_ras_set_error_query_ready(struct amdgpu_device *adev, bool ready)
 {
-	if (adev)
+	if (adev && amdgpu_ras_get_context(adev))
 		amdgpu_ras_get_context(adev)->error_query_ready = ready;
 }
 
 bool amdgpu_ras_get_error_query_ready(struct amdgpu_device *adev)
 {
-	if (adev)
+	if (adev && amdgpu_ras_get_context(adev))
 		return amdgpu_ras_get_context(adev)->error_query_ready;
 
 	return false;
-- 
2.25.1



