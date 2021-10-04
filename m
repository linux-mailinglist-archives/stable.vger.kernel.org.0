Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4240420D98
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbhJDNQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:16:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235840AbhJDNOb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:14:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E79D619F5;
        Mon,  4 Oct 2021 13:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352751;
        bh=6r8EHbHVPHME6qdWdTonUTcrWbCzaRndstbgk5E7s8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hCL814179tZwyhnhOWulX1xy9Xow8w1hBpwz2nS29Y+y5nXfI9ealQ9nqrU7lsNsF
         3OBMmwriTNndWOj+UYqBsA8hk9NnMWN6KAybRJPjdHkIzerDbKsNztpk7Tduug+lpz
         xIxwVebvbXq48jv3TPUpvxMuJVPVfR0/clus6Y+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhan Liu <Zhan.Liu@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 12/56] drm/amd/display: Pass PCI deviceid into DC
Date:   Mon,  4 Oct 2021 14:52:32 +0200
Message-Id: <20211004125030.396669154@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125030.002116402@linuxfoundation.org>
References: <20211004125030.002116402@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charlene Liu <Charlene.Liu@amd.com>

commit d942856865c733ff60450de9691af796ad71d7bc upstream.

[why]
pci deviceid not passed to dal dc, without proper break,
dcn2.x falls into dcn3.x code path

[how]
pass in pci deviceid, and break once dal_version initialized.

Reviewed-by: Zhan Liu <Zhan.Liu@amd.com>
Acked-by: Anson Jacob <Anson.Jacob@amd.com>
Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -664,6 +664,7 @@ static int amdgpu_dm_init(struct amdgpu_
 
 	init_data.asic_id.pci_revision_id = adev->rev_id;
 	init_data.asic_id.hw_internal_rev = adev->external_rev_id;
+	init_data.asic_id.chip_id = adev->pdev->device;
 
 	init_data.asic_id.vram_width = adev->gmc.vram_width;
 	/* TODO: initialize init_data.asic_id.vram_type here!!!! */


