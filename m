Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DD83E8185
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236969AbhHJSAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:00:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235507AbhHJRzt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:55:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5085761368;
        Tue, 10 Aug 2021 17:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617491;
        bh=q6uivgyUV7KEvDEwM65695+vZNGl1jfW3kizJQCu224=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k6ZbrhEloNPUwRMCnan/KHkwghRpN/J8ggge7tFziuymjBTBwTnRHep4fJMiEU7w2
         Coppt2DaTI4cswASBqrUoLyStFWWujqubPThaParJuVxnzLt7BQI2P+OOZw1rE25e6
         a8GTWV2FPcHZaub+zQ5yanUxy26rH3yXyPL9N09c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shirish S <shirish.s@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.13 082/175] drm/amdgpu/display: fix DMUB firmware version info
Date:   Tue, 10 Aug 2021 19:29:50 +0200
Message-Id: <20210810173003.644661735@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shirish S <shirish.s@amd.com>

commit 0e99e960ce6d5ff586fc0733bc393c087f52c27b upstream.

DMUB firmware info is printed before it gets initialized.
Correct this order to ensure true value is conveyed.

Signed-off-by: Shirish S <shirish.s@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1493,6 +1493,7 @@ static int dm_dmub_sw_init(struct amdgpu
 	}
 
 	hdr = (const struct dmcub_firmware_header_v1_0 *)adev->dm.dmub_fw->data;
+	adev->dm.dmcub_fw_version = le32_to_cpu(hdr->header.ucode_version);
 
 	if (adev->firmware.load_type == AMDGPU_FW_LOAD_PSP) {
 		adev->firmware.ucode[AMDGPU_UCODE_ID_DMCUB].ucode_id =
@@ -1506,7 +1507,6 @@ static int dm_dmub_sw_init(struct amdgpu
 			 adev->dm.dmcub_fw_version);
 	}
 
-	adev->dm.dmcub_fw_version = le32_to_cpu(hdr->header.ucode_version);
 
 	adev->dm.dmub_srv = kzalloc(sizeof(*adev->dm.dmub_srv), GFP_KERNEL);
 	dmub_srv = adev->dm.dmub_srv;


