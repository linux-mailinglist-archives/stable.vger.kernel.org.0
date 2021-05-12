Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98CAD37CCCB
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235550AbhELQrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:47:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243573AbhELQle (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:41:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A134E61984;
        Wed, 12 May 2021 16:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835508;
        bh=+DjlCxK49GG544gUXooFh6iAaJ7Zqe2xhI9369vmbjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EBuakcmM1eZLJX12LuUE5km4r+RRotpLoVLJvW94JCyU27juxOVI1jYUDCFwEM08Y
         HUOp4YlM2MBR52/WncWtrfQQkMUk8tJGf7mrr5eItbNfs2iSDdxEOnsoYDT2yZjdVm
         qG7Xsfz4VUnv9nw6c4pakpdptpuok/yDU5a57AXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Victor Lu <victorchengchi.lu@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 371/677] drm/amd/display: Free local data after use
Date:   Wed, 12 May 2021 16:46:57 +0200
Message-Id: <20210512144849.646718793@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Victor Lu <victorchengchi.lu@amd.com>

[ Upstream commit 616cf23b6cf40ad6f03ffbddfa1b6c4eb68d8ae1 ]

Fixes the following memory leak in dc_link_construct():

unreferenced object 0xffffa03e81471400 (size 1024):
comm "amd_module_load", pid 2486, jiffies 4294946026 (age 10.544s)
hex dump (first 32 bytes):
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
backtrace:
[<000000000bdf5c4a>] kmem_cache_alloc_trace+0x30a/0x4a0
[<00000000e7c59f0e>] link_create+0xce/0xac0 [amdgpu]
[<000000002fb6c072>] dc_create+0x370/0x720 [amdgpu]
[<000000000094d1f3>] amdgpu_dm_init+0x18e/0x17a0 [amdgpu]
[<00000000bec048fd>] dm_hw_init+0x12/0x20 [amdgpu]
[<00000000a2bb7cf6>] amdgpu_device_init+0x1463/0x1e60 [amdgpu]
[<0000000032d3bb13>] amdgpu_driver_load_kms+0x5b/0x330 [amdgpu]
[<00000000a27834f9>] amdgpu_pci_probe+0x192/0x280 [amdgpu]
[<00000000fec7d291>] local_pci_probe+0x47/0xa0
[<0000000055dbbfa7>] pci_device_probe+0xe3/0x180
[<00000000815da970>] really_probe+0x1c4/0x4e0
[<00000000b4b6974b>] driver_probe_device+0x62/0x150
[<000000000f9ecc61>] device_driver_attach+0x58/0x60
[<000000000f65c843>] __driver_attach+0xd6/0x150
[<000000002f5e3683>] bus_for_each_dev+0x6a/0xc0
[<00000000a1cfc897>] driver_attach+0x1e/0x20

Fixes: 3a00c04212d1cf ("drm/amd/display/dc/core/dc_link: Move some local data from the stack to the heap")
Signed-off-by: Victor Lu <victorchengchi.lu@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index bd0101013ec8..440bf0a0e12a 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -1603,6 +1603,7 @@ static bool dc_link_construct(struct dc_link *link,
 	link->psr_settings.psr_version = DC_PSR_VERSION_UNSUPPORTED;
 
 	DC_LOG_DC("BIOS object table - %s finished successfully.\n", __func__);
+	kfree(info);
 	return true;
 device_tag_fail:
 	link->link_enc->funcs->destroy(&link->link_enc);
-- 
2.30.2



