Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80A1420F5E
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237223AbhJDNeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:34:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237461AbhJDNc3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:32:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFB9563221;
        Mon,  4 Oct 2021 13:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353284;
        bh=tmGiThP31HXkGg+WqBTjIxvSxgtWW1HESu9FfhnoEFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zY9JMVzJ/gMetdZ9lrW+9g5j077yqLXcs8cobSlhBTvOvkpBWkEVhVWZMMKeVemb9
         h/BlrUB6jh7Qi+eBZEr1NvMaqp+ex9MGsdyKcA5XglsjIgisf+mj2CtXqpcA0B+tjF
         Jeq5FC3LpLVTo5tu2WWdQHAvcGfPC5yGzfg1CBGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhan Liu <Zhan.Liu@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 068/172] drm/amd/display: Pass PCI deviceid into DC
Date:   Mon,  4 Oct 2021 14:51:58 +0200
Message-Id: <20211004125047.187531102@linuxfoundation.org>
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
@@ -1117,6 +1117,7 @@ static int amdgpu_dm_init(struct amdgpu_
 
 	init_data.asic_id.pci_revision_id = adev->pdev->revision;
 	init_data.asic_id.hw_internal_rev = adev->external_rev_id;
+	init_data.asic_id.chip_id = adev->pdev->device;
 
 	init_data.asic_id.vram_width = adev->gmc.vram_width;
 	/* TODO: initialize init_data.asic_id.vram_type here!!!! */


