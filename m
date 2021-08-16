Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4303ED5DA
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238816AbhHPNPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:15:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237506AbhHPNNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:13:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E24263290;
        Mon, 16 Aug 2021 13:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119467;
        bh=kLMUIqAwLtwVCXK0g2K9nywdnxS3jMBh4eeFHcow6R0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S9Pjg6xlgj3RYablT42bNLLlEtuXnLRfqLn7Js8gYC9SDDNvx7NFAiZJ3yimthCQ3
         G9G233JFR9ARAmEUsghORvyi4O1NF607qpbuO1J2Y2THPSaTM8TxEvg2fvs4fgpYPl
         ypxD7m4L6vI5blMYKUvC5krSAcQ8kKOQDn2/CTVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guchun Chen <guchun.chen@amd.com>,
        James Zhu <James.Zhu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.13 038/151] drm/amdgpu: handle VCN instances when harvesting (v2)
Date:   Mon, 16 Aug 2021 15:01:08 +0200
Message-Id: <20210816125445.338069240@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 7cbe08a930a132d84b4cf79953b00b074ec7a2a7 upstream.

There may be multiple instances and only one is harvested.

v2: fix typo in commit message

Fixes: 83a0b8639185 ("drm/amdgpu: add judgement when add ip blocks (v2)")
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1673
Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: James Zhu <James.Zhu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -299,6 +299,9 @@ int amdgpu_discovery_reg_base_init(struc
 				  ip->major, ip->minor,
 				  ip->revision);
 
+			if (le16_to_cpu(ip->hw_id) == VCN_HWID)
+				adev->vcn.num_vcn_inst++;
+
 			for (k = 0; k < num_base_address; k++) {
 				/*
 				 * convert the endianness of base addresses in place,
@@ -377,7 +380,7 @@ void amdgpu_discovery_harvest_ip(struct
 {
 	struct binary_header *bhdr;
 	struct harvest_table *harvest_info;
-	int i;
+	int i, vcn_harvest_count = 0;
 
 	bhdr = (struct binary_header *)adev->mman.discovery_bin;
 	harvest_info = (struct harvest_table *)(adev->mman.discovery_bin +
@@ -389,8 +392,7 @@ void amdgpu_discovery_harvest_ip(struct
 
 		switch (le32_to_cpu(harvest_info->list[i].hw_id)) {
 		case VCN_HWID:
-			adev->harvest_ip_mask |= AMD_HARVEST_IP_VCN_MASK;
-			adev->harvest_ip_mask |= AMD_HARVEST_IP_JPEG_MASK;
+			vcn_harvest_count++;
 			break;
 		case DMU_HWID:
 			adev->harvest_ip_mask |= AMD_HARVEST_IP_DMU_MASK;
@@ -399,6 +401,10 @@ void amdgpu_discovery_harvest_ip(struct
 			break;
 		}
 	}
+	if (vcn_harvest_count == adev->vcn.num_vcn_inst) {
+		adev->harvest_ip_mask |= AMD_HARVEST_IP_VCN_MASK;
+		adev->harvest_ip_mask |= AMD_HARVEST_IP_JPEG_MASK;
+	}
 }
 
 int amdgpu_discovery_get_gfx_info(struct amdgpu_device *adev)


